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
pkg_manager_bin=/usr/bin/zypper
pkg_manager_list_p="$pkg_manager_bin --non-interactive lp"
pkg_manager_patch="$pkg_manager_bin --non-interactive patch"
no_updates_found="No updates found"
cidfile=cidfile
docker_conf_file=~/.dockercfg

clean() {
  [ ! -f $cidfile ] || rm $cidfile
}

clean_and_exit() {
  clean
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

docker run $image_name [ -f $pkg_manager_bin ]
if [ $? -ne 0 ];then
  echo "No $pkg_manager_bin found"
  # TODO: try other package manager and update pkg_* and no_updates_found vars
  clean_and_exit -4
fi

docker run --rm $image_name $pkg_manager_list_p | grep "$no_updates_found"
if [ $? -eq 0 ];then
  echo "No rebuild needed"
  clean_and_exit 0
fi

docker run --cidfile=$cidfile $image_name $pkg_manager_patch
if [ $? -ne 0 ];then
  echo "There was some kind of problem running zypper patch in $image_name"
  echo "Exiting..."
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



