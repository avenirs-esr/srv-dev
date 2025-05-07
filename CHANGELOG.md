# 📦 Changelog

This file documents all notable changes made to this project.  
It follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and uses [Semantic Versioning](https://semver.org/).

---

## 📚 Table of Contents

| Version | Date       | Related PR |
|---------|------------|------------|

| [1.0.1] | 2025-05-06 | [PR(#11)](https://github.com/avenirs-esr/srv-dev/pull/12)  |
| [1.0.0] | 2025-04-20 | [PR(#11)](https://github.com/avenirs-esr/srv-dev/pull/11)  |

---
### [1.0.1] - 2025-05-06 - [PR(#12)](https://github.com/avenirs-esr/srv-dev/pull/12)

#### ✨ Added
- remove_file function to handle verbose and warning messages.
- scripts/jasypt which wontains a wrapper for jasyp jasypt-util.sh and jasypt jar.


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



### [1.0.2] - 

#### ✨ Added

#### 🛠 Changed

#### 🐛 Fixed

---

