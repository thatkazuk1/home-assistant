# home-assistant

A Home Assistant Lovelace dashboard for a homelab — dark-mode, glassmorphism, mobile-first —
plus the per-host power-control scripts it drives and the design process behind it.

## Table of Contents
- [About the Project](#about-the-project)
- [Project Status](#project-status)
- [Getting Started](#getting-started)
  - [Dependencies](#dependencies)
  - [Technology Stack](#technology-stack)
  - [Third-party Services](#third-party-services)
- [Installation & Development](#installation--development)
  - [Setting Up](#setting-up)
  - [Development](#development)
  - [Testing](#testing)
- [How to Get Help](#how-to-get-help)
- [Contributing](#contributing)
- [Authors](#authors)
  - [Repo Activity](#repo-activity)

## About the Project

This is the Lovelace dashboard for the Home Assistant instance running on `core-01` (a
Raspberry Pi 4) in [the homelab this repo belongs to](https://github.com/meetKazuki/homelab).
Home Assistant on that host is intentionally **not** managed through the fleet's Komodo/GitOps
pipeline — it's hand-run — so this repo is where its dashboard, supporting scripts, and the
design process behind them are kept in version control and shared publicly, separately from
the infrastructure-as-code monorepo.

**Canonical repo:** self-hosted Forgejo (`forgejo.ts.kazuki.uk/kazuki/home-assistant`),
reachable only over Tailscale. **This GitHub repo is a read-only mirror** — all real work
(commits, issues) happens against the canonical repo; treat pushes, issues, or PRs opened here
as informational rather than actionable.

## Project Status

![status](https://img.shields.io/badge/status-active-brightgreen)
![git](https://img.shields.io/badge/canonical%20git-self--hosted%20Forgejo-blue)

Actively developed alongside the Home Assistant instance it documents. There's no CI here —
see [Testing](#testing) for how changes are actually validated.

## Getting Started

### Dependencies

To read or adapt this dashboard (not to run Home Assistant itself):

- **A Home Assistant instance** running in YAML mode (`ui-lovelace.yaml`, not the UI editor) —
  see [Home Assistant's docs](https://www.home-assistant.io/dashboards/) for switching modes.
- **[Mushroom cards](https://github.com/piitaya/lovelace-mushroom)**,
  **[Bubble Card](https://github.com/Clooos/Bubble-Card)**,
  **[button-card](https://github.com/custom-cards/button-card)**, and
  **[card-mod](https://github.com/thomasloven/lovelace-card-mod)** via
  [HACS](https://hacs.xyz) — the custom cards this dashboard is built from.
- **An SSH client** — `scripts/host-power-control.sh` reaches every host over SSH; present by
  default on Linux/macOS.

### Technology Stack

- **[Home Assistant](https://www.home-assistant.io)** — the platform this dashboard runs on
- **Lovelace (YAML mode)** — the dashboard is one hand-authored `ui-lovelace.yaml`, not the UI
  editor
- **[Mushroom](https://github.com/piitaya/lovelace-mushroom)** — the template/chip cards making
  up most of the UI
- **[Bubble Card](https://github.com/Clooos/Bubble-Card)** — pop-ups and the bottom navigation
  bar
- **[button-card](https://github.com/custom-cards/button-card)** — the Infrastructure screen's
  per-host action icons and stat chips
- **[card-mod](https://github.com/thomasloven/lovelace-card-mod)** — the glassmorphism theming
  and layout overrides throughout
- **[ntfy](https://ntfy.sh)** — best-effort push notification when a power-control action fires
- **[Claude.ai Design](https://claude.ai)** — used to plan the visual language and screen layout
  before building it; see `design/`

### Third-party Services

- **ntfy** — self-hosted push notifications for reboot/shutdown actions
- **Claude.ai** — hosted the design project this dashboard was planned in

## Installation & Development

### Setting Up

```bash
git clone https://forgejo.ts.kazuki.uk/kazuki/home-assistant.git
cd home-assistant
```

This isn't meant to be pasted in wholesale — `dashboard/ui-lovelace.yaml` uses this specific
installation's real entity IDs, and depends on the `shell_command`/`command_line` entries in
`dashboard/configuration-snippets.yaml` plus the two scripts in `scripts/`. Adapt entity IDs,
host IPs, and SSH details in `scripts/host-power-control.sh` to your own setup.

### Development

Edit `dashboard/ui-lovelace.yaml` directly (or via Home Assistant's Raw Configuration Editor on
the live instance), reload the dashboard, and visually confirm in the browser — there's no
build step. Changes to the design process itself live in `design/` and were made through the
Claude.ai Design project referenced there, not by hand-editing the exported files.

### Testing

There's no automated test suite — this is dashboard configuration, not application code. What
validates a change instead:

- **`homeassistant --script check_config`** — run against the live instance after any
  `configuration.yaml`-side change (see `dashboard/configuration-snippets.yaml`).
- **A visual pass in the browser** — confirm cards render, status chips reflect live entity
  state, and every double-tap action surfaces its confirmation dialog before it's ever
  confirmed for real.

## How to Get Help

This is a personal homelab, not a supported project — there's no SLA and no dedicated support
channel. See [the main homelab repo](https://github.com/meetKazuki/homelab) for the broader
infrastructure this dashboard sits on top of.

## Contributing

Not actively seeking contributions — this is a single-operator homelab and the canonical repo
lives on self-hosted Forgejo, not here. That said, this GitHub mirror's issue tracker is a
reasonable place to flag something genuinely broken in the public material (a wrong command, a
dead link); it's checked periodically, not continuously.

**[Back to top](#table-of-contents)**

## Authors

**Desmond Edem** ([@thatkazuk1](https://github.com/thatkazuk1)) — sole operator and author.

### Repo Activity

TBA.
