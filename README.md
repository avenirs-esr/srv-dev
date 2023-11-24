# Development Environment - srv-dev
The repository can be used to install the services and all the development environment for the Avenirs-ESR's ePortfolio.

## Prerequisites
Git, Docker (tested with 24.0.6) and docker-compose >=2.2.0 for the support of "include".

## Tree structure

h
srv-dev-env.sh
<pre>
. 
├── docker-compose.yml              Main docker compose file
├── scripts                         Main Scripts directory
│   ├── srv-dev-bootstrap.sh        Main bootsrapping script
│   ├── srv-dev-clean.sh            Removes all the bootstrap modifications
│   ├── srv-dev-commons.sh          Helpers and constants for the bash scripts
│   └── srv-dev-env.sh              Main environment file
└── services
    ├── apisix
    │   ├── apisix-docker            git submodule: https://github.com/apache/apisix-docker.git
    │   ├── avenirs-apisix-overlay
    │   │   └── example
    │   │       └── docker-compose.yml
    │   └── scripts                 Service scripts directorygi
    │       └── apisix-bootstrap.sh
    ├── cas
    │   ├── avenirs-cas-overlay       git submodule: https://github.com/apereo/cas-overlay-template.git 
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
    └── openldap                      custom container based on osixia's images
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

</pre>
