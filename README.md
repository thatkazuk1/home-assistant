# home-assistant

A Home Assistant Lovelace dashboard for a homelab — dark-mode, glassmorphism, mobile-first —
plus the per-host power-control scripts it drives and the design process behind it.

## About the Project

This is the dashboard configuration for the Home Assistant instance running on `core-01`
(a Raspberry Pi 4) in [the homelab this repo belongs to](https://github.com/meetKazuki/homelab).
Home Assistant on that host is intentionally **not** managed through the fleet's Komodo/GitOps
pipeline — it's hand-run, and this repo is where its dashboard and supporting scripts are kept
in version control and shared publicly, separately from the infrastructure-as-code monorepo.

**Canonical repo:** self-hosted Forgejo (`forgejo.ts.kazuki.uk/kazuki/home-assistant`), reachable
only over Tailscale. **This GitHub repo is a read-only mirror.**

## What's in here

```
dashboard/
├── ui-lovelace.yaml             # the actual, currently-deployed Lovelace YAML
└── configuration-snippets.yaml  # the configuration.yaml excerpts it depends on
                                  # (shell_command + command_line entries — not a full config)
scripts/
├── host-power-control.sh        # per-host reboot/shutdown, called from the dashboard
└── emergency-shutdown.sh        # staggered "shut down everything" sweep
design/
├── dashboard.yaml                    # room-control screens spec (Home/Living Room/etc.)
├── existing-dashboard-reference.yaml # condensed design-pattern + entity-ID reference
├── Dashboard-Preview.dc.html         # visual mockup of every screen, including Infrastructure
└── Design-Document.dc.html           # full design spec: screen map, component patterns, etc.
```

The `dashboard/` and `scripts/` files are a real, working reference — copied from the live
host with only true secrets redacted (an ntfy notification token). Real IPs, hostnames, and
entity IDs are left as-is.

The `design/` files are exported from a [Claude.ai Design](https://claude.ai) project used to
plan the dashboard's visual language (glassmorphism, card layout, component patterns) before
building it. They document the design decisions, not just the end state.

## Dashboard overview

Two kinds of screens:

- **Room control** — Home, Living Room, Master Bedroom, Guest Bedroom, Kitchen, Cameras.
  Per-room climate/media/switch controls, a shared bottom nav, live power draw, and a finance
  summary on the Home screen.
- **Infrastructure** — a homelab ops view. A 3-per-row grid of host cards (`fw-01`, `core-01`,
  `nas-01`, `pve-01`, `pve-02`) each showing online/offline status (or CPU/Mem for `core-01`,
  the host running Home Assistant itself), with small top-right icon buttons for reboot/shutdown
  triggered only on double-tap with a confirmation dialog — plus a compact "shut down everything"
  button for the whole fleet.

Design system: dark mode, `rgba(255,255,255,0.06)` glass cards with `blur(25px) saturate(120%)`
for room screens (slightly more subdued `0.04`/`blur(16px)` for the Infrastructure screen, since
it's an ops surface rather than a room), no pill/chip backgrounds on nested elements, system font
stack, 2-column responsive grid collapsing to 1 column below 800px.

## Using this

`dashboard/ui-lovelace.yaml` is meant to be read as a reference, not pasted in wholesale — it
uses this specific installation's real entity IDs, and depends on the `shell_command`/
`command_line` entries in `dashboard/configuration-snippets.yaml` plus the two scripts in
`scripts/`. Adapt entity IDs, host IPs, and SSH details in `scripts/host-power-control.sh` to
your own setup.

## Authors

**Desmond Edem** ([@thatkazuk1](https://github.com/thatkazuk1)) — sole operator and author.
