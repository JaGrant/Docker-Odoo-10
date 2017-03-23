#!/bin/bash
echo "Stopping and removing 'odoo10' docker container"
sudo docker stop odoo10
sudo docker rm odoo10
sudo docker rmi odoo10

#echo "Removing ALL Containers!"
#sudo docker rm $(sudo docker ps -a -q)

# Delete all images
#echo "Removing ALL images!"
#sudo docker rmi $(sudo docker images -q)
