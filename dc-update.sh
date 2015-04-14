#!/bin/bash
# This script will trigger a docker image rebuild if there are pending
# updates to be applied.

if [ $# -ne 1 ];then
  echo "Usage: $0 IMAGE_NAME"
  exit -1
fi

if [ $1 == "--help" ];then
  echo "Usage: $0 IMAGE_NAME"
  exit -1
fi

if [ $1 == "help" ];then
  echo "Usage: $0 IMAGE_NAME"
  exit -1
fi

image_name=$1
cidfile=$(mktemp)
docker_conf_file=~/.dockercfg
distros="suse fedora"

for distro in $distros;do
 . lib/dc-update.$distro.sh
done

clean() {
  [ ! -f $cidfile ] || rm $cidfile
}

clean_and_exit() {
  clean
  echo "Bye"
  exit $1
}

if [ ! -f $docker_conf_file ];then
  echo "There is no $docker_conf_file"
  echo "You can create one with 'docker login'"
  echo "Try again when you have a $docker_conf_file"
  clean_and_exit -2
fi

docker pull $image_name
if [ $? -ne 0 ];then
  echo "There was some kind of problem downloading $image_name"
  echo "Usage: $0 IMAGE_NAME"
  clean_and_exit -3
fi

package_manager=""

for distro in $distros;do
  eval package_manager=\$$distro\_package_manager
  docker run $image_name [ -f $package_manager ]
  if [ $? -eq 0 ];then
    set_$distro\_package\_manager
    break
  fi
done

if [ "$package_manager" == "" ];then
  echo "No known package manager found."
  echo "Supported distros"
  echo $distros
  clean_and_exit -4
fi

$check_updates
if [ $? -eq 0 ];then
  echo "No rebuild needed"
  clean_and_exit 0
fi

docker run --cidfile=$cidfile $image_name $pkg_manager_patch
if [ $? -ne 0 ];then
  echo "There was some kind of problem running zypper patch in $image_name"
  clean_and_exit -5
fi

cid=$(cat $cidfile)
docker commit $cid $image_name
if [ $? -ne 0 ];then
  echo "There was some kind of problem commiting $image_name"
  clean_and_exit -6
fi

docker push $image_name
if [ $? -ne 0 ];then
  echo "There was some kind of problem pushing $image_name"
  clean_and_exit -7
fi

echo "Well done! The image has been updated and pushed!"
clean_and_exit 0



