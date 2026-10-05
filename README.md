# EC20 Customer Bootstrap

Public installer entry only. This repository contains no gateway source,
customer credentials, private keys, or customer data.

The publisher supplies a short command pinned to an immutable bootstrap commit
and a separate, private delivery credential. Run the command in an interactive
terminal on Debian 12/13 amd64, enter the root password when prompted, then
paste the credential into the hidden prompt.

The bootstrap clones a fixed version of the private delivery repository,
checks its commit, and starts the existing installation wizard. It does not
initialize modules. Customers scan and initialize modules through Web later.

The delivery credential is a read-only deploy key, not a license or DRM.
Do not publish or forward it. Temporary credentials are removed on exit.
