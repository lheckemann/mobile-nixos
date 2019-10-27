{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkOrder optionalString;
  inherit (import ./initrd-order.nix) BEFORE_DEVICE_INIT;

  withSplash = config.mobile.boot.stage-1.splash.enable;

in
{
  config.mobile.boot.stage-1.init = mkOrder BEFORE_DEVICE_INIT ''
    # color: An hexadecimal color FF0000 being red.
    #        The display will be cleared with that color.
    # code: A user-friendly short and unique code, only logged as a prefix for now.
    #       The code will be displayed on the screen in the future.
    # message: A longer user-friendly message. It will be logged to the console.
    #          It might be shown, smaller, on the display in the future.
    init_fail() {
      color="$1"; shift
      code="$1"; shift
      message="$1"; shift
      ${optionalString withSplash ''
      ply-image --clear=0x"$color" /sad-phone.png
      >&2 echo "$code: $message"
      ''}
      # FIXME: option for rebooting
      >&2 echo "[Rebooting in 10 seconds]"
      sleep 10
      >&2 echo "$code: $message"
      hard-reboot

      exit 1
    }
  '';
  config.mobile.boot.stage-1.contents = mkIf withSplash [
      {
        object = (builtins.path { path = ../artwork/sad-phone.png; });
        symlink = "/sad-phone.png";
      }
  ];
}
