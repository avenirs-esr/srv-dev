# Development Environment - srv-dev
The repository can be used to install the services and all the development environment for the Avenirs ePortfolio.

## Prerequisites
Docker (tested with 24.0.6) and docker-compose >=2.2.0 for the support of "include".

## Tree structure

<pre>
. 
├── docker-compose.yml              Main docker compose file
├── scripts
│   ├── commons.sh                  Helpers for the bash scripts
│   └── srv-dev-bootstrap.sh        Main bootsrapping file
└── services
    ├── apisix
    │   ├── apisix-docker            git submodule: https://github.com/apache/apisix-docker.git
    │   ├── avenirs-apisix-overlay
    │   │   └── example
    │   │       └── docker-compose.yml
    │   └── scripts
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


# Local installation

## Fetch the repository
<pre>
git clone git@github.com:avenirs-esr/srv-dev.git --recurse
cd srv-dev/
npm i
</pre>

## Bootstrap
./scr
