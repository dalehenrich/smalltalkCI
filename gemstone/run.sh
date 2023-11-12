################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

# set -x
local STONE_NAME="smalltalkci"
local SUPERDOIT_BRANCH=v4.1
local SUPERDOIT_DOWNLOAD=git@github.com:dalehenrich/superDoit.git
local SUPERDOIT_DOWNLOAD=https://github.com/dalehenrich/superDoit.git
local GSDEVKIT_STONES_BRANCH=v1.1.2
local GSDEVKIT_STONES_DOWNLOAD=git@github.com:GsDevKit/GsDevKit_stones.git
local GSDEVKIT_STONES_DOWNLOAD=https://github.com/GsDevKit/GsDevKit_stones.git
local STONES_DISABLENATIVECODE="false"
local STONES_REGISTRY_NAME=""
local STONES_DIRECTORY=""
local STONE_DIRECTORY=""
local STONE_STARTED=""
local STONES_PROJECTS_HOME=""
local STONES_PROJECT_SET_NAME=devkit
local GEMSTONE_DEBUG=""
local STONES_SUPERDOIT_ROOT=""
local STONES_GSDEVKITSTONES_ROOT=""

vers=`echo "${config_smalltalk}" | sed 's/GemStone64-//'`

local PLATFORM="`uname -sm | tr ' ' '-'`"
case "$PLATFORM" in
    Darwin-arm64)
			local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-arm64.Darwin"
			;;
    Darwin-x86_64)
			local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-i386.Darwin"
			;;
		Linux-x86_64)
		local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-x86_64.Linux"
      ;;
		*)
			echo "This script should only be run on Mac (Darwin-i386 or Darwin-arm64), or Linux (Linux-x86_64) ). The result from \"uname -sm\" is \"`uname -sm`\""
			exit 1
      ;;
esac

echo "GEMSTONE_PRODUCT_NAME=$GEMSTONE_PRODUCT_NAME"

################################################################################
# Clone the superDoit project, install GemStone
################################################################################
gemstone::prepare_superDoit() {
	if [ -d "$STONES_SUPERDOIT_ROOT" ]; then
		pushd $STONES_SUPERDOIT_ROOT
			if [ ! -e "$STONES_SUPERDOIT_ROOT/gemstone/solo/product/version.txt" ] ; then
				echo "ERROR - Existing $STONES_SUPERDOIT_ROOT from --gs-GSDEVKITSTONES option has not bee installed correctly. Expected directory '$STONES_SUPERDOIT_ROOT/gemstone/solo/product' to exist'"
				exit 1
			fi
		popd
	else
		pushd $STONES_PROJECTS_HOME
			if [ -d "$STONES_PROJECTS_HOME/superDoit" ] ; then
				echo "Reusing existing superDoit project directory: $STONES_PROJECTS_HOME/superDoit"
			else
				fold_start clone_superDoit "Cloning superDoit..."
					git clone -b "${SUPERDOIT_BRANCH}" --depth 1 "${SUPERDOIT_DOWNLOAD}"
	 				export PATH="`pwd`/superDoit/bin:`pwd`/superDoit/examples/utility:$PATH"
					fold_start install_superDoit_gemstone "Downloading GemStone for superDoit..."
						install.sh
					fold_end install_superDoit_gemstone
				fold_end clone_superDoit
			fi
			STONES_SUPERDOIT_ROOT=$STONES_PROJECTS_HOME/superDoit
		popd
	fi
	export PATH="${STONES_SUPERDOIT_ROOT}/bin:${STONES_SUPERDOIT_ROOT}/examples/utility:$PATH"
	fold_start versionreport_superDoit "superDoit versionReport.solo..."
		set +e
		versionReport.solo
		status=$?
		set -e
		if [ "$status" != 0 ]; then
			echo "$STONES_SUPERDOIT_ROOT was not properly installed, ensure that $STONES_SUPERDOIT_ROOT/bin/install.sh has been run. Check $STONES_SUPERDOIT_ROOT/gemstone/solo."
			exit 1
		fi
	fold_end versionreport_superDoit
}

