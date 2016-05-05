#!/bin/bash

set -u ;

DEBUG=2 ;
tryOptsUtil=code_option_trier ;
theseOptions=../.code_options ;
builtOptions=../built_options ;
builtTmp=build ;

log=$(basename $0 | sed -e 's/[.][^.]*$//') ;
elog="$log.log.stderr" ;
log="$log.log.stdout" ;

die() { echo $1 ; exit ${2:-1} ;
}

[[ $DEBUG -lt 3 ]] || echo "DEBUG: dirname \$0: '$(dirname $0)' ." 1>&2 ;
cd $(dirname $0) || die "ERROR: Failed to cd $(dirname $0): $? ." ;
thisD=$(pwd) ;
[[ $DEBUG -lt 3 ]] || echo "DEBUG: thisD: '$thisD' ." 1>&2 ;

elog="$thisD/$elog" ;
log="$thisD/$log" ;

execute() {
  "$@" | tee -a $elog || die "ERROR: execute: $@: $?" >> $elog ;
}
vexecute() {
  echo "$@" >> $elog ;
  "$@" | tee -a $elog || die "ERROR: execute: $@: $?" >> $elog ;
  echo >> $elog ;
}
lexecute() { execute "$@" >> $log
}
vlexecute() { vexecute "$@" >> $log
}

# BEGIN GLOBAL VARIABLES
tryOptsD='' ;
relTryOptsD='' ;
# END GLOBAL VARIABLES

main() {
  [[ -e ../_code_opts ]] || ( cd .. && ln -s "$(basename $theseOptions)/" _code_opts ) ;
  # tryOptsD=`execute findTryOpts` ;
  findTryOpts ;
  echo "Try options dir: '$tryOptsD' ." ;
  echo "Relative: '$relTryOptsD' ." ;
  [[ $tryOptsD ]] || die "ERROR: Failed to find options trier." ;
  try_these_options ;
}
findTryOpts() {
  if [[ $tryOptsD && -e $tryOptsD ]] ; then
    echo $tryOptsD ;
  else
    local maxLoops=99 ;
    local rel='.' ;
    local readlink=$(readlink -f "$rel" 2>/dev/null || greadlink -f "$rel" ) ;
    local lastReadlink='' ;
    local loop=1 ;
    while [[ ! -e "$rel/$tryOptsUtil" && $loop -lt $maxLoops && "$lastReadlink" != "$readlink" ]] ; do
      loop=$((loop+1)) ;
      rel="$rel/.." ;
      lastReadlink=$readlink ;
      readlink=$(readlink -f "$rel" 2>/dev/null || greadlink -f "$rel" ) ;
      if [[ $DEBUG -gt 2 ]] ; then
        local v='' ;
        for v in loop rel readlink lastReadlink ; do
          echo "DEBUG: $v '${!v}'" 1>&2 ;
        done ;
        echo 1>&2 ;
      fi ;
    done ;
    # [[ ! -e "$rel/$tryOptsUtil" ]] || echo "$readlink/$tryOptsUtil" ;
    if [[ -e "$rel/$tryOptsUtil" ]] ; then
      relTryOptsD="$rel/$tryOptsUtil" ;
      echo "$readlink/$tryOptsUtil" ;
      tryOptsD="$readlink/$tryOptsUtil" ;
      echo "Try options dir: '$tryOptsD' ." 1>&2 ;
      echo "Relative: '$relTryOptsD' ." 1>&2 ;
    else
      die "ERROR: Failed to find option-trier." ;
    fi ;
  fi ;
}
try_these_options() {
  [[ -e $theseOptions ]] || die "WARNING: Stopping early because found no folder with these options (\$theseOptions, $theseOptions)." 0 ;
  [[ ! -e $builtOptions ]] || rm -rf $builtOptions ;
  execute mkdir $builtOptions ;
  # execute cd $builtOptions ;
  ( echo "DEBUG: pwd before vexecute cd $thisD/$theseOptions:" ;
    pwd ;
  ) 1>&2 ;
  vexecute cd $thisD/$theseOptions ;
  ( echo "DEBUG: pwd after vexecute cd $thisD/$theseOptions:" ;
    pwd ;
  ) 1>&2 ;
  cd $thisD/$theseOptions ;
  ( echo "DEBUG: pwd after cd $thisD/$theseOptions:" ;
    pwd ;
  ) 1>&2 ;
  cat > build.props <<EOF1
rsrc = $relTryOptsD/rsrc
EOF1
  cat > build.xml <<'EOF2'
<project name="thisAntProj1" >
    <property file="${basedir}/build.props" />
    <property file="${basedir}/default.build.props" />
    <property file="${basedir}/rsrc/default.build.props" />
    <property file="${rsrc}/default.build.props" />
    <property environment="env" />
    <import file="${rsrc}/stilts.build.xml" />
    <import file="${rsrc}/default.build.xml" />
</project>
EOF2
  local tmpd=`mktemp -d "${TMPDIR:-/tmp}/tmp.d.XXXXXXXXXX"` ;
  local o=obxml/OBXml.cfg ;
  [[ ! -e $o.orig ]] || execute rm -f $o.orig ;
  execute cp $o $o.orig ;
  local branch1='source' ;
  local branch2='branch2' ;
  local permutation2='' ;
  local permutation1='' ;
  for permutation1 in CloudBees cloudfoundry-community ourScratch1 ; do
    vexecute mkdir $thisD/$builtOptions/build_$permutation1 ;
    for permutation2 in v1 v2 ; do
      [[ ! -e $o ]] || rm $o ;
      execute cp $o.orig $o ;
      [[ ! -e $o.tmp ]] || execute rm -f $o.tmp ;
      execute cp $o $o.tmp ;
      cat $o.tmp | perl -ne "(!/^\s*\Qbranch.${branch1}\E[\s=:]/) && print \$_" > $o ;
      execute cp $o $o.tmp ;
      cat $o.tmp | perl -ne "(!/^\s*\Qbranch.${branch2}\E[\s=:]/) && print \$_" > $o ;
      echo "branch.$branch1 = $permutation1" >> $o ;
      echo "branch.$branch2 = $permutation2" >> $o ;
      [[ ! -e $o.$permutation1 ]] || cat $o.$permutation1 >> $o ;
      (vexecute ant clean build ) &> build.out.txt ;
      execute mv $builtTmp $thisD/$builtOptions/build_$permutation1/$permutation2 ;
      execute cp $o $thisD/$builtOptions/build_$permutation1/$permutation2/ ;
      execute cp build.out.txt $thisD/$builtOptions/build_$permutation1/$permutation2/ ;
    done ;
  done ;
  cp $o.orig $o ;
  # execute cd .. ;
}


main ;

#
