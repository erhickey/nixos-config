{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.mail;
in
{
  options = {
    modules.mail = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      user = mkOption {
        type = types.str;
        default = "";
      };

      mbsync.config = mkOption {
        type = types.lines;
        default = ''
          IMAPAccount gmail
          Host imap.gmail.com
          SSLType IMAPS
          AuthMechs LOGIN
          UserCmd "${pkgs.gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.gnupg/gu.gpg"
          PassCmd "${pkgs.gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/.gnupg/gp.gpg"

          IMAPStore gmail-remote
          Account gmail

          MaildirStore gmail-local
          SubFolders Verbatim
          Path ~/.mail/
          Inbox ~/.mail/

          Channel gmail
          Far :gmail-remote:
          Near :gmail-local:
          Patterns "INBOX" "[Gmail]/Spam" "[Gmail]/Trash"
          Create Both
          Expunge Both
          SyncState *
        '';
      };

      neomutt.config = mkOption {
        type = types.lines;
        default = ''
          set mbox_type=Maildir
          set folder=~/.mail
          set spoolfile=+/
          set header_cache=~/.cache/mutt
          set trash=~/.mail/[Gmail]/Trash

          # display/pager
          ignore *                                # ignore all headers
          unignore from: to: cc: date: subject:   # show only these
          hdr_order date: from: to: cc: subject:  # and in this order
          set date_format = "%m/%d/%y"
          set pager_format="%4C %Z %[!%b %e at %I:%M %p]  %.20n  %s%* -- (%P)"
          set text_flowed

          macro attach s <save-entry><bol>~/Downloads/<eol>
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        isync
        neomutt
      ];

      etc."xdg/neomutt/neomuttrc" = {
        text = cfg.neomutt.config;
        mode = "0444";
      };

      etc."xdg/mbsync/mbsyncrc" = {
        text = cfg.mbsync.config;
        mode = "0444";
      };

      etc."xdg/mail/sounds/notification.wav" = {
        source = ./sounds/notification.wav;
        mode = "0444";
      };
    };

    systemd.user = {
      timers."mail" = {
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnBootSec = "0m";
          OnCalendar = "*:*:00"; # every minute
          Unit = "mail.service";
        };
      };

      services."mail" = {
        script = ''
          set -eu
          [ -e "$HOME"/.mail ] || mkdir "$HOME"/.mail
          [ -e "$HOME"/.mail/new ] && old_new_count="$(ls -1 "$HOME"/.mail/new)"
          ${pkgs.isync}/bin/mbsync -a -c /etc/xdg/mbsync/mbsyncrc
          old_new_count="$(ls -1 "$HOME"/.mail/new)"
          if [ "''${new_new_count:-0}" -gt "$old_new_count" ] ; then
            ${pkgs.alsa-utils}/bin/aplay /etc/xdg/mail/sounds/notification.wav
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "${cfg.user}";
        };
      };
    };
  };
}
