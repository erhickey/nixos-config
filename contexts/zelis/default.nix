{ pkgs, pkgs-unstable, user, ... }:
{
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";
  # crt files are in gitignore, but we can make sure the file
  # is copied to the nix store by running the following command:
  #   git add -fN contexts/zelis/zelis_tls_root_g1.cer
  # remove intent to add flag with the following command:
  #   git reset -- contexts/zelis/zelis_tls_root_g1.cer
  security.pki.certificates = [ (builtins.readFile ./zelis_tls_root_g1_b64.cer) ];

  environment.systemPackages = with pkgs; [
    pkgs-unstable.claude-code
    git-lfs
    postgresql
  ];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];

  wsl.wslConf.network.generateHosts = false;
  networking.extraHosts = ''
    0.0.0.0 rivet
  '';

  environment = {
    sessionVariables = {
      DATABASE_URL = "postgresql://rivet@rivet";
    };
    shellAliases = {
      sql = "vi \"$HOME\"/tmp/rivet.sql";
    };
  };

  # PRE INSTALL NOTES

  # create .wslconfig in windows user home:
  #   [wsl2]
  #   networkingMode=mirrored

  # export zelis tls root g1 cert from trusted root certification authorities
  # in Base-64 encoded X.509 format

  # enable experimental in docker desktop

  # POST INSTALL NOTES

  # install angular language server
  #   npm install -g @angular/language-server@<version#>

  # add ~/.claude/settings.json
  # {
  #   "env": {
  #     "CLAUDE_CODE_USE_BEDROCK": "true",
  #     "AWS_REGION": "us-west-2",
  #     "AWS_PROFILE": "rivet-dev",
  #     "DISABLE_TELEMETRY": "1",
  #     "DISABLE_BUG_COMMAND": "1",
  #     "DISABLE_ERROR_REPORTING": "1"
  #   }
  # }

  # follow instructions on Notion ODev Setup page

  # add .ssh/config for multi ssh key support:
  #   Host github-rivet.com
  #   HostName github.com
  #   IdentityFile ~/.ssh/PRIVATE_KEY
  #   User git
  #   IdentitiesOnly yes

  # after cloning the rivet repo run:
  #   git lfs install
  #   git lfs pull

  # create commit hook
  #   #!/usr/bin/env bash
  #   set -eo pipefail
  #   npx prettier --check $(git diff main --name-only --diff-filter=d -- '*.ts' '*.html')
  #   node node_modules/eslint/bin/eslint.js $(git diff main --name-only --diff-filter=d -- '*.ts')

  # create user.bazelrc
  #   build --config=dev --define debug=true

  # download full_backup.tar.gz from rivethealth-db-backups s3 bucket on rivet-dev profile
  # extract contents of tar
  #   cp -r db ~/repositories/rivet/db/data
  #   cp -r router-db ~/repositories/rivet/router-db/data
  # might be better off skipping copy of es data and creating new indices if the backup is not recent
  #   cp -r es ~/repositories/rivet/es/data

  # start nix-shell w/postgresql version 14:
  #   nix-shell -p postgresql_14 -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/c0b19bb72884b9fcdb42f52c20c006ca84c283c5.tar.gz
  # extract db-data.tar.xz to rivet/db
  # reset the transaction log:
  #   pg_resetwal -f db/data

  # when creating the main container in the rivet repo, rivet/bin/main
  # will error out when it tries to create a group that already exists
  # either comment out the groupadd command before creating the container
  # or after creating the container, open a shell in the running container
  #   docker exec -it main bash
  # then run the useradd and chmod commands from the end of rivet/bin/main
  # may also need to fix the ownership on some directories:
  #   chown -R rivet:users /home/USER/.cache/*
  #   chown -R rivet:users /home/USER/repositories/rivet.out/*
}
