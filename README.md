# EC20 3.0.4 Customer Bootstrap

Public installer entry only. This repository contains no gateway source,
customer credentials, private keys, or customer data.

The publisher supplies a short command pinned to an immutable bootstrap commit
and a separate, private delivery credential. Run the command in an interactive
terminal on Debian 12/13 amd64, enter the root password when prompted, then
paste the signed `D1` installation credential into the hidden prompt.

Use [installation-command.txt](installation-command.txt) for the pinned, ASCII-only
3.0.4 installation command. The command itself contains no private credential.

The bootstrap verifies the credential using the publisher's public signing key,
clones `v3.0.4` of the private delivery repository, checks commit
`21ce233c285a10144e2acdb93e200eec8c3fcd2d` and the authorization public keys,
then starts the installation wizard. Customers read and confirm the usage notice,
scan and initialize modules through Web, and send the resulting application code
to the publisher for an activation code. The activation binds the installation
to one or two module IMEIs.

The signed installation credential carries read-only repository access. Module
activation is issued separately after initialization. Keep the credential private.
Temporary credentials are removed on exit.

The application version installed is 3.0.4. Existing signed D1 credentials from
the same publisher remain valid. No authorization or release public key changes
are required. Old release tags and upgrade assets are preserved. Older commands
pinned to an earlier bootstrap commit still install that older release; use the
current installation-command.txt for 3.0.4.

New installations use DHCP-safe LAN Web access on port 8787. Access follows the
current private IPv4 subnet of the selected LAN interface; public sources are not
automatically permitted. Existing fixed listener configurations are not silently
changed by an upgrade and require the documented one-time migration.

Cloudflare fallback support is inherited from 3.0.3. The cloudflared daemon is
installed only when explicitly requested through Web. Live Tunnel, Access and
iPhone fallback validation remain separate from software regression.
