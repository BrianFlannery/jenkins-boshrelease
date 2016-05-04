#!/bin/bash

releaseName="jenkins-boshrelease-I5H0" ;

die() { echo "$1" ; exit 1 ;
}
cd $(dirname $0) || die "ERROR: Failed to cd $(dirname $0): $? ."
source "general.sh" ;

main() {
  preparation ;
  step1 ;
}

preparation() {
  local unprepared='' ;
  # [[ -d $releaseName ]] || execute mkdir "$releaseName" ;
  if [[ -d $releaseName ]] ; then
    execute cd "$releaseName" ;
    for x in blobs jobs packages src ; do
      [[ -d $x ]] || unprepared=1 ;
    done ;
    [[ -e config/blobs.yml ]] || unprepared=1 ;
    execute cd .. ;
  else
    unprepared=1 ;
  fi ;
  if [[ $unprepared ]] ; then
    local alreadyIgnoring=`ls .gitignore` ;
    execute bosh init release --git "$releaseName" ;
    # # # NOTE: Frustrating bug with bosh init release --git: It makes the .gitignore in the pwd/cwd, not the release folder.
    [[ $alreadyIgnoring ]] || [[ ! -e .gitignore ]] || mv .gitignore "$releaseName" ;
  fi ;
  [[ ! -e "$releaseName/.git" ]] || rm -rf "$releaseName/.git"
  execute cd "$releaseName" ;
}
step1() {
  for j in jenkins_master jenkins_bosh_slave ; do
    [[ -e jobs/$j ]] || execute bosh generate job $j ;
    local f=jobs/$j/templates/ctl.erb ;
    [[ -e $f ]] || execute touch $f ;
  done ;
  git status ;
}



main "$@" ;

#
