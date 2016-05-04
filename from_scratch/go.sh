#!/bin/bash

releaseName="jenkins-boshrelease-I5H0" ;
releaseVersion='0.0.1' ;

die() { echo "$1" ; exit 1 ;
}
cd $(dirname $0) || die "ERROR: Failed to cd $(dirname $0): $? ."
source "general.sh" ;

main() {
  preparation ;
  step1 ;
  step2 ;
  step3 ;
  step6 ;
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
  echo -e "\nNOTE: Consider adding and committing any changes.\n" ;
}
step2() {
  echo "Nothing happens." 1>&2 ;
}
step3() {
  for p in 'ardo_app' 'libyaml_0.1.4' 'ruby_1.9.3' ; do
    [[ -e packages/$p ]] || execute bosh generate package $p ;
  done ;
  local d=packages/ardo_app ;
  [[ -e $d/Gemfile ]] || step3_mkGemfile $d/Gemfile ;
  ( cd $d ;
    bundle package ;
  )
}
step3_mkGemfile() {
  cat > $1 <<'EOF3'
# https://gist.github.com/antonsoroko/974924e0692aa2171229dafa5f2561b2
source "http://rubygems.org"

gem "sinatra"
EOF3
}
step6() {
  execute bosh create release --force --name $releaseName \
    --version "$releaseVersion" ;
  bosh target ;
  echo -e "\nNOTE: Should already be targeting the BOSH Director you want.\n" ;
  
}


main "$@" ;

#
