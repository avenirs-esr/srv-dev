# 📦 Changelog

This file documents all notable changes made to this project.  
It follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and uses [Semantic Versioning](https://semver.org/).

---

## 📚 Table of Contents

| Version | Date       | Related PR |
|---------|------------|------------|
| [1.9.1] | 2025-08-26 | [PR(#40)](https://github.com/avenirs-esr/srv-dev/pull/40)  |
| [1.9.0] | 2025-07-29 | [PR(#39)](https://github.com/avenirs-esr/srv-dev/pull/39)  |
| [1.8.3] | 2025-07-18 | [PR(#38)](https://github.com/avenirs-esr/srv-dev/pull/38)  |
| [1.8.2] | 2025-07-17 | [PR(#32)](https://github.com/avenirs-esr/srv-dev/pull/32)  |
| [1.8.1] | 2025-07-16 | [PR(#36)](https://github.com/avenirs-esr/srv-dev/pull/36)  |
| [1.8.0] | 2025-07-11 | [PR(#35)](https://github.com/avenirs-esr/srv-dev/pull/35)  |
| [1.7.0] | 2025-07-10 | [PR(#34)](https://github.com/avenirs-esr/srv-dev/pull/34)  |
| [1.6.1] | 2025-07-10 | [PR(#33)](https://github.com/avenirs-esr/srv-dev/pull/33)  |
| [1.6.0] | 2025-07-08 | [PR(#29)](https://github.com/avenirs-esr/srv-dev/pull/29)  |
| [1.5.1] | 2025-07-03 | [PR(#28)](https://github.com/avenirs-esr/srv-dev/pull/28)  |
| [1.5.0] | 2025-06-30 | [PR(#27)](https://github.com/avenirs-esr/srv-dev/pull/27)  |
| [1.4.0] | 2025-06-26 | [PR(#26)](https://github.com/avenirs-esr/srv-dev/pull/26)  |
| [1.3.3] | 2025-06-26 | [PR(#25)](https://github.com/avenirs-esr/srv-dev/pull/25)  |
| [1.3.3] | 2025-06-26 | [PR(#24)](https://github.com/avenirs-esr/srv-dev/pull/24)  |
| [1.3.2] | 2025-06-24 | [PR(#22)](https://github.com/avenirs-esr/srv-dev/pull/22)  |
| [1.3.2] | 2025-06-11 | [PR(#21)](https://github.com/avenirs-esr/srv-dev/pull/21)  |
| [1.3.1] | 2025-06-10 | [PR(#20)](https://github.com/avenirs-esr/srv-dev/pull/20)  |
| [1.3.0] | 2025-05-22 | [PR(#17)](https://github.com/avenirs-esr/srv-dev/pull/17)  |
| [1.2.0] | 2025-05-19 | [PR(#3)](https://github.com/avenirs-esr/avenirs-portfolio-api/pull/3)  |
| [1.1.1] | 2025-05-15 | [PR(#16)](https://github.com/avenirs-esr/srv-dev/pull/16)  |
| [1.1.0] | 2025-05-13 | [PR(#14)](https://github.com/avenirs-esr/srv-dev/pull/14)  |
| [1.0.2] | 2025-05-12 | [PR(#13)](https://github.com/avenirs-esr/srv-dev/pull/13)  |
| [1.0.1] | 2025-05-06 | [PR(#12)](https://github.com/avenirs-esr/srv-dev/pull/12)  |
| [1.0.0] | 2025-04-20 | [PR(#11)](https://github.com/avenirs-esr/srv-dev/pull/11)  |

---
### [1.9.1] - 2025-08-26 - [PR(#40)](https://github.com/avenirs-esr/srv-dev/pull/40)

#### ✨ Added
- added docker containers for opensearch, opensearch-dashboards and valkey

### [1.9.0] - 2025-07-29 - [PR(#39)](https://github.com/avenirs-esr/srv-dev/pull/39)

#### ✨ Added
- added docker volume for file storage

#### 🛠 Changed
- `npm run api:reset-db` triggers now the `reset-storage-volume.sh` script that empty it
- `npm run deploy` triggers now the `init-storage-volume.sh` that initialize the file storage docker volume and copy some placeholders files in it

### [1.8.3] - 2025-07-18 - [PR(#38)](https://github.com/avenirs-esr/srv-dev/pull/38)

#### 🐛 Fixed
- Dependency vulnerabilities

### [1.8.2] - 2025-07-11 - [PR(#32)](https://github.com/avenirs-esr/srv-dev/pull/32)

#### ✨ Added
- grafana dashbords for Apisix, Avenirs Portfolio API and Postgresql primary DB.

### [1.8.1] - 2025-07-16 - [PR(#36)](https://github.com/avenirs-esr/srv-dev/pull/36)

#### 🐛 Fixed
- secrets management for services Apisix, Postgres and LDAP.

### [1.8.0] - 2025-07-11 - [PR(#35)](https://github.com/avenirs-esr/srv-dev/pull/35)

#### ✨ Added
- secrets management.

#### 🛠 Changed
- All the secrets are stored in .secret.env
- new function in srv-dev-commons.sh substitute_secrets_and_dynamics which handles secrets and dynamic variables substitution in template files.
Affected services:
- CAS
- APISIX 
   - API
   - UI
   - Grafana
- OpenLDAP
- PostgreSQL (only root password)

### [1.7.0] - 2025-07-10 - [PR(#34)](https://github.com/avenirs-esr/srv-dev/pull/34)

#### ✨ Added
- dynamic apisix route creation.

### [1.6.1] - 2025-07-10 - [PR(#33)](https://github.com/avenirs-esr/srv-dev/pull/33)

#### 🐛 Fixed
- several deployment pb: docker compose instead of docker-compose, heredoc in Docker file for avenirs-cofolio-client, backend url and cas clean process for commits created by installation process.

### [1.6.0] - 2025-07-08 - [PR(#29)](https://github.com/avenirs-esr/srv-dev/pull/29)

#### ✨ Added
- cofolio client integration.

### [1.5.1] - 2025-07-03 - [PR(#28)](https://github.com/avenirs-esr/srv-dev/pull/28)

#### 🐛 Fixed
- submodules in detached HEAD state.

### [1.5.0] - 2025-06-30 - [PR(#27)](https://github.com/avenirs-esr/srv-dev/pull/27)

#### ✨ Added
-

### [1.5.1] - 2025-07-03 - [PR(#28)](https://github.com/avenirs-esr/srv-dev/pull/28)

#### 🐛 Fixed
- submodules in detached HEAD state.

### [1.5.0] - 2025-06-30 - [PR(#27)](https://github.com/avenirs-esr/srv-dev/pull/27)

#### ✨ Added
- configuration for preflight queries (OPTIONS).
- cors configuration.

### [1.4.0] - 2025-06-26 - [PR(#26)](https://github.com/avenirs-esr/srv-dev/pull/26)

#### ✨ Added
- auth mock handles all user ids generated by seeding in avenirs-portfolio-api.

### [1.3.4] - 2025-06-26 - [PR(#24)](https://github.com/avenirs-esr/srv-dev/pull/24)

#### 🐛 Fixed
- Invalid path segments in apisix routes generation from OpenAPI specification.

### [1.3.3] - 2025-06-26 - [PR(#24)](https://github.com/avenirs-esr/srv-dev/pull/24)

#### 🐛 Fixed
- Broken docker file for avenirs-portfolio-* because of missing environment variable. 
The docker file have been updated to not be dependent on environment variable.

### [1.3.2] - 2025-06-24 - [PR(#22)](https://github.com/avenirs-esr/srv-dev/pull/22)

#### ✨ Changed
- apisix-generate-routes-from-open-api.sh can be used to generate the routes from Open API specification.

### [1.3.2] - 2025-06-11 - [PR(#21)](https://github.com/avenirs-esr/srv-dev/pull/21)

#### ✨ Changed
- OIDC plugin definition
- auth mock adapted in order to work with avenirs-portfolio-api.
- oidc-client/secret for apisix in secret_env (see vaultwarden).
- route initialization scripts refactored to avoid reverse proxy.

### [1.3.1] - 2025-06-10 - [PR(#20)](https://github.com/avenirs-esr/srv-dev/pull/20)

#### ✨ Changed
- Prerequisites script that can stop the process if on prerequisite is not met.
- Use a template fir apisix config file.

#### 🐛 Fixed
- invalid environment variables substitution in apisix config file.

### [1.3.0] - 2025-05-22 - _[API]_ [PR(#17)](https://github.com/avenirs-esr/srv-dev/pull/17)

#### ✨ Added
- Apisix routes for avenirs-portfolio-api's endpoints.
- avenirs-portfolio-api : spring env file generation to inject fixtures in database.
- avenirs-apache: 
    - reverse proxy configuration for avenirs-portfolio-api.
    - end points information removed from index page.

#### 🛠 Changed
- The file for Apisix api keys: *services/apisix/secret_env* must be downloaded from vaultwarden.

##### Curl query samples

**Profile overview on localhost**
```bash
curl -k  --header "Authorization: Bearer AT-1..."  \
-X GET "https://localhost/apim/me/user/student/overview"\
-H "Accept: application/json"
```

**Profile overview on srv-dev-avenir**
```bash
curl -k  --header "Authorization: Bearer AT-1..."  \
-X GET "https://srv-dev-avenir.srv-avenir.brgm.recia.net/apim/me/user/student/overview"\
-H "Accept: application/json"
```

**Profile update on localhost**
```bash
curl -k --header "Authorization: Bearer AT-1-..."   -X PUT "https://localhost/apim/me/user/student/update"   -H "Content-Type: application/json"   -H "Accept: application/json"   -d '{
  "firstname": "Camille2",
  "lastname": "Laurent2",
  "email": "camille2.laurent2@univ.fr",
  "bio": "New bio"
}' 
```

**Profile update on srv-dev-avenir**

curl -k --header "Authorization: Bearer AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r"   -X PUT "https://srv-dev-avenir.srv-avenir.brgm.recia.net/apim/me/user/student/update"   -H "Content-Type: application/json"   -H "Accept: application/json"   -d '{
  "firstname": "Camille2",
  "lastname": "Laurent2",
  "email": "camille2.laurent2@univ.fr",
  "bio": "New bio"
}'

### [1.2.0] - 2025-05-19 - _[API]_ [PR(#3)](https://github.com/avenirs-esr/avenirs-portfolio-api/pull/3)

#### ✨ Added
- avenirs-portfolio-api : added database auto generation.

> **Note:** If the PostgreSQL cluster is already created, the database will not be automatically created during deployment. You need to:
>1. Run a deployment with `npm run deploy`.
>2. Go to the PostgreSQL submodule > `avenirs-postgresql-overlay` > `init` and manually execute the script `11_avenirs-api_init-db.generated.sql` on the `template1` data source.
>3. Afterward, restart the API using `docker restart avenirs-portfolio-api`.

---
### [1.1.1] - 2025-05-15 - [PR(#16)](https://github.com/avenirs-esr/srv-dev/pull/16)

#### ✨ Added
- Authentication mock
- Initialisation process for APISIX routes and plugins


#### 🐛 Fixed
- Missing claims in cas config file.
- Missing include in jasypt script.
- Missing .sdkmanrc.


### [1.1.0] - 2025-05-12 - [PR(#14)](https://github.com/avenirs-esr/srv-dev/pull/14)

#### ✨ Added
- Authentication mock
- Initialisation process for APISIX routes and plugins


### [1.0.2] - 2025-05-12 - [PR(#13)](https://github.com/avenirs-esr/srv-dev/pull/13)

#### ✨ Added
- avenirs-portfolio-api integrated as submodule.

#### 🐛 Fixed
- Missing chmod +x in Docker file for the services under avenirs-portfolio.

---

---
### [1.0.1] - 2025-05-06 - [PR(#12)](https://github.com/avenirs-esr/srv-dev/pull/12)

#### ✨ Added
- remove_file function to handle verbose and warning messages.
- scripts/jasypt which contains a wrapper for jasyp jasypt-util.sh and jasypt jar.


#### 🛠 Changed
- purge npm script: removes the volumes.
- docker compose file in avenirs-portfolio service to disable avenirs-portfolio-storage. 
- avenirs-portfolio-security service is enabled. As it uses jasypt, **the environment variable JASYPT_ENCRYPTOR_PASSWORD must be set.**

#### 🐛 Fixed
- avenirs-portfolio-security service database initialisation see [issue #7](https://github.com/avenirs-esr/srv-dev/issues/7)
---

### [1.0.0] - 2025-04-30 - [PR(#11)](https://github.com/avenirs-esr/srv-dev/pull/11)

🏁 Initial version — this marks the beginning of the changelog tracking for the project.

#### ✨ Added
- Changelog file

---