################################################################################
# Prepare environment for running GemStone
################################################################################
gemstone::prepare_gemstone() {
  if [ ! -e /opt/gemstone ]
    then
		echo "[Info] Creating /opt/gemstone directory"
    sudo mkdir -p /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    sudo chown $USER:${GROUPS[0]} /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    sudo chmod 770 /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
  else
    echo "[Warning] /opt/gemstone directory already exists"
    echo "to replace it, remove or rename it and rerun this script"
  fi
}
################################################################################
# Clone the GsDevKit_stones project
################################################################################
gemstone::prepare_gsdevkit_stones() {
	fold_start clone_gsdevkit_stones "Cloning GsDevKit_stones..."
		if [ "$STONES_GSDEVKITSTONES_ROOT"x = "x" ]; then
			pushd "$STONES_PROJECTS_HOME"
				if [ ! -d "$STONES_PROJECTS_HOME/GsDevKit_stones" ] ; then
					git clone -b "${GSDEVKIT_STONES_BRANCH}" --depth 1 "${GSDEVKIT_STONES_DOWNLOAD}"
				fi
			STONES_GSDEVKITSTONES_ROOT=$STONES_PROJECTS_HOME/GsDevKit_stones
			popd
		fi
		export PATH="${STONES_GSDEVKITSTONES_ROOT}/bin:$PATH"
		ls ${STONES_GSDEVKITSTONES_ROOT}/bin
		if [ "$STONES_REGISTRY_NAME"x = "x" ]; then
			# set up with default registry and default registry name
			export STONES_DATA_HOME="$SMALLTALK_CI_BUILD/.stones_data_home"
			local urlType=ssh
			if [ "$CI" = "true" ] ; then
				urlType=https
			fi
			STONES_REGISTRY_NAME=smalltalkCI_run
			STONES_HOME=$SMALLTALK_CI_BUILD
			createRegistry.solo $STONES_REGISTRY_NAME --ensure $GEMSTONE_DEBUG
			createProjectSet.solo --registry=$STONES_REGISTRY_NAME --projectSet=$STONES_PROJECT_SET_NAME \
				                 --from=$STONES_GSDEVKITSTONES_ROOT/projectSets/$urlType/devkit.ston $GEMSTONE_DEBUG
			registerProjectDirectory.solo --registry=$STONES_REGISTRY_NAME --projectDirectory=$STONES_PROJECTS_HOME  $GEMSTONE_DEBUG
			cloneProjectsFromProjectSet.solo  --registry=$STONES_REGISTRY_NAME --projectSet=$STONES_PROJECT_SET_NAME \
				                 --projectDirectory=$STONES_PROJECTS_HOME $GEMSTONE_DEBUG
			registerProductDirectory.solo --registry=$STONES_REGISTRY_NAME \
			  --productDirectory=$STONES_HOME/$STONES_REGISTRY_NAME/products $GEMSTONE_DEBUG
			STONES_DIRECTORY=$STONES_HOME/$STONES_REGISTRY_NAME/stones
			registerStonesDirectory.solo --registry=$STONES_REGISTRY_NAME \
			  --stonesDirectory=$STONES_DIRECTORY $GEMSTONE_DEBUG
		else
			if [ "$STONES_DATA_HOME"x = "x" ]; then
				echo "STONES_DATA_HOME must be defined when using --gs-REGISTRY option"
				exit 1
			fi
			if [ "$STONES_HOME"x = "x" ]; then
				echo "STONES_HOME must be defined when using --gs-REGISTRY option"
				exit 1
			fi
			STONES_DIRECTORY=`registryQuery.solo -r $STONES_REGISTRY_NAME --stonesDirectory`
		fi
		registryReport.solo
	fold_end clone_gsdevkit_stones
}

