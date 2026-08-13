#! /bin/bash

#--------------------------------------------------------------#
# CAS SAML2 SP identity initialization (delegated auth to FER) #
#                                                                #
# Idempotently generates the SP keystore (RSA keypair + self-  #
# signed cert, JKS) used by cas.authn.pac4j.saml[0].* in        #
# cas.properties.template. Never regenerates an existing one.   #
# Details/rationale: services/cas/README-SAML.md                #
#--------------------------------------------------------------#

CAS_SCRIPT_DIR=`dirname $0`

# Initialization
. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
. $CAS_SCRIPT_DIR/cas-env.sh $CAS_SCRIPT_DIR || err "Unable to source $CAS_SCRIPT_DIR/cas-env.sh"

info "CAS SAML SP identity initialization started (environment: $AVENIRS_CAS_ENV_LABEL)."

# ---- Prerequisites ----
command -v docker >/dev/null 2>&1 || err "docker CLI not found on this host (required to run keytool with CAS's exact JDK image)"

[ -z "$SEC_CAS_SAML_FER_KEYSTORE_PASSWORD" ] && err "SEC_CAS_SAML_FER_KEYSTORE_PASSWORD is not set (see .secrets.env / .secrets.env.example)"
[ -z "$SEC_CAS_SAML_FER_PRIVATE_KEY_PASSWORD" ] && err "SEC_CAS_SAML_FER_PRIVATE_KEY_PASSWORD is not set (see .secrets.env / .secrets.env.example)"
export SEC_CAS_SAML_FER_KEYSTORE_PASSWORD
export SEC_CAS_SAML_FER_PRIVATE_KEY_PASSWORD

# ---- Constants (must stay consistent with cas.authn.pac4j.saml[0].* in cas.properties.template) ----
CAS_SAML_ALIAS="fer-sp"
CAS_SAML_KEYSTORE_FILE="fer-sp-keystore.jks"
CAS_SAML_CERT_FILE="fer-sp-cert.pem"
CAS_SAML_CONTAINER_DIR="/etc/cas/saml"
CAS_SAML_VALIDITY_DAYS=1825
CAS_SAML_KEYSIZE=3072
CAS_SAML_SIGALG="SHA256withRSA"

# JDK/keytool must match CAS's own runtime exactly.
CAS_DOCKERFILE="$CAS_OVERLAY_DIR/Dockerfile"
[ -f "$CAS_DOCKERFILE" ] || err "Dockerfile not found: $CAS_DOCKERFILE"
CAS_BASE_IMAGE=$(grep -m1 '^ARG BASE_IMAGE=' "$CAS_DOCKERFILE" | sed -E 's/^ARG BASE_IMAGE="?([^"]*)"?$/\1/')
[ -z "$CAS_BASE_IMAGE" ] && err "Unable to determine BASE_IMAGE from $CAS_DOCKERFILE"
verbose "Using JDK image: $CAS_BASE_IMAGE (from $CAS_DOCKERFILE)"

# DN: consistent with the environment (dev/qualif/recette), never shared.
CAS_SAML_DN_CN="${AVENIRS_CAS_SERVER_NAME#https://}"
CAS_SAML_DN="CN=${CAS_SAML_DN_CN},OU=FER-SP-${AVENIRS_CAS_ENV_LABEL},O=Avenirs-ESR,C=FR"
verbose "Using DN: $CAS_SAML_DN"
verbose "Using volume: $AVENIRS_CAS_SAML_VOLUME_NAME"

# ---- Idempotent keystore generation ----
KEYSTORE_EXISTS=$(docker run --rm \
    -v "${AVENIRS_CAS_SAML_VOLUME_NAME}:${CAS_SAML_CONTAINER_DIR}" \
    "$CAS_BASE_IMAGE" \
    sh -c "[ -f ${CAS_SAML_CONTAINER_DIR}/${CAS_SAML_KEYSTORE_FILE} ] && echo yes || echo no") \
    || err "Unable to inspect volume ${AVENIRS_CAS_SAML_VOLUME_NAME}"

if [ "$KEYSTORE_EXISTS" = "yes" ]; then
    info "Keystore already present in volume ${AVENIRS_CAS_SAML_VOLUME_NAME} (${CAS_SAML_KEYSTORE_FILE}) - not regenerated."
else
    info "Generating SAML SP keystore (RSA ${CAS_SAML_KEYSIZE}, ${CAS_SAML_SIGALG}, ${CAS_SAML_VALIDITY_DAYS}d) in volume ${AVENIRS_CAS_SAML_VOLUME_NAME}..."
    docker run --rm \
        -v "${AVENIRS_CAS_SAML_VOLUME_NAME}:${CAS_SAML_CONTAINER_DIR}" \
        -e SEC_CAS_SAML_FER_KEYSTORE_PASSWORD \
        -e SEC_CAS_SAML_FER_PRIVATE_KEY_PASSWORD \
        "$CAS_BASE_IMAGE" \
        keytool -genkeypair \
            -alias "$CAS_SAML_ALIAS" \
            -keyalg RSA \
            -keysize $CAS_SAML_KEYSIZE \
            -sigalg $CAS_SAML_SIGALG \
            -validity $CAS_SAML_VALIDITY_DAYS \
            -dname "$CAS_SAML_DN" \
            -keystore "${CAS_SAML_CONTAINER_DIR}/${CAS_SAML_KEYSTORE_FILE}" \
            -storetype JKS \
            -storepass:env SEC_CAS_SAML_FER_KEYSTORE_PASSWORD \
            -keypass:env SEC_CAS_SAML_FER_PRIVATE_KEY_PASSWORD \
        > /dev/null \
        && info "Keystore generated." \
        || err "keytool keystore generation failed"
fi

# ---- Public certificate export (PEM) - safe to (re)export on every run, no secret material ----
info "Exporting public certificate to ${CAS_SAML_CERT_FILE} (PEM)..."
docker run --rm \
    -v "${AVENIRS_CAS_SAML_VOLUME_NAME}:${CAS_SAML_CONTAINER_DIR}" \
    -e SEC_CAS_SAML_FER_KEYSTORE_PASSWORD \
    "$CAS_BASE_IMAGE" \
    keytool -exportcert \
        -alias "$CAS_SAML_ALIAS" \
        -keystore "${CAS_SAML_CONTAINER_DIR}/${CAS_SAML_KEYSTORE_FILE}" \
        -storepass:env SEC_CAS_SAML_FER_KEYSTORE_PASSWORD \
        -rfc \
        -file "${CAS_SAML_CONTAINER_DIR}/${CAS_SAML_CERT_FILE}" \
    > /dev/null \
    && info "Certificate exported: volume ${AVENIRS_CAS_SAML_VOLUME_NAME}:/${CAS_SAML_CERT_FILE}" \
    || err "keytool certificate export failed"

info "CAS SAML SP identity initialization completed (environment: $AVENIRS_CAS_ENV_LABEL)."
info "Keystore volume: ${AVENIRS_CAS_SAML_VOLUME_NAME} (mounted at ${CAS_SAML_CONTAINER_DIR} in the cas container)."
info "To retrieve the PEM certificate on the host: docker run --rm -v ${AVENIRS_CAS_SAML_VOLUME_NAME}:${CAS_SAML_CONTAINER_DIR} ${CAS_BASE_IMAGE} cat ${CAS_SAML_CONTAINER_DIR}/${CAS_SAML_CERT_FILE}"
