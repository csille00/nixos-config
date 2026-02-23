let
  # Host SSH public keys (for runtime decryption)
  ellis-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII44SUTzYYJ7de1rHLxm++m/ZB8in/g4tUS8hjQWKel0";

  # Personal key for editing secrets
  connor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6QFH6eHplcAPQQgw21doDAULgHRCyKVllYn9fIGvvb";

  # All keys that can decrypt secrets
  allKeys = [ ellis-server connor ];
in
{
  "borgbase-ssh-key.age".publicKeys = allKeys;
  "borg-passphrase.age".publicKeys = allKeys;
}