################################################################################
# Create a GemStone stone.
################################################################################
gemstone::prepare_stone() {
  local gemstone_version
	local productPath

  gemstone_version="$(echo $1 | cut -f2 -d-)"

  fold_start create_stone "Creating stone..."
		productPath=`registryQuery.solo -r $STONES_REGISTRY_NAME --product=${gemstone_version}`
		if [ "$productPath"x = "x" ]; then
			downloadGemStone.solo --registry=$STONES_REGISTRY_NAME ${gemstone_version} $GEMSTONE_DEBUG
		fi
		STONE_DIRECTORY=${STONES_DIRECTORY}/$STONE_NAME
		loadTode="true"
		if [ -d "$STONE_DIRECTORY" ] ; then
			newExtent.solo -r $STONES_REGISTRY_NAME -e $STONE_DIRECTORY/snapshots/extent0.tode.dbf $STONE_NAME $GEMSTONE_DEBUG
			loadTode="false"
		else
			todeHome=$STONES_HOME/$STONES_REGISTRY_NAME/tode_home
			if [ ! -d "$todeHome" ]; then
					mkdir "$todeHome"
				registerTodeSharedDir.solo -r $STONES_REGISTRY_NAME --todeHome=$todeHome --populate $GEMSTONE_DEBUG
			fi
			createStone.solo --registry=$STONES_REGISTRY_NAME --template=default_tode \
				--start $STONE_NAME ${gemstone_version} $GEMSTONE_DEBUG
			echo "======================================================="
			echo "STONES_DISABLENATIVECODE=$STONES_DISABLENATIVECODE"
			echo "vers=$vers"
			echo "PLATFORM=$PLATFORM"
			if [[ "$PLATFORM" == "Darwin"* ]]; then
				echo "string tests -> true"
			else
				echo "string tests -> false"
			fi
			if [[ "$STONES_DISABLENATIVECODE" = "true" ]] && [[ $vers = "3.7.0" ]] && [[ "$PLATFORM" == "Darwin"* ]]; then
				echo "multiple clauses test -> true":
			else
				echo "multiple clauses test -> true":
			fi
			echo "======================================================="
			if [[ "$STONES_DISABLENATIVECODE" = "true" ]] && [[ $vers = "3.7.0" ]] && [[ "$PLATFORM" == "Darwin"* ]]; then
				pushd $STONE_DIRECTORY
					# on Darwin, it is necessary to disable native code when using 3.7.0 in certain cases, especially on github
					echo "DISABLING NATIVE CODE"
					cat -- >> gem.conf << EOF
GEM_NATIVE_CODE_ENABLED = 0;
EOF
				popd
			fi
		fi
		STONE_STARTED="TRUE"
		if [ "$loadTode" = "true" ] ; then
			pushd $STONE_DIRECTORY
				loadTode.stone --projectDirectory=$STONES_PROJECTS_HOME $GEMSTONE_DEBUG
				snapshot.stone --extension=tode.dbf snapshots $GEMSTONE_DEBUG
			popd
		fi
  fold_end create_stone
}

################################################################################
# Load project into GemStone stone.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::load_project() {
  local status=0

  fold_start load_server_project "Loading server project..."
 	pushd $STONE_DIRECTORY
# shouldn't have to set GEMSTONE
#		if [ "$GEMSTONE"x = "x" ] ; then
#			export GEMSTONE="`pwd`/product"
#		fi
#		export PATH=$GEMSTONE/bin:$PATH
		loadSmalltalkCIProject.stone --projectRoot=$SMALLTALK_CI_HOME --config_ston=${config_ston} $GEMSTONE_DEBUG
		status=$?
	popd
 fold_end load_server_project

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to load project."
  fi
  check_and_consume_build_status_file
}


################################################################################
# Run tests.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::test_project() {
  local status=0

  fold_start run_tests "Running project tests..."
 	pushd $STONE_DIRECTORY
		testSmalltalkCIProject.stone  --buildDirectory=$SMALLTALK_CI_BUILD --config_ston=${config_ston} --named='${config_smalltalk} Server (${STONE_NAME})' $GEMSTONE_DEBUG
		status=$?
	popd

	if [ "$STONE_STARTED" = "TRUE" ] ; then
    fold_start stop_stone "Stopping stone and netldi..."
      stopStone.solo -r $STONES_REGISTRY_NAME "${STONE_NAME}" -b  $GEMSTONE_DEBUG
    fold_end stop_stone
	fi

	fold_end run_tests 
  if is_nonzero "${status}"; then
    print_error_and_exit "Error while testing server project."
  fi
  check_and_consume_build_status_file

	echo "[success]" > "${BUILD_STATUS_FILE}"
}

