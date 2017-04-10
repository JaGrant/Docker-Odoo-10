#!/bin/sh
echo "----- start.sh ---> Starting odoo10 Docker container"
sudo docker run --name odoo10 -p 8069:8069 -it odoo10
# -v "$PWD/pgdata":/var/lib/postgresql/9.4/main

