#!/bin/sh
#
# ;guestwifi command script
#
##

if [ -f /var/run/guestwifi.pid ]
then
	initctl stop guestwifi
else
	initctl start guestwifi
fi
return 0
