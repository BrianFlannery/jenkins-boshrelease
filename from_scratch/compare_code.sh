#!/bin/bash

set -u ;

DEBUG=2 ;
tryOptsUtil=code_option_trier ;
theseOptions=../.code_options ;
builtOptions=../built_options ;
builtTmp=build ;
filesShouldBeThere=(
./jobs/jenkins_master/monit
./jobs/jenkins_master/spec
./jobs/jenkins_master/templates/bin/monit_debugger
./jobs/jenkins_master/templates/bin/nginx_ctl
./jobs/jenkins_master/templates/bin/jenkins_master_ctl
./jobs/jenkins_master/templates/config/jenkins_home/bosh-configuration.json.erb
./jobs/jenkins_master/templates/config/jenkins_home/config.xml.erb
./jobs/jenkins_master/templates/config/nginx/nginx_config.nginx_config_ext.erb
./jobs/jenkins_master/templates/config/nginx/configFile2.configFile2Ext.erb
./jobs/jenkins_master/templates/config/configFile1.configFile1Ext
./jobs/jenkins_master/templates/data/properties.sh.erb
./jobs/jenkins_master/templates/helpers/ctl_setup.sh
./jobs/jenkins_master/templates/helpers/ctl_utils.sh
./packages/jenkins_master_war/packaging
./packages/jenkins_master_war/spec
./packages/openjdkjredir/packaging
./packages/openjdkjredir/spec
./src/apt/ttf-dejavu/profile.sh
./packages/ttf_dejavu_dir/packaging
./packages/ttf_dejavu_dir/spec
./packages/fontconfig/packaging
./packages/fontconfig/spec
./packages/jenkins_plugins/packaging
./packages/jenkins_plugins/spec
) ;
if [[ '' ]] ; then
./src/ttf_dejavu_dir/apt/ttf-dejavu/profile.sh
./packages/ttf_dejavu_dir/apt/ttf-dejavu/profile.sh
./src/ttf_dejavu/profile.sh
./NOTICE
./release.MF

./jobs/jenkins_master/job.MF
./jobs/jenkins_master/templates/bin/haproxy_ctl
./jobs/jenkins_master/templates/bin/monit_debugger
./jobs/jenkins_master/templates/bin/route_registrar_ctl
./jobs/jenkins_master/templates/config/haproxy/haproxy.config.erb
./jobs/jenkins_master/templates/config/haproxy/ssl.pem.erb
./jobs/jenkins_master/templates/config/jenkins_home/cloudbees-referrer.txt
./jobs/jenkins_master/templates/config/jenkins_home/registration-details.json.erb
./jobs/jenkins_master/templates/config/route_registrar/registrar_settings.yml.erb
./jobs/jenkins_master/templates/config/syslog_aggregator/syslog_forwarder.conf.erb

./jobs/jenkins_slave/job.MF
./jobs/jenkins_slave/monit
./jobs/jenkins_slave/templates/bin/jenkins_slave_ctl
./jobs/jenkins_slave/templates/bin/monit_debugger
./jobs/jenkins_slave/templates/bin/sleep_forever
./jobs/jenkins_slave/templates/config/bashrc
./jobs/jenkins_slave/templates/config/shellpaths
./jobs/jenkins_slave/templates/config/shellvars
./jobs/jenkins_slave/templates/data/properties.sh.erb
./jobs/jenkins_slave/templates/helpers/ctl_setup.sh
./jobs/jenkins_slave/templates/helpers/ctl_utils.sh

./jobs/register_jenkins/job.MF
./jobs/register_jenkins/monit
./jobs/register_jenkins/templates/bin/run
./jobs/register_jenkins/templates/data/properties.sh.erb
./jobs/register_jenkins/templates/helpers/ctl_setup.sh
./jobs/register_jenkins/templates/helpers/ctl_utils.sh
./jobs/unregister_jenkins/job.MF
./jobs/unregister_jenkins/monit
./jobs/unregister_jenkins/templates/bin/run
./jobs/unregister_jenkins/templates/data/properties.sh.erb
./jobs/unregister_jenkins/templates/helpers/ctl_setup.sh
./jobs/unregister_jenkins/templates/helpers/ctl_utils.sh

