#!/usr/bin/env bash
set -euo pipefail
set +x
umask 077
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ ${EUID} -eq 0 ]] || fail 'Run as root.'
. /etc/os-release
[[ "$ID" == debian && "$VERSION_ID" =~ ^(12|13)$ && "$(uname -m)" == x86_64 ]] || fail 'Debian 12/13 amd64 required.'
read -r -s -p '请输入 D1 安装凭证（输入隐藏）：' credential </dev/tty || fail 'Interactive terminal required.'
printf '\n' >/dev/tty
[[ ${#credential} -gt 0 && ${#credential} -le 16384 ]] || fail 'Invalid credential size.'
tmp=$(mktemp -d /tmp/ec20-delivery.XXXXXXXX)
trap 'rm -rf -- "$tmp"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
printf '%s' "$credential" >"$tmp/credential"
unset credential
echo '准备安装依赖并校验下载凭证...'
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3-cryptography git openssh-client
python3 - "$tmp" <<'PY'
import base64, json, sys, uuid
from pathlib import Path
from cryptography.hazmat.primitives import serialization
folder = Path(sys.argv[1])
def require(condition):
    if not condition:
        raise ValueError('Credential does not match this installation entry')
kind, raw, signature = (folder/'credential').read_text().split('.')
decode = lambda value: base64.urlsafe_b64decode(value + '=' * (-len(value) % 4))
require(kind == 'D1')
payload = decode(raw)
key = serialization.load_pem_public_key('-----BEGIN PUBLIC KEY-----\nMCowBQYDK2VwAyEAUP38W/TPKWv+xzg64ZzPP7nN2DiWaUV1aevGfWRh2MI=\n-----END PUBLIC KEY-----\n'.encode())
key.verify(decode(signature), payload)
value = json.loads(payload)
require(json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode() == payload)
require(set(value) == {'v','purpose','cid','repo','ssh'} and type(value['v']) is int and value['v'] == 1 and value['purpose'] == 'download')
require(value['repo'] == 'XiaGuanCheShen/ec20-gateway-delivery')
require(str(uuid.UUID(value['cid'])) == value['cid'])
ssh = serialization.load_ssh_private_key(value['ssh'].encode(), password=None)
require(ssh.__class__.__name__ == 'Ed25519PrivateKey')
(folder/'identity').write_text(value['ssh'])
PY
printf '%s\n' '[ssh.github.com]:443 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' >"$tmp/known_hosts"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0
export GIT_SSH_COMMAND="ssh -F /dev/null -i $tmp/identity -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=yes -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=$tmp/known_hosts"
echo '下载已固定版本的交付程序...'
git -c core.hooksPath=/dev/null clone --quiet --depth 1 --single-branch --branch v2.1.11 \
    ssh://git@ssh.github.com:443/XiaGuanCheShen/ec20-gateway-delivery.git "$tmp/repo"
[[ "$(git -C "$tmp/repo" rev-parse HEAD)" == c6aa3a7d60ee30bf6ab379fe9a1afdcf8382a439 ]] || fail 'Delivery commit changed; obtain a new command.'
python3 - "$tmp/repo/license-keys.json" <<'PY'
import json, sys
from pathlib import Path
if json.loads(Path(sys.argv[1]).read_text()) != {'sign': '-----BEGIN PUBLIC KEY-----\nMCowBQYDK2VwAyEAUP38W/TPKWv+xzg64ZzPP7nN2DiWaUV1aevGfWRh2MI=\n-----END PUBLIC KEY-----\n', 'request': '-----BEGIN PUBLIC KEY-----\nMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAq7ToXJjnX2E7v4BJuVCk\nNzXKXbOzs/xm5kF9mxhhyZuqlvLzf6TGs8NnJc1JvH+pi2OZ1aTFuNOVsEa2ZhwG\nR+hHwFuN32B33oW1WmIhstEjDdIeGnDPjfyQp7Ar/IxLKu43OaJlEAhd7P1jK3Lm\nHPGBJfzBakL9aLcZkkHbsiY6wr+UwggWvkDWcqb76O6uXpW7BB98T0dnSVhddWv+\nGKptoW3U5mLIlPHRzYZSyot8xQeC1mfdSf37fdoW6KabTzjUDokge0f3fKltDMxn\nwiQdPATO7OqkccXwAByfm2CkwtUCKdwGNfEUy0LKj7uBcEeY0hodHtTFZQ2d9PQ+\nGogWh7ODB2mtvAIMRc4Z2ZP/olHM/pagbTNBa2AvCxbBpkyZsUs+0A9l5UTU3Pc/\nxHYZ5KO7YmZsg3OSAVNzMn0k/D3S4WlkTIM2IIBQJsoiqv8l/2qbVGb6oujIeUET\nxUlbaieg2aj3bFtrQT36AmnYu3z4nHwiXYodBXYSpZo7AgMBAAE=\n-----END PUBLIC KEY-----\n'}:
    raise ValueError('Delivery authorization keys do not match the entry')
PY
EC20_INSTALL_CREDENTIAL="$tmp/credential" EC20_INSTALL_IDENTITY="$tmp/identity" \
    EC20_INSTALL_KNOWN_HOSTS="$tmp/known_hosts" bash "$tmp/repo/scripts/customer-install.sh" </dev/tty
