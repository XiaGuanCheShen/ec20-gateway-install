# EC20 3.0.9 Customer Bootstrap

Public installer entry only. No gateway source, customer credentials, private
keys or customer data is stored in this repository.

Use [installation-command.txt](installation-command.txt) for the current pinned,
ASCII-only installation command on Debian 12/13 amd64. Enter the root password,
then paste the separate signed D1 installation credential into the hidden prompt.
The command itself contains no private credential and may be shared publicly;
the D1 credential must remain private.

The bootstrap verifies the publisher signature and fetches private delivery tag
`v3.0.9`, commit `994bbc1d7b010a07148a9375690d5810ab6df61c`. It checks the pinned commit and
authorization public keys before starting the installation wizard. Existing D1
credentials from the same publisher remain valid. Module activation is separate:
read the usage notice, scan and initialize modules in Web, and obtain an
installation/module-bound activation code from the publisher.

## This Release

- Start status snapshots automatically after timer activation, including delayed
  startup; report an unavailable PBX without starting it from the collector.
- Prevent an earlier serial wait from falsely timing out a newly sent keypad
  command and disconnecting an active call.
- Disable receive-side audio DTMF recognition to avoid the implicated long-call
  voice suppression path. Phone keypad sending remains enabled.
- Preserve previous ringback, radio status, managed-driver provenance, DHCP-safe
  Web access and optional Cloudflare support. No new transport behavior is added.

## Existing Installations

Back up and finish calls, then update through Web Software Maintenance. Wait for
program, dependency and driver tasks to finish. Driver activation may briefly
restart Asterisk; do not initialize a working module again. Authorization,
pairing and release trust are unchanged. Custom driver/configuration safety
checks remain enforced. Publishing this entry does not update running gateways.

Older commands pinned to an earlier immutable commit still install that earlier
release. Use the current command above for 3.0.9. Live carrier, firmware and
network acceptance remain separate from software regression.
