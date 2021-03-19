{ config, ... }:

# Simple NixOS Mailserver configuration

let
  domains = [ "fufexan.xyz" ];
  fqdn = "mail.fufexan.xyz";
in {
  mailserver = {
    enable = true;
    fqdn = fqdn;
    domains = domains;

    loginAccounts = {
      "me@fufexan.xyz" = {
        hashedPasswordFile = config.age.secrets.mailPass.path;

        aliases = [
          "mihai@fufexan.xyz"
        ];

        catchAll = domains;
      };
    };
    certificateScheme = 3;

    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    enableManageSieve = true;

    # for machines with more than 1G RAM
    virusScanning = true;
  };
}
