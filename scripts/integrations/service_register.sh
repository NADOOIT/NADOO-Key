#!/usr/bin/env bash
set -Eeuo pipefail

# Integration hook: register a freshly provisioned key with an external service
# Called by factory.sh for each key.
#
# Inputs:
#   --index N         sequential index in the factory run
#   --serial S        device serial (best-effort)
#   --model M         device model (best-effort)
#   ENV:
#     SERVICE_URL     e.g., https://api.example.com/fido/register
#     SERVICE_TOKEN   Bearer/API token for auth (optional)
#     USER_HINT       free text to associate (email/login/name) (optional)
#     RP_ID           relying party ID for registration (optional; service may ignore)
#
# Behavior:
#   - If SERVICE_URL is set, perform a POST with JSON body.
#   - Otherwise, append to $ROOT_DIR/factory/service_queue.csv for later processing.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

index="" serial="" model=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --index) index="$2"; shift 2 ;;
    --serial) serial="$2"; shift 2 ;;
    --model) model="$2"; shift 2 ;;
    *) shift ;;
  esac
done

user_hint="${USER_HINT:-}"
rp_id="${RP_ID:-}"

if [[ -n "${SERVICE_URL:-}" ]]; then
  body=$(jq -n --arg idx "${index}" --arg serial "${serial}" --arg model "${model}" --arg user "${user_hint}" --arg rp "${rp_id}" '{index:$idx, serial:$serial, model:$model, user:$user, rp_id:$rp}')
  hdrs=("-H" "Content-Type: application/json")
  if [[ -n "${SERVICE_TOKEN:-}" ]]; then hdrs+=("-H" "Authorization: Bearer ${SERVICE_TOKEN}"); fi
  curl -fsS -X POST "${SERVICE_URL}" "${hdrs[@]}" -d "${body}" >/dev/null
  echo "[+] Service hook: POST ${SERVICE_URL} (index=${index}, serial=${serial})"
else
  mkdir -p "$ROOT_DIR/factory"
  q="$ROOT_DIR/factory/service_queue.csv"
  if [[ ! -f "$q" ]]; then echo "timestamp,index,serial,model,user_hint,rp_id" >"$q"; fi
  echo "$(date -Is),${index},${serial},${model},${user_hint},${rp_id}" >>"$q"
  echo "[+] Service hook: queued entry in factory/service_queue.csv (index=${index}, serial=${serial})"
fi
