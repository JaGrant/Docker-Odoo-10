#!/bin/bash

# Redirect output to log file
exec 1<&-
exec 2<&-
exec >/tmp/run.log 2>&1

echo "Startup initiated $(date)"

# Container Services

  # Start and Configure Postgres
  sudo service postgresql start
  sleep 30
  sudo -u postgres createuser --createdb $(whoami)
  createdb odoo-test
  # Start Odoo
  sleep 10
  /usr/bin/python /root/odoo/odoo-bin -d odoo-test --addons-path=/root/odoo/addons

echo "Startup Completed $(date)"

# Hold container open
while true;do sleep 3600;done


