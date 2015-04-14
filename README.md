# dc-update
Docker Containment Update

dc-update.sh is a script that will download a docker image, check if there are
packages to be updated, and if so, add a layer with the updated packages and
upload the resulting docker image back to the registry (i.e. docker hub).

The goal is to improve security in docker containments by rebuilding
images with the latest security updates.

This script has been started as a hack week project 
https://hackweek.suse.com/12/projects/990

In order to run the script, you need to have a ~/.dockercfg file for the
registry and you need to own the image you want to update.

Usage is straightforward:

./dc-update.sh IMAGENAME

for example:

./dc-update.sh jordimassaguerpla/guestbook

In the lib directory, there is support for different distributions.

Feel free to use it, open issues, clone it and send me pull requests :-) !
