#!/bin/bash

# Redirect output to log file
exec 1<&-
exec 2<&-
exec >/tmp/run.log 2>&1

echo "Startup initiated $(date)"

# Add start up scripts here
  # Start Postgres
  sudo service postgresql start
  # Start Odoo

echo "Startup Completed $(date)"

# Hold container open
while true;do sleep 3600;done


