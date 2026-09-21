#!/usr/bin/env bash
# Extrae el certificado HTTPS público de la imagen DOORS (solo lectura, sin clave privada).
# Útil cuando se publica una nueva imagen y hay que actualizar infra/certs/doors-localhost.crt
set -euo pipefail

IMAGE="${DOORS_IMAGE:-davidpestana/elx-lab:exp-2026-08}"
OUT="$(cd "$(dirname "$0")" && pwd)/certs/doors-localhost.crt"

mkdir -p "$(dirname "$OUT")"

docker run --rm --entrypoint bash "$IMAGE" -c '
  KEYTOOL=$(find /opt/IBM/JazzTeamServer -name keytool -type f | head -1)
  "$KEYTOOL" -exportcert -alias default \
    -keystore /opt/IBM/JazzTeamServer/server/liberty/servers/clm/resources/security/ibm-team-ssl.p12 \
    -storetype PKCS12 -storepass ibm-team -rfc
' > "$OUT"

openssl x509 -in "$OUT" -noout -subject -dates
echo "Certificado guardado en: $OUT"
