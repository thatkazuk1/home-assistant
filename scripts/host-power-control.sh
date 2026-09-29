#!/bin/bash
# Host Power Control — reboot/shutdown a single homelab host from the
# Infrastructure dashboard. Separate from emergency-shutdown.sh, which
# remains the dedicated "shut down everything, staggered" script.
#
# Usage: host-power-control.sh <host-key> <action> [--dry-run]
#   host-key : nas-01 | core-01 | pve-01 | pve-02 | fw-01
#   action   : reboot | shutdown

set -u

SSH_KEY="/config/.ssh/id_ed25519"
NTFY_TOPIC="https://ntfy.kazuki.uk/homelab-critical"
SECRETS_FILE="/config/secrets.yaml"

HOST_KEY="${1:-}"
ACTION="${2:-}"
DRY_RUN="${3:-}"

usage() {
    echo "Usage: $0 <host-key> <action> [--dry-run]" >&2
    echo "  host-key: nas-01 | core-01 | pve-01 | pve-02 | fw-01" >&2
    echo "  action:   reboot | shutdown" >&2
    exit 1
}

[ -z "$HOST_KEY" ] && usage
[ -z "$ACTION" ] && usage

case "$ACTION" in
    reboot)   REMOTE_CMD_BASE="reboot" ;;
    shutdown) REMOTE_CMD_BASE="poweroff" ;;
    *)
        echo "ERROR: unknown action '$ACTION' (expected: reboot|shutdown)" >&2
        exit 2
        ;;
esac

case "$HOST_KEY" in
    nas-01)  SSH_USER="nexus-tnas"; SSH_HOST="192.168.50.163"; SSH_PORT="9222"; REMOTE_CMD="$REMOTE_CMD_BASE" ;;
    pve-01)  SSH_USER="root";       SSH_HOST="192.168.50.10";  SSH_PORT="22";   REMOTE_CMD="$REMOTE_CMD_BASE" ;;
    pve-02)  SSH_USER="root";       SSH_HOST="192.168.50.11";  SSH_PORT="22";   REMOTE_CMD="$REMOTE_CMD_BASE" ;;
    fw-01)   SSH_USER="root";       SSH_HOST="192.168.10.1";   SSH_PORT="22";   REMOTE_CMD="$REMOTE_CMD_BASE" ;;
    core-01) SSH_USER="kazuki";     SSH_HOST="192.168.50.3";   SSH_PORT="22";   REMOTE_CMD="sudo $REMOTE_CMD_BASE" ;;
    *)
        echo "ERROR: unknown host-key '$HOST_KEY' (expected: nas-01|core-01|pve-01|pve-02|fw-01)" >&2
        exit 2
        ;;
esac

if [ "$DRY_RUN" == "--dry-run" ]; then
    echo "[DRY-RUN] ${ACTION} on ${HOST_KEY} -> ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -p ${SSH_PORT} ${SSH_USER}@${SSH_HOST} '${REMOTE_CMD}'"
    exit 0
fi

# Best-effort ntfy notification, sourced from secrets.yaml rather than
# hardcoding a second copy of the token that already lives inline in
# emergency-shutdown.sh. Missing key -> notification is silently skipped,
# the action still proceeds.
NTFY_TOKEN="$(awk -F': ' '/^ntfy_token:/{print $2}' "$SECRETS_FILE" 2>/dev/null)"
if [ -n "$NTFY_TOKEN" ]; then
    curl -s -H "Authorization: Bearer ${NTFY_TOKEN}" \
        -d "⚠️ core-01 dashboard: ${ACTION} initiated for ${HOST_KEY}" \
        "${NTFY_TOPIC}" >/dev/null 2>&1
fi

ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "${SSH_PORT}" \
    "${SSH_USER}@${SSH_HOST}" "${REMOTE_CMD}"
exit $?
