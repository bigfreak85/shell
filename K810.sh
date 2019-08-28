#!/bin/bash
if [ "$ACTION" == "add" ];
then
    # configure k810 ($DEVPATH) at $DEVNAME.
    /usr/local/bin/k810_conf -d $DEVNAME -f on
fi
