# GsDevKit_home support for SmalltalkCI

### Create rowan_3215_ci stone
```
stoneName=rowan_3215_ci
createStone -g $stoneName 3.2.15
cd $GS_HOME/server/stones/$stoneName

cat -- >> custom_stone.env << EOF
export ROWAN_PROJECTS_HOME=\$GS_HOME/shared/repos
EOF

stopNetldi $stoneName
startNetldi $stoneName

ln -s $GS_HOME/shared/repos/smalltalkCI/gsdevkit/stone/newBuild_rowan_smalltalkci
```

The `newBuild_rowan_smalltalkci` script rebuilds an existing stone:
1. fresh `extent0.dbf`
2. install Rowan
3. install smallCI
4. run test suite

Currently you can use [Jadeite Alpha2.0.1-5g25121c9](https://github.com/ericwinger/Jade/tree/master#jade) ([download](https://github.com/ericwinger/Jade/commit/5650f07b9313a0e96245620df7797f3286d0406a) and [installation instructructions](https://github.com/ericwinger/Jade/commit/5650f07b9313a0e96245620df7797f3286d0406a)) to develop SmalltalkCI using Rowan. 


