# Development Environment - srv-dev
The repository can be used to install the services and all the development environment for the Avenirs-ESR's ePortfolio.

It is based on bash scripts for bootstraping and cleaning and a main docker compose file that includes a docker compose file for each service to deploy.
The main bootstrap script will invoque the bootstrap script for each service. A service bootstrap script may create the docker volumes on file system, 
check the branch (if a git submodule), and create a .env file to propagate the settings.

## Prerequisites
Git, Docker (tested with 24.0.6) and docker-compose >=2.2.0 for the support of "include".

## Tree structure

<pre>
. 
├── docker-compose.yml              Main docker compose file
├── scripts                         Main Scripts directory
│   ├── srv-dev-bootstrap.sh        Main bootsrapping script
│   ├── srv-dev-clean.sh            Removes all the bootstrap modifications
│   ├── srv-dev-commons.sh          Helpers and constants for the bash scripts
│   └── srv-dev-env.sh              Main environment file : can override the services environment files.
└── services
    ├── apisix
    │   ├── apisix-docker           git submodule: https://github.com/apache/apisix-docker.git
    │   ├── avenirs-apisix-overlay
    │   │   └── example
    │   │       └── docker-compose.yml
    │   └── scripts                
    ├── scripts                       
    │   ├── apisix-bootstrap.sh     Apisix bootsrapping script
    │   ├── apisix-clean.sh         Reverts Apisix bootstrapping
    │   └── apisix-env.sh           Apisix environment file
    ├── cas
    │   ├── avenirs-cas-overlay     git submodule: https://github.com/apereo/cas-overlay-template.git 
    │   │   ├── build.gradle
    │   │   ├── docker-compose.yml
    │   │   ├── Dockerfile
    │   │   ├── entrypoint.sh
    │   │   └── etc
    │   │       └── cas
    │   │           ├── config
    │   │           │   ├── cas.properties
    │   │           │   └── log4j2.xml
    │   │           ├── services
    │   │           │   ├── all-1649925263.json
    │   │           │   └── apim-4000.json
    │   │           └── thekeystore
    │   ├── cas-overlay-template
    │   └── scripts
    └── openldap                    custom container based on osixia's images
        ├── doc
        ├── fixtures
        └── scripts
</pre>

## Scripts
The scripts are located in the folders "scripts"; in the root for the main one, and in each service directory for specific ones.
The services' scripts can be executed via the main ones: srv-dev-bootstrap or srv-dev-clean.sh or individually directly.


# Local installation quick start

## Fetches the repository
<pre>
git clone git@github.com:avenirs-esr/srv-dev.git --recurse
cd srv-dev/
npm i
</pre>

## Bootstrap
<pre>
 ./scripts/srv-dev-bootstap.sh -v
</pre>

## Docker
<pre>
docker-compose up --build -d

</pre>

Several containers should be deployed and running:

<pre>
$ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED       STATUS       PORTS                                                                                                                                                                                            NAMES
7b9655421acd   apache/apisix:3.6.0-debian   "/docker-entrypoint.…"   2 hours ago   Up 2 hours   0.0.0.0:9080->9080/tcp, :::9080->9080/tcp, 0.0.0.0:9091-9092->9091-9092/tcp, :::9091-9092->9091-9092/tcp, 0.0.0.0:9180->9180/tcp, :::9180->9180/tcp, 0.0.0.0:9443->9443/tcp, :::9443->9443/tcp   apisix
64de5b872845   osixia/phpldapadmin:latest   "/container/tool/run"    2 hours ago   Up 2 hours   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp                                                                                                                                                   ldapadmin
d4459f36e0f2   prom/prometheus:v2.25.0      "/bin/prometheus --c…"   2 hours ago   Up 2 hours   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp                                                                                                                                                        apisix_prometheus
781a9742c581   nginx:1.19.0-alpine          "/docker-entrypoint.…"   2 hours ago   Up 2 hours   0.0.0.0:9082->80/tcp, :::9082->80/tcp                                                                                                                                                            apisix_nginx2
f8128fd7b122   nginx:1.19.0-alpine          "/docker-entrypoint.…"   2 hours ago   Up 2 hours   0.0.0.0:9081->80/tcp, :::9081->80/tcp                                                                                                                                                            apisix_nginx1
70d351711c1a   grafana/grafana:7.3.7        "/run.sh"                2 hours ago   Up 2 hours   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp                                                                                                                                                        apisix_grafana
6f391d03a4ca   bitnami/etcd:3.4.15          "/opt/bitnami/script…"   2 hours ago   Up 2 hours   0.0.0.0:2379->2379/tcp, :::2379->2379/tcp, 2380/tcp                                                                                                                                              apisix_etcd
0231b57b04cd   srv-dev-cas                  "java -server -nover…"   2 hours ago   Up 2 hours   0.0.0.0:8443->8443/tcp, :::8443->8443/tcp, 0.0.0.0:8081->8080/tcp, :::8081->8080/tcp 
</pre>

# Distant deployment

WIP...
Creation of the contexts
  docker context create env --docker host=ssh://arnaud@srv-dev-avenirs --default-stack-orchestrator=swarm