./jobs/docker/job.MF
./jobs/docker/monit
./jobs/docker/templates/bin/cgroupfs-mount
./jobs/docker/templates/bin/docker_ctl
./jobs/docker/templates/bin/job_properties.sh.erb
./jobs/docker/templates/bin/remote_syslog_ctl
./jobs/docker/templates/config/docker.cacert.erb
./jobs/docker/templates/config/docker.cert.erb
./jobs/docker/templates/config/docker.key.erb
./jobs/docker/templates/config/docker_logrotate.cron.erb
./jobs/docker/templates/config/logrotate.conf.erb
./jobs/docker/templates/config/remote_syslog.yml.erb

./packages/bosh-helpers/bosh-helpers/ctl_setup.sh
./packages/bosh-helpers/bosh-helpers/ctl_utils.sh
./packages/bosh-helpers/bosh-helpers/monit_debugger
./packages/bosh-helpers/packaging
./packages/buildpacks/buildpacks/bin/cf_buildpack
./packages/buildpacks/buildpacks/bin/detect_compile_buildpack_run_job
./packages/buildpacks/packaging
./packages/cloudfoundry-cli/packaging

./packages/jenkins-plugins/packaging

./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_01_tools.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_02_slaves.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_03_authentication_cf_uaa.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_04_authorization_rbac.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_05_syslog.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/license-activated-or-renewed-after-expiration.groovy.d/init_01_launch_configure_jenkins.groovy

./packages/docker/docker/docker-1.8.2
./packages/docker/packaging
./packages/git/packaging
./packages/golang/packaging
./packages/haproxy/packaging
./packages/maven/packaging
./packages/openssl/apt/openssl/profile.sh
./packages/openssl/packaging
./packages/remote_syslog/packaging
./packages/route-registrar/packaging
./packages/route-registrar/route-registrar/src/github.com
./packages/ruby/packaging
./packages/syslog_aggregator/packaging
./packages/syslog_aggregator/syslog_aggregator/setup_syslog_forwarder.sh
./packages/uaac/packaging
./packages/uaac/uaac/Gemfile
./packages/uaac/uaac/Gemfile.lock

./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_00.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_06_fixed_ports.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/configure-jenkins.groovy.d/init_99_save.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/init.groovy.d/init_0.groovy
./packages/jenkins-init-script/jenkins-init-script/src/main/groovy/init.groovy.d/init_01_launch_configure_jenkins.groovy
./packages/jenkins-init-script/packaging

fi ;

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

