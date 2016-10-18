*smalltalkci-gemstone64-core
allPackageNames
  | pkgNames |
  pkgNames := Set new.
  ((MetacelloProjectRegistration registry baselineRegistry values
    select: [ :projectRegistration | projectRegistration loadedInImage ])
    collect: [ :each | each projectName ])
    do: [ :projName | pkgNames addAll: (((MetacelloProjectRegistration registry
        registrationForClassNamed: projName
        ifAbsent: [  ]) baselineProjectSpec version packages
        select: [ :pkg | pkg isPackageLoaded ])
        collect: [ :pkgSpec | pkgSpec name ]) ].
  ^pkgNames asArray
