ContainerName = "odoo"
ContainerVersion = "1.0"

ContainerID = `docker ps -a | grep -P "$(ContainerName)[\s]+" | awk '{print $$1}'`
ImageID = `docker images --format="{{.ID}}" $(ContainerName):latest`
ContainerLogfile = `$ docker inspect --format='{{.LogPath}}' $(ContainerName)`
ContainerCreated = `docker ps | grep -P "$(ContainerName)[\s]+" | awk '{print "Created " $$4 " " $$5}'` "ago"
ContainerUptime = `docker ps | grep -P "$(ContainerName)[\s]+" | awk '{print $$7 " " $$8 " " $$9}'`
ContainerExposedports = `docker inspect --format='{{range $$p, $$conf := .NetworkSettings.Ports}} {{$$p}} -> {{(index $$conf 0).HostPort}} {{end}}' $(ContainerName)`
ContainerIP = `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(ContainerName)`
HostMemory = `free -h | grep -P "Mem:[\s]+" | awk '{print $$3 " of " $$2 " used, (" $$4  " free)"}'`
HostCpu = `lscpu | grep -P "Model name:[\s]+" | awk '{print $$3 $$4 $$6 " - " $$7 $$8}'`
CpuCount = `lscpu | grep -P "Socket" | awk '{print $$2}'`
Hostname = `hostname`
HostIP = `hostname -I`
ContainerDir = `pwd`


help: # Makefile help guide
	@ echo "------------------------------------------------------------"
	@ echo "                    $(ContainerName) V$(ContainerVersion) usage guide"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ echo "BUILD"
	@ echo "    Usage: make build"
	@ echo "    Desc: Builds the docker container utilizing the Dockerfile"
	@ echo ""
	@ echo "RUN"
	@ echo "    Usage: make run"
	@ echo "    Desc: Starts the docker container"
	@ echo ""	
	@ echo "START"
	@ echo "    Usage: make start"
	@ echo "    Desc: Start a stopped container"
	@ echo ""
	@ echo "BASH"
	@ echo "    Usage: make bash"
	@ echo "    Desc: Access the bash terminal of the docker container"
	@ echo ""
	@ echo "STOP"
	@ echo "    Usage: make stop"
	@ echo "    Desc: Stops the docker container but preserves container state"
	@ echo ""
	@ echo "REMOVE"
	@ echo "    Usage: make remove"
	@ echo "    Desc: removes the docker container and all image layers"
	@ echo ""
	@ echo "INFO"
	@ echo "    Usage: make info"
	@ echo "    Desc: Display an assortment of useful container information"
	@ echo ""
	@ echo "LOG"
	@ echo "    Usage: make log"
	@ echo "    Desc: tail the containers logfile (detailed container stdout and stderr)"
	@ echo ""
	@ echo ""

build:
	@ echo "------------------------------------------------------------"
	@ echo "               Building $(ContainerName) V$(ContainerVersion) Docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker build -t $(ContainerName) .	# Build container from Dockerfile
	@ echo ""
	@ echo ""

run:
	@ echo "------------------------------------------------------------"
	@ echo "               Starting $(ContainerName) V$(ContainerVersion) Docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker run --name $(ContainerName) --detach -p 8069:8069 -p 5432:5432 -it $(ContainerName)
	@ echo ""
	@ echo ""
	@ echo " Odoo is now up on: http://localhost:8069"
	@ echo ""
	@ echo ""

start:
	@ echo "------------------------------------------------------------"
	@ echo "               Starting $(ContainerName) V$(ContainerVersion) Docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker start $(ContainerName)
	@ echo ""
	@ echo ""
	@ echo " Odoo is now up on: http://localhost:8069"
	@ echo ""
	@ echo ""

bash:
	@ echo "------------------------------------------------------------"
	@ echo "          Bash terminal of $(ContainerName) V$(ContainerVersion) docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker exec -t -i $(ContainerName) /bin/bash	# Bash inside of container
	@ echo ""
	@ echo ""

stop:
	@ echo "------------------------------------------------------------"
	@ echo "          Stopping $(ContainerName) V$(ContainerVersion) docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker stop $(ContainerName) 		# stop running container
	@ echo ""
	@ echo ""

remove:
	@ echo "------------------------------------------------------------"
	@ echo "     Stopping and removing $(ContainerName) V$(ContainerVersion) docker container"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ docker stop $(ContainerName)		# stop running container
	@ docker rm $(ContainerName)		# remove container
	@ docker rmi $(ContainerName)		# remove container image layers
	@ echo ""
	@ echo ""

log:
	@ echo "------------------------------------------------------------"
	@ echo "     tailing $(ContainerName) V$(ContainerVersion) container log"
	@ echo "------------------------------------------------------------"
	@ echo ""
	@ sudo tail -f $(ContainerLogfile)
	@ echo ""
	@ echo ""

info:
	@ echo "------------------------------------------------------------"
	@ echo "          $(ContainerName) V$(ContainerVersion) container information:"
	@ echo "          ---------------------------------"
	@ echo ""
	@ echo "--- Container:"
	@ echo "	Container Name:		$(ContainerName)"
	@ echo "	Container Version:	$(ContainerVersion)"
	@ echo "	Container ID:		$(ContainerID)"
	@ echo "	Image ID:		$(ImageID)"
	@ echo "	Container Logfile:	$(ContainerLogfile)"
	@ echo "	Container Created:	$(ContainerCreated)"
	@ echo "	Container Uptime:	$(ContainerUptime)"
	@ echo "	Container IP:		$(ContainerIP)"
	@ echo "	Exposed ports:		$(ContainerExposedports)"
	@ echo ""
	@ echo "--- Host:"
	@ echo "	Hostname:		$(Hostname)"
	@ echo "	Host IP:		$(HostIP)"
	@ echo "	ContainerDir:		$(ContainerDir)"
	@ echo "	CPU			$(CpuCount)x $(HostCpu)"
	@ echo "	Memory:			$(HostMemory)"
	@ echo ""
	@ echo ""
