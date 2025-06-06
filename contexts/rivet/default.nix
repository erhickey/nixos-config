{ pkgs, pkgs-unstable, user, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs-unstable.claude-code
    git-lfs
    postgresql
  ];

  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      experimental = true;
    };
  };

  users.users.${user}.extraGroups = [ "docker" ];

  networking.extraHosts = ''
    172.12.1.0 rivet
  '';

  modules.dunst.enable = true;
  modules.pycal.enable = true;

  modules.drivestrike.enable = true;

  services.getty.autologinUser = "${user}";

  environment = {
    sessionVariables = {
      DATABASE_URL = "postgresql://rivet@rivet";
    };
    shellAliases = {
      sql = "vi \"$HOME\"/tmp/rivet.sql";
    };
  };

  # POST INSTALL NOTES

  # install angular language server
  #   npm install -g @angular/language-server@14

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

  # extract db-data.tar.xz to rivet/db
  # reset the transaction log:
  #   pg_resetwal -f db/data

  # import vpn connection:
  #   nmcli connection import type openvpn file <OVPN_FILE>
  # make sure the connection is only used for resources on its network:
  #   nmcli connection modify <CONN_NAME> ipv4.never-default true
  #   nmcli connection modify <CONN_NAME> ipv6.never-default true

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