init() {
  [[ ! -e $elog ]] || rm $elog ;
  [[ ! -e $log ]] || rm $log ;
}
main() {
  init ;
  [[ -e ../_code_opts ]] || ( cd .. && ln -s "$(basename $theseOptions)/" _code_opts ) ;
  # tryOptsD=`execute findTryOpts` ;
  findTryOpts ;
  # echo "Try options dir: '$tryOptsD' ." ;
  # echo "Relative: '$relTryOptsD' ." ;
  [[ $tryOptsD ]] || die "ERROR: Failed to find options trier." ;
  idem_make_files ;
  try_these_options ;
  compare_them ;
}
idem_make_files() {
  local pwd0=`pwd` ;
  execute cd $thisD/$theseOptions ;
  cd $thisD/$theseOptions/obxml/strtr ;
  local f='' ;
  for f in ${filesShouldBeThere[@]}; do
    f="$f.xml"
    [[ -e "$f" ]] || [[ $DEBUG -lt 2 ]] || echo "idem_make_files: Making file '$f' .";
    local d=$(dirname "$f") ;
    [[ -e "$d" ]] || mkdir -p "$d" ;
    [[ -e "$f" ]] || touch "$f" ;
  done ;
  cd "$pwd0" ;
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
      # echo "Try options dir: '$tryOptsD' ." 1>&2 ;
      # echo "Relative: '$relTryOptsD' ." 1>&2 ;
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
  cd $thisD/$theseOptions || die "Failed to 'cd $thisD/$theseOptions': $? ." ;
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
  # local tmpd=`mktemp -d "${TMPDIR:-/tmp}/tmp.d.XXXXXXXXXX"` ;
  local o=obxml/OBXml.cfg ;
  local trans=obxml/strtr/strtr_cfg/strtrDefault.trans ;
  [[ ! -e $o.orig ]] || execute rm -f $o.orig ;
  execute cp $o $o.orig ;
  [[ ! -e $trans.orig ]] || execute rm -f $trans.orig ;
  execute cp $trans.properties $trans.orig ;
  local branch1='source' ;
  local branch2='branch2' ;
  local permutation2='' ;
  local permutation1='' ;
  for permutation1 in CloudBees cloudfoundry-community ourScratch1 ; do
    vexecute mkdir $thisD/$builtOptions/build_$permutation1 ;
    for permutation2 in v1 v2 ; do
      [[ ! -e $trans.properties ]] || rm $trans.properties ;
      execute cp $trans.orig $trans.properties ;
      [[ ! -e $o ]] || rm $o ;
      execute cp $o.orig $o ;
      [[ ! -e $o.tmp ]] || execute rm -f $o.tmp ;
      execute cp $o $o.tmp ;
      cat $o.tmp | perl -ne "(!/^\s*\Qbranch.${branch1}\E[\s=:]/) && print \$_" > $o ;
      execute cp $o $o.tmp ;
      cat $o.tmp | perl -ne "(!/^\s*\Qbranch.${branch2}\E[\s=:]/) && print \$_" > $o ;
      echo "branch.$branch1 = $permutation1" >> $o ;
      echo "branch.$branch2 = $permutation2" >> $o ;
      [[ ! -e $trans.$permutation1 ]] || cat $trans.$permutation1 >> $trans.properties ;
      [[ ! -e $o.$permutation1 ]] || cat $o.$permutation1 >> $o ;
      ( export strtr_inventtrans=1 ;
        vexecute ant clean build 
      ) &> build.out.txt ;
      execute mv $builtTmp $thisD/$builtOptions/build_$permutation1/$permutation2 ;
      execute cp $o $thisD/$builtOptions/build_$permutation1/$permutation2/ ;
      execute cp build.out.txt $thisD/$builtOptions/build_$permutation1/$permutation2/ ;
      ( cd $thisD/$builtOptions/build_$permutation1/$permutation2/ && ln -s .meta.strtr/ _strtr ) ;
    done ;
  done ;
  cp $o.orig $o ;
  cp $trans.orig $trans.properties ;
  # execute cd .. ;
}
compare_them() {
  local d1='' ;
  local d2='' ;
  
  d1=~/dw/huge/unzip_cloudbees_j/releases/jenkins-2034/ ;
  d2=$thisD/$builtOptions/build_CloudBees/v1/$builtTmp ;
  Diff -r $d1/ $d2/ > $builtOptions/diff_CloudBees.txt ;
  # diff -r $d1/ $d2/ | egrpe -v '' > diff_CloudBees.txt ;

  d1=$thisD/.. ;
  d2=$thisD/$builtOptions/build_cloudfoundry-community/v1/$builtTmp ;
  Diff -r $d1/ $d2/ > $builtOptions/diff_cloudfoundry-community.txt ;
  # diff -r $d1/ $d2/ | egrpe -v '' > diff_cloudfoundry-community.txt ;

  d1=$thisD/jenkins-boshrelease-I5H0 ;
  d2=$thisD/$builtOptions/build_ourScratch1/v1/$builtTmp ;
  Diff -r $d1/ $d2/ > $builtOptions/diff_ourScratch1.txt ;
  # diff -r $d1/ $d2/ | egrpe -v '' > diff_ourScratch1.txt ;

}
Diff() {
  diff "$@" | perl -ne 'if ( /^(diff|Only)/ ) { print $_ } elsif ( /^[<>]/ ) { print "    $_" } else { print "  $_" }' ;
}



main ;

#
