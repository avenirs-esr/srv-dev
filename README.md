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



## Portfolio API image

`avenirs-portfolio-api` is no longer built here: its CI publishes the image
`ghcr.io/avenirs-esr/avenirs-portfolio-api` (tags: branch name, git tag,
`sha-<commit>`), and Compose pulls it. The version is chosen with
`AVENIRS_PORTFOLIO_API_IMAGE_TAG` (default `develop`), for example
`AVENIRS_PORTFOLIO_API_IMAGE_TAG=1.2.0 docker compose up -d avenirs-portfolio-api`.

The configuration is not baked into the image anymore: the `env.properties`
generated by the portfolio bootstrap is passed to the container as environment
variables (`env_file`), so a new bootstrap (for instance the HMAC secret rotation)
only needs `docker compose up -d avenirs-portfolio-api`, without rebuilding.
The submodule is still used to run the Liquibase migrations (`npm run api:update-db`).

## Cofolio client build

The Cofolio image builds the PNPM workspace with Node, then serves only
`apps/avenirs-cofolio-client/dist` with Nginx under `/cofolio/`.
`PNPM_VERSION_DEFAULT` in `scripts/srv-dev-env.sh` pins PNPM to `10.34.2`.
The root bootstrap generates `PNPM_VERSION`, which Compose passes to the builder.

The frontend environment overlay remains in its existing location, but bootstrap
installs it into `apps/avenirs-cofolio-client/.env`. Vite consumes it during the
build; the environment file is not copied into the Nginx web root.

After the usual bootstrap, build only the frontend with
`docker compose build avenirs-cofolio-client`. This builds the current submodule
checkout; it does not select or synchronize a branch. `npm run sync` resets the
submodule to the branch configured in `.gitmodules`.

## Cofolio back office client

`avenirs-cofolio-backoffice-client` (same workspace, same build process as above)
is served by its own Nginx container under `/back-office/`
(`https://dev.avenirs-esr.fr/back-office`). Dockerfile:
`services/avenirs-portfolio/Dockerfile-avenirs-cofolio-backoffice-client`,
Compose service: `avenirs-cofolio-backoffice-client`, build with
`docker compose build avenirs-cofolio-backoffice-client`. Its `.env` overlay
(`VITE_BASE_PATH=/back-office/`) is generated by the portfolio bootstrap.

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
- `http://<server>/cas` -> e.g.:  `http://<server\>/cas/login` 

## Database initialisation
The sql initialization scripts can be placed in the folder: *services/postgresql/avenirs-postgresql-overlay/init/*<br/>
The script must be decrypted, for instance using the jasypt tool.<br/>
the "generated tag" in the file name is used to disable the versioning, e.g.: *11_avenirs-security_init-db.generated.sql*.<br/>
An example can be found in *services/avenirs-portfolio/scripts/avenirs-portfolio-bootstrap.sh*<br/>
N.B.: Theses scripts are executed when the container is started for the first time.

## APISIX Initialisation

The APISIX initialization scripts can be placed in the folder: *services/apisix/scripts/initialization.*<br/>
**apisix-generate-routes-from-open-api.sh** can be used to generate the routes from the openapi.json file.<br/>
Theses scripts are executed by a specific initialization container and the entry point is
*init-routes.sh.*<br/>
N.B: the extension curl.sh is used to filter the scripts, e.g.: 10-updateprofile-route.curl.sh.


## Deployed containers

Several containers should be deployed and running. The list of containers may vary, but this is the list at the time this document was written:

<pre>
CONTAINER ID   NAMES                        STATUS        PORTS
2e09fa47d0f5   avenirs-apache               Up 17 hours   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp
a300df2b68b0   avenirs-portfolio-security   Up 18 hours   0.0.0.0:10003->12000/tcp, [::]:10003->12000/tcp
c8775b53c419   avenirs-cas                  Up 18 hours   0.0.0.0:8443->8443/tcp, [::]:8443->8443/tcp, 0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp
79592ffdda03   avenirs-apisix-api           Up 18 hours   0.0.0.0:9080->9080/tcp, [::]:9080->9080/tcp, 0.0.0.0:9091-9092->9091-9092/tcp, [::]:9091-9092->9091-9092/tcp, 0.0.0.0:9180->9180/tcp, [::]:9180->9180/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp
8db72e197ee3   avenirs-pgsql-primary        Up 18 hours   0.0.0.0:65432->5432/tcp, [::]:65432->5432/tcp
27f5be7db3e4   avenirs-apisix-etcd          Up 18 hours   0.0.0.0:2379->2379/tcp, [::]:2379->2379/tcp, 2380/tcp
059251304e11   avenirs-apisix-dashboard     Up 18 hours   0.0.0.0:9000->9000/tcp, [::]:9000->9000/tcp
                            
</pre>