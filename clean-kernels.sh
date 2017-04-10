#!/usr/bin/env bash
#
# Deletes all kernels packages and headers except those concerning current 
# running one
#
# C. Guinet
#

RUNNING_KERNEL=$(uname -r)
LAST_INSTALLED=$(dpkg -l | grep "linux-image" \
               | egrep -v 'linux-image-generic|extra|lts' | cut -d"-" -f 4 \
               | tail -n 1)

if [[ ! ${RUNNING_KERNEL} =~ ${LAST_INSTALLED} ]]; then 
    echo "You're not running last version of the kernel installed on your box !"
    echo "RUNNING_KERNEL=${RUNNING_KERNEL}"
    echo "LAST_INSTALLED=${LAST_INSTALLED}"
    exit 1
fi

TOREMOVE=$(dpkg -l | egrep 'linux-headers|linux-image' | grep ^ii \
        | egrep -v "linux-headers-generic|linux-image-generic|${LAST_INSTALLED}" \
        | awk '{print $2}')

echo "You're about to delete all these packages :"
echo
echo "${TOREMOVE}"
echo
echo "Are you sure you want to proceed (y/n)?"
read RESP

if [[ ${RESP} =~ ^(y|Y)$ ]]; then
    sudo apt-get purge ${TOREMOVE}
else
    exit 1
fi

