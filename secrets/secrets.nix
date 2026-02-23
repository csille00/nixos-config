let
  # Host SSH public keys (for runtime decryption)
  ellis-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII44SUTzYYJ7de1rHLxm++m/ZB8in/g4tUS8hjQWKel0";

  # Add your personal public key here for editing secrets from your machine
  # connor = "ssh-ed25519 AAAA...";

  # All keys that can decrypt secrets
  allKeys = [ ellis-server ];
in
{
  "borgbase-ssh-key.age".publicKeys = allKeys;
  "borg-passphrase.age".publicKeys = allKeys;
}
