# EC20 3.0.7 Customer Bootstrap

Public installer entry only. This repository contains no gateway source,
customer credentials, private keys, or customer data.

The publisher supplies a short command pinned to an immutable bootstrap commit
and a separate, private delivery credential. Run the command in an interactive
terminal on Debian 12/13 amd64, enter the root password when prompted, then
paste the signed `D1` installation credential into the hidden prompt.

Use [installation-command.txt](installation-command.txt) for the pinned, ASCII-only
3.0.7 installation command. The command itself contains no private credential.

The bootstrap verifies the credential using the publisher's public signing key,
clones `v3.0.7` of the private delivery repository, checks commit
`95f0adf9480d821eab4ddbf7b4ad8b5f49a57523` and the authorization public keys,
then starts the installation wizard. Customers read and confirm the usage notice,
scan and initialize modules through Web, and send the resulting application code
to the publisher for an activation code. The activation binds the installation
to one or two module IMEIs.

The signed installation credential carries read-only repository access. Module
activation is issued separately after initialization. Keep the credential private.
Temporary credentials are removed on exit.

The application version installed is 3.0.7. Existing signed D1 credentials from
the same publisher remain valid. No authorization or release public key changes
are required. Old release tags and upgrade assets are preserved. Older commands
pinned to an earlier bootstrap commit still install that older release; use the
current installation-command.txt for 3.0.7.

New installations use DHCP-safe LAN Web access on port 8787. Access follows the
current private IPv4 subnet of the selected LAN interface; public sources are not
automatically permitted. Existing fixed listener configurations are not silently
changed by an upgrade and require the documented one-time migration.

Cloudflare fallback support is inherited from 3.0.3. The cloudflared daemon is
installed only when explicitly requested through Web. Live Tunnel, Access and
iPhone fallback validation remain separate from software regression.

3.0.5 includes CellPilot reconnect and media recovery, independent bounded audio
senders, direct TLS failure isolation, complete Feishu runtime checks and a Web
OTP privacy toggle. Existing installations expose runtime dependency repair and
chan_quectel migration as separate background update stages. Wait for those
stages before phone acceptance. No new UDP transport or phone-side echo
cancellation is included.

3.0.6 fixes cold creation of the runtime and driver background services. Only
actually failed units have their failure state reset. Optional queue failures are
reported independently and no longer prevent the updater from resuming its
original services. A machine already left with stopped services by a failed 3.0.5
upgrade still needs explicit, verified recovery of those original services; this
entry does not blindly start all services or reinitialize modules.

3.0.7 fixes migration checks on verified old Asterisk build directories without
changing their permissions, and uses EC20 COPS access technology for native
GSM/EDGE/WCDMA/LTE status. Already applied driver patches are preserved. No
automatic RF reset or modem initialization is added; wait for the idle-only
driver migration before checking radio status after an upgrade.
