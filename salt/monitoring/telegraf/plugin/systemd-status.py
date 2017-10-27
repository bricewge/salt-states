#!/usr/bin/python3.4

import subprocess

status = subprocess.getstatusoutput("systemctl is-system-running --quiet")

print('systemd-status status=' + str(status[0]))
