################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################ 

local DEFAULT_DEVKIT_BRANCH="master"
local DEFAULT_GS_HOME="${SMALLTALK_CI_BUILD}/GsDevKit_home"
local DEVKIT_BRANCH="${DEFAULT_DEVKIT_BRANCH}"
local DEVKIT_DOWNLOAD="https://github.com/GsDevKit/GsDevKit_home.git"
local PHARO_CHANGES_FILE="Pharo-3.0.changes"
local PHARO_IMAGE_FILE="Pharo-3.0.image"
local STONE_NAME="travis"
local USE_DEFAULT_HOME="true"

################################################################################
# Clone the GsDevKit_home project.
################################################################################
gemstone::prepare_gsdevkit_home() {
  if [[ "${USE_DEFAULT_HOME}" = "true" ]]; then
    travis_fold start clone_gsdevkit "Cloning GsDevKit..."
      timer_start

      pushd "${SMALLTALK_CI_BUILD}"
        git clone -b "${DEVKIT_BRANCH}" --depth 1 "${DEVKIT_DOWNLOAD}"
        cd "${GS_HOME}"
        # pre-clone /sys/local, so that travis can skip backups
        ${GS_HOME}/bin/private/clone_sys_local
        # arrange to skip backups
        cp ${GS_HOME}/tests/sys/local/client/tode-scripts/* ${GS_HOME}/sys/local/client/tode-scripts

        cp ${GS_HOME}/tests/sys/local/gsdevkit_bin/* ${GS_HOME}/sys/local/gsdevkit_bin

        # Operating system setup already performed
        touch ${GS_HOME}/bin/.gsdevkitSysSetup

        # Make sure the GsDevKit_home is using $SMALLTALK_CI_HOME in $GS_HOME/shared/repos
        ln -s ${SMALLTALK_CI_HOME} ${GS_HOME}/shared/repos/smalltalkCI

      popd

      timer_finish
    travis_fold end clone_gsdevkit

    export GS_TRAVIS=true # install special key files for running GemStone on Travis hosts

  else
    print_info "Using existing GsDevKit_home clone: \${GS_HOME}=${GS_HOME}"
  fi
}

################################################################################
# Create a GemStone stone.
################################################################################
gemstone::prepare_stone() {
  local gemstone_version

  gemstone_version="$(echo $1 | cut -f2 -d-)"

  if [[ "${USE_DEFAULT_HOME}" = "true" ]]; then
    travis_fold start install_server "Installing server..."
      timer_start

      ${GS_HOME}/bin/installServer

      timer_finish
    travis_fold end install_server
  fi

  if ! is_dir "${SMALLTALK_CI_CACHE}/gemstone"; then
    print_info "Creating GemStone Pharo cache..." 
    if ! is_dir "${SMALLTALK_CI_CACHE}/gemstone/pharo"; then
      mkdir "${SMALLTALK_CI_CACHE}/gemstone/pharo"
    fi
  fi

  if [[ "${TRAVIS_CACHE_ENABLED:-}" = "false" ]] ||
       [[ "${GS_HOME}" != "${DEFAULT_GS_HOME}" ]]; then
    print_info "Travis dependency cache not being used"
  else
    travis_fold start prepare_cache "Preparing Travis caches..."
      timer_start
      if ! is_dir "${SMALLTALK_CI_VMS}/Pharo-3.0"; then
        mkdir "${SMALLTALK_CI_VMS}/Pharo-3.0"
        print_info "Downloading Pharo-3.0 vm to cache" 
        pushd "${SMALLTALK_CI_VMS}/Pharo-3.0" > /dev/null
          download_file "get.pharo.org/vm30" "$(pwd)/zeroconfig"
          bash "$(pwd)/zeroconfig"
        popd > /dev/null
      fi
  
      if ! is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}"; then
        print_info "Downloading Pharo-3.0 image to cache..." 
        pushd ${SMALLTALK_CI_CACHE} > /dev/null
          download_file "get.pharo.org/30" "$(pwd)/pharo30_zeroconfig"
          bash "$(pwd)/pharo30_zeroconfig"
          mv "Pharo.image" "${PHARO_IMAGE_FILE}"
          mv "Pharo.changes" "${PHARO_CHANGES_FILE}"
        popd > /dev/null
      fi
  
      if is_file "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}"; then
        if is_file "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image"; then
          print_info "Utilizing cached gsDevKitCommandLine image..." 
          cp "${SMALLTALK_CI_CACHE}/${PHARO_IMAGE_FILE}" ${GS_HOME}/shared/pharo/Pharo.image
          cp "${SMALLTALK_CI_CACHE}/${PHARO_CHANGES_FILE}" ${GS_HOME}/shared/pharo/Pharo.changes
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo" ${GS_HOME}/shared/pharo/pharo
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo-ui" ${GS_HOME}/shared/pharo/pharo-ui
          ln -s "${SMALLTALK_CI_VMS}/Pharo-3.0/pharo-vm" ${GS_HOME}/shared/pharo/pharo-vm
          cp "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image" ${GS_HOME}/shared/pharo/
          cp "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.changes" ${GS_HOME}/shared/pharo/
        fi
      fi
  
      timer_finish
    travis_fold end prepare_cache
  fi

  travis_fold start create_stone "Creating stone..."
    timer_start

    if is_file "${GS_HOME}/bin/.smalltalkCI_create_arg_supported"; then
      config_stone_create_arg="-z ${config_ston}"
    fi

    if [[ "${TRAVIS_CACHE_ENABLED:-}" = "false" ]]; then
      ${GS_HOME}/bin/createStone ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}"
    else
      ${GS_HOME}/bin/createStone ${config_stone_create_arg:-} "${STONE_NAME}" "${gemstone_version}"
   
      if ! is_file "${SMALLTALK_CI_CACHE}/gemstone/pharo/gsDevKitCommandLine.image"; then
        cp ${GS_HOME}/shared/pharo/gsDevKitCommandLine.* "${SMALLTALK_CI_CACHE}/gemstone/pharo/"
      fi
    fi

    timer_finish
  travis_fold end create_stone
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

  travis_fold start load_server_project "Loading server project..."
    timer_start

    travis_wait ${GS_HOME}/bin/startTopaz "${STONE_NAME}" -l -T 100000 << EOF || status=$?
      iferr 1 stk
      iferr 2 stack
      iferr 3 exit 1
      login
      run
      GsDeployer bulkMigrate: [
        Metacello new
          baseline: 'SmalltalkCI';
          repository: 'filetree://${SMALLTALK_CI_HOME}/repository';
          load: 'Core'.
        System commitTransaction.
        (Smalltalk at: #SmalltalkCI) load: '${config_ston}'.
      ].
%
      logout
      exit 0
EOF

    timer_finish

  travis_fold end load_server_project

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to load project."
  fi
}

################################################################################
# Check intermediate build status and update build_status if necessary.
# Locals:
#   intermediate_build_status
# Globals:
#   build_status
################################################################################
gemstone::check_intermediate_build_status() {
  local intermediate_build_status

  if is_file "${build_status_file}"; then
    intermediate_build_status=$(cat "${build_status_file}")
    if is_nonzero "${intermediate_build_status}"; then
      build_status=1
    fi
  fi
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
  local build_status=0
  local build_status_file="${SMALLTALK_CI_BUILD}/${BUILD_STATUS_FILE}"

  travis_wait ${GS_HOME}/bin/startTopaz "${STONE_NAME}" -l -T 100000 << EOF || status=$?
    iferr 1 stk
    iferr 2 stack
    iferr 3 exit 1
    login
    run
    (Smalltalk at: #SmalltalkCI) test: '${config_ston}' named: '${config_smalltalk} Server (${STONE_NAME})'.
%
    logout
    exit 0
EOF

  if is_nonzero "${status}"; then
    print_error_and_exit "Error while testing server project."
  fi
  gemstone::check_intermediate_build_status

  travis_fold start stop_stone "Stopping stone..."
  ${GS_HOME}/bin/stopStone -b "${STONE_NAME}"
  travis_fold end stop_stone
}

################################################################################
# Main entry point for GemStone builds.
################################################################################
run_build() {
  gemstone::parse_options "$@"

  # To bypass cached behavior for local build, export TRAVIS_CACHE_ENABLED
  # before calling run.sh
  if is_empty "${TRAVIS_CACHE_ENABLED:-}"; then
    TRAVIS_CACHE_ENABLED="true"
    if is_empty "${CASHER_DIR:-}"; then
      if is_travis_build; then
        TRAVIS_CACHE_ENABLED="false"
      fi
    fi
  fi
  export TRAVIS_CACHE_ENABLED

  gemstone::prepare_gsdevkit_home
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

  GS_HOME="${DEFAULT_GS_HOME}"

  if is_not_empty "${GSCI_DEVKIT_BRANCH:-}"; then
    DEVKIT_BRANCH="${GSCI_DEVKIT_BRANCH}"
  fi

  while :
  do
    case "${1:-}" in
      --gs-HOME=*)
        GS_HOME="${1#*=}"
        shift
        USE_DEFAULT_HOME="false"
        ;;
      --gs-BRANCH=*)
        DEVKIT_BRANCH="${1#*=}"
        shift
        ;;
      --gs-CLIENTS=*)
	print_error_and_exit "gs-CLIENTS option not currently supported on GemStone64 (base) platform"
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

  export GS_HOME
}
