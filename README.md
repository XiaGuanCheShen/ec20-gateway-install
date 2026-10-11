# EC20 3.0.2 Customer Bootstrap

Public installer entry only. This repository contains no gateway source,
customer credentials, private keys, or customer data.

The publisher supplies a short command pinned to an immutable bootstrap commit
and a separate, private delivery credential. Run the command in an interactive
terminal on Debian 12/13 amd64, enter the root password when prompted, then
paste the signed `D1` installation credential into the hidden prompt.

Use [installation-command.txt](installation-command.txt) for the pinned, ASCII-only
3.0.2 installation command. The command itself contains no private credential.

The bootstrap verifies the credential using the publisher's public signing key,
clones `v3.0.2-install` of the private delivery repository, checks commit
`82b1f5e50f7db3c924878a5fdc7bf5d2ab341196` and the authorization public keys,
then starts the installation wizard. Customers read and confirm the usage notice,
scan and initialize modules through Web, and send the resulting application code
to the publisher for an activation code. The activation binds the installation
to one or two module IMEIs.

The signed installation credential carries read-only repository access. Module
activation is issued separately after initialization. Keep the credential private.
Temporary credentials are removed on exit.

The application version installed is 3.0.2. The separate installation tag fixes
3.x customer identity, public key and authorization service setup without moving
the original 3.0.2 tag or replacing its upgrade assets. Existing signed D1
credentials from the same publisher remain valid. Older commands pinned to an
earlier bootstrap commit continue to install that older release; use the new
publisher-provided command for 3.0.2. Cloudflare is not included in this installer.
