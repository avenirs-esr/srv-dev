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
    │   └──  scripts                       
    │           ├── apisix-bootstrap.sh     Apisix bootsrapping script
    │           ├── apisix-clean.sh         Reverts Apisix bootstrapping
    │           └── apisix-env.sh           Apisix environment file
    │
    ├── apache                              Proxy for the docker containers
    │        ├── apache-files
    │        │    ├── conf
    │        │    │    ├── extra   
    │        │    │    │    ├── avenirs.conf     Proxy rules
    │        │    │    │    └── httpd-ssl.conf
│   │        │    │    └── httpd.conf
    │        │    └── htdocs
    │        └── scripts
    │  
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
CONTAINER ID   IMAGE                                  COMMAND                  CREATED             STATUS             PORTS                                                                                                                                                                                            NAMES
56f5937bd11a   osixia/phpldapadmin:latest             "/container/tool/run"    About an hour ago   Up About an hour   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp                                                                                                                                                   phpldapadmin
05dfd079e031   apache/apisix:3.6.0-debian             "/docker-entrypoint.…"   About an hour ago   Up About an hour   0.0.0.0:9080->9080/tcp, :::9080->9080/tcp, 0.0.0.0:9091-9092->9091-9092/tcp, :::9091-9092->9091-9092/tcp, 0.0.0.0:9180->9180/tcp, :::9180->9180/tcp, 0.0.0.0:9443->9443/tcp, :::9443->9443/tcp   apisix
538e61bb3722   nginx:1.19.0-alpine                    "/docker-entrypoint.…"   About an hour ago   Up About an hour   0.0.0.0:9081->80/tcp, :::9081->80/tcp                                                                                                                                                            apisix_nginx1
67ff791b9614   srv-dev-le-apache                      "httpd-foreground"       About an hour ago   Up About an hour   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp                                                                                                                         apache
d1774f89ca8f   srv-dev-cas                            "java -server -nover…"   About an hour ago   Up About an hour   0.0.0.0:8443->8443/tcp, :::8443->8443/tcp, 0.0.0.0:8081->8080/tcp, :::8081->8080/tcp                                                                                                             cas
7ef501c539f3   prom/prometheus:v2.25.0                "/bin/prometheus --c…"   About an hour ago   Up About an hour   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp                                                                                                                                                        apisix_prometheus
aea02430c9f3   nginx:1.19.0-alpine                    "/docker-entrypoint.…"   About an hour ago   Up About an hour   0.0.0.0:9082->80/tcp, :::9082->80/tcp                                                                                                                                                            apisix_nginx2
a74aa53579fb   osixia/openldap:1.5.0                  "/container/tool/run"    About an hour ago   Up About an hour   0.0.0.0:389->389/tcp, :::389->389/tcp, 0.0.0.0:636->636/tcp, :::636->636/tcp                                                                                                                     openldap
9abf9542b691   bitnami/etcd:3.4.15                    "/opt/bitnami/script…"   About an hour ago   Up About an hour   0.0.0.0:2379->2379/tcp, :::2379->2379/tcp, 2380/tcp                                                                                                                                              apisix_etcd
7f16ce2a0d51   apache/apisix-dashboard:3.0.1-alpine   "/usr/local/apisix-d…"   About an hour ago   Up About an hour   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp                                                                                                                                                        apisix-dashboard
6d841dbd137d   grafana/grafana:7.3.7                  "/run.sh"                About an hour ago   Up About an hour   0.0.0.0:3001->3000/tcp, :::3001->3000/tcp                                                                                                                                                        apisix_grafana
</pre>

# Distant deployment

WIP...
Creation of the contexts
  docker context create env --docker host=ssh://arnaud@srv-dev-avenirs --default-stack-orchestrator=swarm