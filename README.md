# Development Environment - srv-dev
The repository can be used to install the services and all the development environment for the Avenirs-ESR's ePortfolio.

It is based on bash scripts for bootstraping and cleaning and a main docker compose file that includes a docker compose file for each service to deploy.
The main bootstrap script will invoque the bootstrap script for each service. A service bootstrap script may create the docker volumes on file system, 
check the branch (if a git submodule), and create a .env file to propagate the settings.

## Prerequisites
- Git, 
- Docker (tested with 24.0.6) 
- Docker-compose >=2.2.0 for the support of "include".
- JASYPT_ENCRYPTOR_PASSWORD environment variable must be set (jasypt is used for the bootstrapping stage).


## Architecture experimentation
<figure>
<img src="https://avenirs-esr.github.io/dev-doc/assets/images/docker-containers.png" alt="Architecture diagram">
<figure>
<figcaption>
Technical architecture experimentation
</<figcaption>

## Tree structure  (extract)

<pre>
. 
├── docker-compose.yml              Main docker compose file
├── scripts                         Main Scripts directory
│   ├── srv-dev-bootstrap.sh        Main bootstrapping script
│   ├── srv-dev-clean.sh            Removes all the bootstrap modifications
│   ├── srv-dev-commons.sh          Helpers and constants for the bash scripts
│   └── srv-dev-env.sh              Main environment file : can override the services environment files.
└── services
    ├── apisix
    │   ├── apisix-dashboard        git submodule https://github.com/apache/apisix-dashboard.git
    │   ├── apisix-docker           git submodule: https://github.com/apache/apisix-docker.git
    │   ├── avenirs-apisix-overlay  
    │   │   ├──  apisix-dashboard   
    │   │   │      ├── web
    │   │   │      │     └── config
    │   │   │      │           └── config.ts
    │   │   │      └── Dockerfile
    │   │   └──  apisix-docker      
    │   │          ├── grafanapx_conf
    │   │          │     └── grafana.ini
    │   │          └── example
    │   │                └── docker-compose.yml
    │   │   
    │   │
    │   └──  scripts                       
    │           ├── apisix-bootstrap.sh     Apisix bootsrapping script
    │           ├── apisix-clean.sh         Reverts Apisix bootstrapping
    │           └── apisix-env.sh           Apisix environment file
    │
    ├── apache                              Proxy for the docker containers
    │        ├── avenir-apache-overlay
    │        │    ├── conf
    │        │    │    ├── extra   
    │        │    │    │    ├── avenirs.conf     Proxy rules
    │        │    │    │    └── httpd-ssl.conf
    │        │    │    └── httpd.conf
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
    ├── kafka
    │   └── (...)
    └── openldap                    custom container based on osixia's images
        ├── doc
        ├── fixtures
        └── scripts
    └── openldap     
</pre>

## Scripts
The scripts are located in the folders "scripts"; in the root for the main ones, and in each service directory for specific ones.
The services' scripts can be executed via the main ones: srv-dev-bootstrap or srv-dev-clean.sh or individually directly.


# Installation

<pre>
git clone git@github.com:avenirs-esr/srv-dev.git --recurse
cd srv-dev/
npm i
npm run deploy
</pre>

This instructions will :
1. Download the project and all its  submodules (--recurse option).
2. Run the bootstratp scripts (the main one and the ones associated to each service).
3. Download / generate the docker images.
4. Run the containers associated to each service (via docker-compose).

⚠️ Warning OS compatibility :  
**On Windows**, .sh files are CRLF by default, so you need to switch them to LF for scripts to work.   
To do this, a .ps1 script has been created. To run it, open a powershell and place yourself in the srv-dev folder you've just cloned. Then run the following command:
<pre>
.\convert-sh-to-lf.ps1
</pre>

Available npm scripts :
- npm run deploy: bootstrap each service and run the containers.
- npm run clean: stop the containers and reset all modifications made via the bootstrap scripts.
- npm run purge: idem as clean + docker system prune -a and docker volume prune
- npm run reset: resets all the services as if they were just installed
- npm run dev: idem as deploy without detaching the containers
- npm run sync-modules: synchronize the submodules and set the head to the master or main branch (handles detached head)
- npm run sync: synchronizes everythind (without detached head)



## Test
<pre>
curl "http://localhost/apim" --head | grep Server
</pre>
<pre>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
 Server: APISIX/3.6.0
</pre>


## End-points

