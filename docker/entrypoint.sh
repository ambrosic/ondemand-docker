#!/usr/bin/env bash

. /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND -e debug
