#!/usr/bin/env bash
# Public bootstrap only. Customer credentials and gateway code stay private.
set -euo pipefail
set +x
umask 077

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ ${EUID} -eq 0 ]] || fail 'Run as root.'
. /etc/os-release
[[ "$ID" == debian && "$VERSION_ID" =~ ^(12|13)$ && "$(uname -m)" == x86_64 ]] \
    || fail 'Debian 12/13 amd64 required.'

read -r -s -p '请输入交付凭据（输入隐藏）：' credential </dev/tty \
    || fail 'An interactive terminal and delivery credential are required.'
printf '\n' >/dev/tty
[[ ${#credential} -gt 0 && ${#credential} -le 4096 && "$credential" =~ ^[A-Za-z0-9+/=]+$ ]] \
    || fail 'Invalid delivery credential.'

tmp=$(mktemp -d /tmp/ec20-delivery.XXXXXXXX)
trap 'rm -rf -- "$tmp"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
printf '%s' "$credential" | base64 -d >"$tmp/identity" || fail 'Invalid delivery credential.'
unset credential
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git openssh-client
ssh-keygen -y -P '' -f "$tmp/identity" >/dev/null || fail 'Invalid delivery key.'
printf '%s\n' '[ssh.github.com]:443 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' >"$tmp/known_hosts"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0
export GIT_SSH_COMMAND="ssh -F /dev/null -i $tmp/identity -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=yes -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=$tmp/known_hosts"
git -c core.hooksPath=/dev/null clone --quiet --depth 1 --single-branch --branch v2.0.10 \
    ssh://git@ssh.github.com:443/XiaGuanCheShen/ec20-gateway-delivery.git "$tmp/repo"
[[ "$(git -C "$tmp/repo" rev-parse HEAD)" == a3ab3daf5a9280febf6c69023375e532f3bf91c2 ]] \
    || fail 'Delivery version changed; obtain a new install command.'
EC20_INSTALL_IDENTITY="$tmp/identity" EC20_INSTALL_KNOWN_HOSTS="$tmp/known_hosts" \
    bash "$tmp/repo/scripts/customer-install.sh" </dev/tty
