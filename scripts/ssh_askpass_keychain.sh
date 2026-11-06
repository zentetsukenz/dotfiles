#!/usr/bin/env bash
# scripts/ssh_askpass_keychain.sh
# SSH_ASKPASS for the ssh-agent LaunchAgent: answers ssh-add's "Enter passphrase for <key>:" from the
# login Keychain item "ssh:<key file name>". No item, no answer: that key stays out of the agent.
key=$(printf '%s' "${1:-}" | sed -n 's/^Enter passphrase for \(.*\): *$/\1/p')
[ -n "$key" ] || exit 1
exec security find-generic-password -a "$USER" -s "ssh:$(basename "$key")" -w
