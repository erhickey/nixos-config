{ config, lib, pkgs, ... }:
{
  system.stateVersion = "${config.nixos-version}";

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;

    excludePackages = with pkgs; [
      xorg.iceauth
      xterm
      pkgs.nixos-icons
    ];

    # keyboard settings
    layout = "us";
    xkbVariant = "";
    autoRepeatDelay = 250;
    autoRepeatInterval = 50;
  };

  networking.networkmanager.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${config.username} = {
    isNormalUser = true;
    extraGroups = [ "audio" "docker" "networkmanager" "video" "wheel" ];
    shell = pkgs.bash;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "LiberationMono" ]; })
  ];

  environment.systemPackages = with pkgs; [
    bat
    bc
    bottom
    dmenu
    fd
    feh
    firefox
    fzf
    ghc
    git
    glow
    gnupg
    google-chrome
    haskellPackages.haskell-language-server.out
    isync
    jq
    keepassxc
    maim
    neomutt
    neovim
    nodejs
    nodePackages.npm
    pavucontrol
    picom
    pinentry-curses       # gnupg dependency
    python3
    qutebrowser
    ripgrep
    sxiv
    tealdeer
    tmux
    tree
    vim
    vlc
    xmonad-with-packages
    zig                   # treesitter dependency
    (polybar.override { pulseSupport = true; })
    (st.overrideAttrs (oldAttrs: rec {
      # ligatures dependency
      # buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      patches = [
        # anysize patch (fix tiling wm sizing)
        (fetchpatch {
          url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
          sha256 = "yx9VSwmPACx3EN3CAdQkxeoJKJxQ6ziC9tpBcoWuWHc=";
        })
        # no bold (solarized colors dependency)
        (fetchpatch {
          url = "https://st.suckless.org/patches/solarized/st-no_bold_colors-20170623-b331da5.diff";
          sha256 = "iIGWeyvoPQ8CMQJiehCKvYhR0Oa1Cgqz/KFPU/NGxDk=";
        })
        # set COLORTERM env variable
        ../../config/st/truecolor.diff
      ];
      configFile = writeText "config.def.h" (builtins.readFile ../../config/st/config.def.h);
      postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    }))
  ];
}