- `http://<server>/apisix-api/`
- `http://<server>/apim/`
- `http://<server>/apisix-ui/`
- `http://<server>/apisix-prometheus/`
- `http://<server>/apisix-grafana/`
- `http://<server>/ldapadmin/`
- `http://<server>/cas` -> e.g.:  `http://<server\>/cas/login` 
- `http://<server>/kafka-ui/`

## Database initialisation
The sql initialization scripts can be placed in the folder: *services/postgresql/avenirs-postgresql-overlay/init/*<br/>
The script must be decrypted, for instance using the jasypt tool.<br/>
the "generated tag" in the file name is used to disable the versioning, e.g.: *11_avenirs-security_init-db.generated.sql*.<br/>
An example can be found in *services/avenirs-portfolio/scripts/avenirs-portfolio-bootstrap.sh*<br/>
N.B.: Theses scripts are executed when the container is started for the first time.

## APISIX Initialisation
**Note:** The file for Apisix api keys: *services/apisix/secret_env* must be downloaded from vaultwarden.<br>
The APISIX initialization scripts can be placed in the folder: *services/apisix/scripts/initialization.*<br/>
Theses scripts are executed by a specific initialization container and the entry point is
*init-routes.sh.*<br/>
N.B: the extension curl.sh is used to filter the scripts, e.g.: 01-set-auth-mock-test-route.curl.sh.

## Deployed containers

Several containers should be deployed and running. The list of containers may vary, but this is the list at the time this document was written:

<pre>
CONTAINER ID   NAMES                        STATUS        PORTS
2e09fa47d0f5   avenirs-apache               Up 17 hours   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp
ad8e57a13587   avenirs-kafka-ui             Up 18 hours   0.0.0.0:8082->8080/tcp, [::]:8082->8080/tcp
b6ca8c2e7e8f   avenirs-kafka                Up 18 hours   9092/tcp, 0.0.0.0:29092->29092/tcp, [::]:29092->29092/tcp
a300df2b68b0   avenirs-portfolio-security   Up 18 hours   0.0.0.0:10003->12000/tcp, [::]:10003->12000/tcp
2c37d79679a5   avenirs-pgsql-secondary2     Up 18 hours   0.0.0.0:65434->5432/tcp, [::]:65434->5432/tcp
692effb34ac0   avenirs-pgsql-secondary1     Up 18 hours   0.0.0.0:65433->5432/tcp, [::]:65433->5432/tcp
c8775b53c419   avenirs-cas                  Up 18 hours   0.0.0.0:8443->8443/tcp, [::]:8443->8443/tcp, 0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp
79592ffdda03   avenirs-apisix-api           Up 18 hours   0.0.0.0:9080->9080/tcp, [::]:9080->9080/tcp, 0.0.0.0:9091-9092->9091-9092/tcp, [::]:9091-9092->9091-9092/tcp, 0.0.0.0:9180->9180/tcp, [::]:9180->9180/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp
ce1286c8278d   avenirs-phpldapadmin         Up 18 hours   443/tcp, 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
cfcbe134ab3a   avenirs-node                 Up 18 hours   0.0.0.0:8030->3000/tcp, [::]:8030->3000/tcp, 0.0.0.0:8033->3003/tcp, [::]:8033->3003/tcp
7e950e57121b   avenirs-openldap             Up 18 hours   0.0.0.0:389->389/tcp, [::]:389->389/tcp, 0.0.0.0:636->636/tcp, [::]:636->636/tcp
b8a6e79234b6   avenirs-zookeeper            Up 18 hours   2888/tcp, 3888/tcp, 0.0.0.0:22181->2181/tcp, [::]:22181->2181/tcp
55e1b5d1787e   avenirs-pgsql-ui             Up 18 hours   0.0.0.0:18080->8080/tcp, [::]:18080->8080/tcp
8db72e197ee3   avenirs-pgsql-primary        Up 18 hours   0.0.0.0:65432->5432/tcp, [::]:65432->5432/tcp
27f5be7db3e4   avenirs-apisix-etcd          Up 18 hours   0.0.0.0:2379->2379/tcp, [::]:2379->2379/tcp, 2380/tcp
0950e3f9681f   avenirs-apisix-prometheus    Up 18 hours   0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp
d04ea50f22bb   avenirs-apisix-grafana       Up 18 hours   0.0.0.0:3001->3000/tcp, [::]:3001->3000/tcp
059251304e11   avenirs-apisix-dashboard     Up 18 hours   0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp
                            
</pre>