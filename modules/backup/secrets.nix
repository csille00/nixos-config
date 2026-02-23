{ config, ... }:

{
  age.secrets = {
    borgbase-ssh-key = {
      file = ../../secrets/borgbase-ssh-key.age;
      mode = "0400";
      owner = "root";
    };
    borg-passphrase = {
      file = ../../secrets/borg-passphrase.age;
      mode = "0400";
      owner = "root";
    };
  };
}
