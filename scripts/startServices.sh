#!/bin/bash

# Redirect output to log file
exec 1<&-
exec 2<&-
exec >/tmp/run.log 2>&1

echo "Startup initiated $(date)"
echo "--- Sys logfile:  tail -f /tmp/run.log inside of the container"
echo "--- Odoo logfile: tail -f /var/log/odoo/odoo-server.log"
echo "--- Psql logfile: tail -f /var/log/postgresql/postgresql-9.4-main.log"
echo " "

echo "# performing container configuration #"

echo "# starting odoo:"
service odoo start

echo "# start postgresql database"
# Extract PSQL zip
#chmod 700 /var/lib/postgresql/9.4/main
#chown postgres:postgres /var/lib/postgresql/9.4/main
service postgresql start

echo "# Switching to postgres user creating postgres db user (odoo) with superuser and createdb permissions"
su - postgres -c "createuser odoo --createdb --superuser"

echo "Configure Postgres"
sudo -u postgres psql postgres <<END
update pg_database set datallowconn = TRUE where datname = 'template0';
\c template0
update pg_database set datistemplate = FALSE where datname = 'template1';
drop database template1;
create database template1 with template = template0 encoding = 'UTF8';
update pg_database set datistemplate = TRUE where datname = 'template1';
\c template1
update pg_database set datallowconn = FALSE where datname = 'template0';
END


echo "Startup Completed $(date)"

# Keep container running
while true;do sleep 3600;done


