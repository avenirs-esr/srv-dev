# 📦 Changelog

This file documents all notable changes made to this project.  
It follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and uses [Semantic Versioning](https://semver.org/).

---

## 📚 Table of Contents

| Version | Date       | Related PR |
|---------|------------|------------|
| [1.2.0] | 2025-05-19 | [PR(#3)](https://github.com/avenirs-esr/avenirs-portfolio-api/pull/3)  |
| [1.1.1] | 2025-05-15 | [PR(#16)](https://github.com/avenirs-esr/srv-dev/pull/16)  |
| [1.1.0] | 2025-05-13 | [PR(#14)](https://github.com/avenirs-esr/srv-dev/pull/14)  |
| [1.0.2] | 2025-05-12 | [PR(#13)](https://github.com/avenirs-esr/srv-dev/pull/13)  |
| [1.0.1] | 2025-05-06 | [PR(#12)](https://github.com/avenirs-esr/srv-dev/pull/12)  |
| [1.0.0] | 2025-04-20 | [PR(#11)](https://github.com/avenirs-esr/srv-dev/pull/11)  |

---
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