################################################################################
# Handle GemStone-specific shared memory needs for Darwin on GitHub.
################################################################################
gemstone::darwin_shared_mem_setup() {

	if is_github_build && is_sudo_enabled; then
		# Update shared memory, for github/Darwin builds, since default Darwin shared memory is too small t run GemStone
		case "$PLATFORM" in
	    Darwin-arm64 | Darwin-x86_64)
				echo "============"
			  totalMem="`sudo sysctl hw.memsize | cut -f2 -d' '`"
			  totalMemMB=$(($totalMem / 1048576))
			  shmmax="`sudo sysctl kern.sysv.shmmax | cut -f2 -d' '`"
			  shmall="`sysctl kern.sysv.shmall | cut -f2 -d' '`"
				
			  shmmaxMB=$(($shmmax / 1048576))
			  shmallMB=$(($shmall / 256))
			
			  # Print current values
			  echo "  Total memory available is $totalMemMB MB"
			  echo "  Max shared memory segment size is $shmmaxMB MB"
			  echo "  Max shared memory allowed is $shmallMB MB"
			
			  # Figure out the max shared memory segment size (shmmax) we want
			  # Use 75% of available memory but not more than 2GB
			  shmmaxNew=$(($totalMem * 3/4))
			  [[ $shmmaxNew -gt 2147483648 ]] && shmmaxNew=2147483648
			  shmmaxNewMB=$(($shmmaxNew / 1048576))
			  # Figure out the max shared memory allowed (shmall) we want
			  # The MacOSX default is 4MB, way too small
			  shmallNew=$(($shmmaxNew / 4096))
			  [[ $shmallNew -lt $shmall ]] && shmallNew=$shmall
			  shmallNewMB=$(($shmallNew / 256))
				echo "shmmaxNew=$shmmaxNew"
				if [[ $shmmaxNew -gt $shmmax ]]; then
					echo "[Info] Increasing max shared memory segment size to $shmmaxNewMB MB"
   				sudo sysctl -w kern.sysv.shmmax=$shmmaxNew
				fi
				echo "shmallNew=$shmallNew"
				if [ $shmallNew -gt $shmall ]; then
					echo "[Info] Increasing max shared memory allowed to $shmallNewMB MB"
					sudo sysctl -w kern.sysv.shmall=$shmallNew
				fi
				echo "============"
				;;
			*)
	      ;;
		esac
	fi
}

################################################################################
# Main entry point for GemStone builds.
################################################################################
run_build() {
  gemstone::parse_options "$@"

  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "GemStone is not supported on '$(uname -s)'"
      ;;
  esac

	if [ ! -d "$STONES_PROJECTS_HOME" ] ; then
		mkdir $STONES_PROJECTS_HOME
	fi
	
	gemstone::darwin_shared_mem_setup
	gemstone::prepare_gemstone
	gemstone::prepare_superDoit
	gemstone::prepare_gsdevkit_stones
  gemstone::prepare_stone "${config_smalltalk}"
  gemstone::load_project
  gemstone::test_project
}
################################################################################
# Handle GemStone-specific options.
################################################################################
gemstone::parse_options() {
  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "GemStone is not supported on '$(uname -s)'"
      ;;
  esac

  while :
  do
    case "${1:-}" in
      --gs-DEBUG)
        GEMSTONE_DEBUG=" --debug"
				shift
        ;;
      --gs-REGISTRY=*)
        STONES_REGISTRY_NAME="${1#*=}"
				shift
        ;;
      --gs-REPOS=*)
        STONES_PROJECTS_HOME="${1#*=}"
				shift
        ;;
      --gs-SUPERDOIT=*)
        STONES_SUPERDOIT_ROOT="${1#*=}"
				shift
        ;;
      --gs-GSDEVKITSTONES=*)
        STONES_GSDEVKITSTONES_ROOT="${1#*=}"
				shift
        ;;
      --gs-DISABLENATIVECODE)
        STONES_DISABLENATIVECODE="true"
        shift
        ;;
      --gs-*)
        print_error_and_exit "Unknown GemStone-specific option: $1"
        ;;
      "")
        break
        ;;
      *)
        shift
        ;;
    esac
  done

	if [ "$STONES_PROJECTS_HOME"x = "x" ]; then
		STONES_PROJECTS_HOME="$SMALLTALK_CI_BUILD/repos"
	fi
}

