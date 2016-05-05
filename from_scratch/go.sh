#!/bin/bash

releaseName="jenkins-boshrelease-I5H0" ;
releaseMinor='0.0' ;
releaseVersion="$releaseMinor.1" ;

die() { echo "$1" ; exit 1 ;
}
cd $(dirname $0) || die "ERROR: Failed to cd $(dirname $0): $? ."
source "general.sh" ;

init() {
  local i=1 ;
  local j=1 ;
  local dev_release_yml="$releaseName/dev_releases/$releaseName/${releaseName}-${releaseMinor}.$i.yml" ;
  while [[ -e $dev_release_yml && $i -lt 999 ]] ; do
    i=$((i+1)) ;
    dev_release_yml="$releaseName/dev_releases/$releaseName/${releaseName}-${releaseMinor}.$i.yml" ;
  done ;
  export releaseVersion="$releaseMinor.$i" ;
}
main() {
  init ;
  preparation ;
  step1 ;
  step2 ;
  step3 ;
  step4 ;
  step6 ;
  
  get_logs ;
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
  [[ -e NOTICE ]] || touch NOTICE ;
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
  # for p in 'jenkins_master_war' 'jre_8' 'openjre_8' ; do
  for p in 'jenkins_master_war' 'openjre_8' 'ttf_dejavu' ; do
    [[ -e packages/$p ]] || execute bosh generate package $p ;
  done ;
  if [[ '' ]] ; then
  local d=packages/ardo_app ;
  [[ -e $d/Gemfile ]] || step3_mkGemfile $d/Gemfile ;
  ( cd $d ;
    bundle package ;
  )
  fi ;
}
step3_mkGemfile() {
  cat > $1 <<'EOF3'
# https://gist.github.com/antonsoroko/974924e0692aa2171229dafa5f2561b2
source "http://rubygems.org"

gem "sinatra"
EOF3
}
step4() {
  [[ -d config ]] || mkdir config ;
  local f2=config/private.yml ;
  local f1=config/final.yml ;
  local tmpd=`mktemp -d "${TMPDIR:-/tmp}/tmp.d.XXXXXXXXXX"` ;
  [[ -e $f1 ]] || cat > $f1 <<EOF4a
---
blobstore:
  provider: local
  options:
    blobstore_path: $tmpd/blobs_for_$releaseName
final_name: ardo_app
EOF4a
  [[ -e $f2 ]] || cat > $f2 <<EOF4b
---
blobstore_secret: 'does-not-matter'
blobstore:
  local:
    blobstore_path: $tmpd/blobs_for_$releaseName
EOF4b
  #
  
  local p=jenkins_master_war ;
  local f='jenkins-1.651.1.war' ;
  [[ -e blobs/$p/$f ]] || execute bosh add blob "../blobs_to_add/$p/$f" $p ;

  p=openjre_8 ;
  f='openjdk-1.8.0_65.tar.gz' ;
  [[ -e blobs/$p/$f ]] || execute bosh add blob "../blobs_to_add/$p/$f" $p ;
  
  p=ttf_dejavu ;
  for f in fonts-dejavu-core_2.34-1ubuntu1_all.deb ttf-dejavu-core_2.34-1ubuntu1_all.deb \
    fonts-dejavu-extra_2.34-1ubuntu1_all.deb ttf-dejavu-extra_2.34-1ubuntu1_all.deb \
    fonts-dejavu_2.34-1ubuntu1_all.deb ttf-dejavu_2.34-1ubuntu1_all.deb \
    ; do
    [[ -e blobs/$p/$f ]] || execute bosh add blob "../blobs_to_add/$p/$f" $p ;
  done ;
}
step6() {
  execute bosh create release --force --name $releaseName \
    --version "$releaseVersion" ;
  bosh target ;
  echo -e "\nNOTE: Should already be targeting the BOSH Director you want.\n" ;
  local uuid=`bosh status --uuid` ;
  # cd .. ;
  [[ -e deployment_manifest.yml ]] || cat > deployment_manifest.yml <<EOF6
---
name: ${releaseName}-deployment
director_uuid: $uuid

releases:
- {name: ${releaseName}, version: latest}

resource_pools:
- name: vms
  network: default
  stemcell:
    name: bosh-warden-boshlite-ubuntu-trusty-go_agent
    version: 3147

networks:
- name: default
  type: dynamic

compilation:
  workers: 1
  network: default
  reuse_compilation_vms: true

update:
  canaries: 1
  max_in_flight: 3
  canary_watch_time: 15000-30000
  update_watch_time: 15000-300000

jobs:
- name: jenkins_master
  instances: 1
  templates:
  - {name: jenkins_master, release: ${releaseName}}
  resource_pool: vms
  networks:
  - name: default

properties:
  jenkins_master:
    httpPort: 8082
EOF6
  if [[ '' ]] ; then
    cat > /tmp/tmp <<EOF6b
properties:
  jenkins_master.httpPort:
    description: HTTP Port on which Jenkins runs
    default: 8082
EOF6b
  fi ;
  execute bosh upload release ;
  execute bosh deployment deployment_manifest.yml ;
  execute bosh deploy ;
}
get_logs() {
  cd $(dirname $0) ;
  rm -rf logs/* ; 
  cd logs ; 
    bosh logs jenkins_master 0 ; 
    tar -xzf *.tgz ; 
  cd ..
}


main "$@" ;

#
