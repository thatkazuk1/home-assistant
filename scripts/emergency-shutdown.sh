#!/bin/bash
# Emergency Shutdown Sequence (Staggered)

# 1. Notify
curl -s -H "Authorization: Bearer <REDACTED_NTFY_TOKEN>" -d "Emergency shutdown sequence initiated!" "https://ntfy.kazuki.uk/homelab-critical"

# DRY-RUN CHECK
if [ "$1" == "--dry-run" ]; then
    echo "[DRY-RUN] Sending poweroff to pve-01, pve-02, nas-01..."
    echo "[DRY-RUN] Waiting 60 seconds..."
    echo "[DRY-RUN] Sending poweroff to OPNsense (192.168.10.1)..."
    echo "[DRY-RUN] Waiting 10 seconds..."
    echo "[DRY-RUN] Sending poweroff to localhost (core-01)..."
    curl -s -H "Authorization: Bearer <REDACTED_NTFY_TOKEN>" -d "[DRY-RUN] Emergency shutdown sequence completed successfully." "https://ntfy.kazuki.uk/homelab-critical"
    exit 0
fi

# 2. Shutdown Proxmox nodes and NAS concurrently
ssh -i /config/.ssh/id_ed25519 -o StrictHostKeyChecking=no root@192.168.50.10 'poweroff' &
ssh -i /config/.ssh/id_ed25519 -o StrictHostKeyChecking=no root@192.168.50.11 'poweroff' &
ssh -i /config/.ssh/id_ed25519 -o StrictHostKeyChecking=no -p 9222 nexus-tnas@192.168.50.163 'poweroff' &

# 3. Wait exactly 60 seconds
sleep 60

# 4. Tell OPNsense to shutdown
ssh -i /config/.ssh/id_ed25519 -o StrictHostKeyChecking=no root@192.168.10.1 'poweroff'

# 5. Brief pause to let OPNsense initiate shutdown
sleep 10

# 6. Self shutdown (core-01)
ssh -i /config/.ssh/id_ed25519 -o StrictHostKeyChecking=no kazuki@192.168.50.3 'sudo poweroff'
