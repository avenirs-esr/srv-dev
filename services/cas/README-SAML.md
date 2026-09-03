# Authentification déléguée SAML2 vers la FER

CAS délègue l'authentification aux IdP de la Fédération Éducation-Recherche (FER, RENATER) via SAML2/pac4j. Le choix de l'établissement se fait sur le WAYF de la FER, et l'IdP choisi est résolu à la demande via MDQ (pas d'agrégat statique de métadonnées).

## Principe

1. L'utilisateur clique sur "Sélectionner le fournisseur d'identité" sur `/cas/login`.
2. Redirection vers le WAYF de la FER (`discovery.renater.fr`).
3. L'utilisateur choisit son établissement, la FER redirige vers CAS avec l'`entityID` choisi.
4. CAS interroge le MDQ de la FER (`mdq.federation.renater.fr/.../entities/{entityID}`) pour récupérer les métadonnées de cet IdP, vérifiées par signature.
5. CAS construit un client SAML2 pour cet IdP et redirige l'utilisateur vers son écran de connexion.
6. Retour de l'IdP → CAS valide la réponse SAML et authentifie l'utilisateur.

## Fichiers

- `avenirs-cas-overlay/etc/cas/config/cas.properties.template` — toute la configuration (`cas.authn.pac4j.saml[0].*`, `avenirs.cas.saml-fer-wayf.*`, `avenirs.cas.saml-fer-mdq.*`)
- `avenirs-cas-overlay/src/main/java/fr/avenirsesr/cas/saml/fer/` — code Java (webflow custom + résolution MDQ)
- `avenirs-cas-overlay/src/main/resources/fer/renater-metadata-query-signing-cert.pem` — certificat public RENATER utilisé pour vérifier les réponses MDQ

## Configuration requise

| Propriété | Rôle |
|---|---|
| `cas.authn.pac4j.saml[0].keystore-path` / `keystore-password` / `private-key-password` | Identité SP de CAS (clé/certificat). Généré par `scripts/cas-saml-init.sh`. |
| `cas.authn.pac4j.saml[0].service-provider-entity-id` | entityID de notre SP, à faire enregistrer auprès de chaque IdP/fédération. |
| `cas.authn.pac4j.saml[0].metadata.identity-provider-metadata-path` | Bootstrap uniquement (une entité MDQ arbitraire, sert juste à initialiser CAS au démarrage) — **pas** utilisé pour l'authentification réelle. |
| `avenirs.cas.saml-fer-wayf.url` | URL du WAYF de la fédération ciblée (`/test`, `/qualif`, `/fer` selon l'environnement). |
| `avenirs.cas.saml-fer-mdq.url` | URL de base MDQ de la même fédération. |
| `avenirs.cas.saml-fer-mdq.signing-certificate` | Certificat de signature des métadonnées MDQ (à re-vérifier si RENATER le fait tourner). |

⚠️ Les URLs WAYF/MDQ sont actuellement codées en dur sur la fédération de **test**. À adapter par environnement.

## Prérequis côté FER/IdP

Chaque IdP auquel on veut se connecter doit connaître notre SP (`service-provider-entity-id`) et ses métadonnées (`https://<cas>/cas/sp/FER/metadata`). Sans cet enregistrement côté IdP, l'authentification échoue avec *"Application non autorisée à utiliser CAS"* affiché **par l'IdP**, pas par notre CAS.

## Tester

1. `docker exec -it <conteneur_cas> curl ...` (ou `bash -c "exec 3<>/dev/tcp/..."` si `curl` absent de l'image) pour vérifier la connectivité sortante vers `mdq.federation.renater.fr` et `discovery.renater.fr`.
2. Logs CAS : activer temporairement `logging.level.org.pac4j=DEBUG`, `logging.level.org.opensaml=DEBUG`, `logging.level.org.apache.hc=DEBUG`, `logging.level.fr.avenirsesr.cas=DEBUG` dans `cas.properties.template` en cas de problème, puis les retirer une fois résolu.

## Limites connues

- Pas de repli si le MDQ de la FER est indisponible au moment d'une connexion (contrairement à un agrégat statique téléchargé une fois).
- `avenirs.cas.saml-fer-mdq.url`/`avenirs.cas.saml-fer-wayf.url` non paramétrés par environnement.
- Aucun test automatisé sur ce code.
