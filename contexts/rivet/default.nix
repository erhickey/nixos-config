{ hostname, pkgs, user, ... }:
{
  environment.systemPackages = with pkgs; [
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
    172.12.1.0 ${hostname}
    169.254.169.254 ${hostname}
  '';

  modules.mail = {
    enable = true;
  };

  modules.gnupg.enable = true;

  modules.polybar = {
    enable = true;

    layout = ''
      modules-left = menu
      modules-right = mail audio wlan battery date
    '';

    modules.mail = {
      enable = true;
    };
  };

  environment = {
    sessionVariables = {
      DATABASE_URL = "postgresql://rivet@rivet";
    };
    shellAliases = {
      sql = "vi \"$HOME\"/tmp/rivet.sql";
    };
  };

  # POST INSTALL NOTES
  # after cloning the rivet repo run:
  #   git lfs install
  #   git lfs pull

  # when creating the main container in the rivet repo, rivet/bin/main
  # will error out when it tries to create a group that already exists
  # either comment out the groupadd command before creating the container
  # or after creating the container, open a shell in the running container
  #   docker exec -it main bash
  # then run the useradd and chmod commands from the end of rivet/bin/main

  # create commit hook
  #   #!/usr/bin/env bash
  #   set -eo pipefail
  #   npx prettier --check $(git diff main --name-only --diff-filter=d -- '*.ts' '*.html')
  #   node node_modules/eslint/bin/eslint.js $(git diff main --name-only --diff-filter=d -- '*.ts')

  # create user.bazelrc
  #   build --config=dev --define debug=true

  # install angular language server
  #   npm install -g @angular/language-server@14
}
