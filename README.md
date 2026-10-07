# EC20 2.1.11 Customer Bootstrap

Public installer entry only. This repository contains no gateway source,
customer credentials, private keys, or customer data.

The publisher supplies a short command pinned to an immutable bootstrap commit
and a separate, private delivery credential. Run the command in an interactive
terminal on Debian 12/13 amd64, enter the root password when prompted, then
paste the signed `D1` installation credential into the hidden prompt.

The bootstrap verifies the credential using the publisher's public signing key,
clones `v2.1.11` of the private delivery repository, checks commit
`c6aa3a7d60ee30bf6ab379fe9a1afdcf8382a439` and the authorization public keys,
then starts the installation wizard. Customers read and confirm the usage notice,
scan and initialize modules through Web, and send the resulting application code
to the publisher for an activation code. The activation binds the installation
to one or two module IMEIs.

The signed installation credential carries read-only repository access. Module
activation is issued separately after initialization. Keep the credential private.
Temporary credentials are removed on exit.
