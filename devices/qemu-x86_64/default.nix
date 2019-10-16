{ config, lib, pkgs, ... }:

with import ../../modules/initrd-order.nix;
let
  # This device description is a bit configurable through
  # mobile options...

  # Enabling the splash changes some settings.
  splash = config.mobile.boot.stage-1.splash.enable;

  kernel = pkgs.linuxPackages_4_19.kernel;
  device_info = (lib.importJSON ../postmarketOS-devices.json).qemu-amd64;

  modules = [
    # Disk images
    "ata_piix"
    "sd_mod"

    # Networking
    "e1000"

    # Keyboard
    "hid_generic"
    "pcips2" "atkbd" "i8042"

    # x86 RTC needed by the stage 2 init script.
    "rtc_cmos"
  ];

  MODES = {
      "800x600x16" = { vga =   "788"; width =  800; height =  600; depth = 16; };
     "1024x786x16" = { vga =   "791"; width = 1024; height =  768; depth = 16; };
     "1024x786x32" = { vga = "0x344"; width = 1024; height =  768; depth = 32; };
    "1280x1024x16" = { vga =   "794"; width = 1280; height = 1024; depth = 16; };
     "1280x720x16" = { vga = "0x38d"; width = 1280; height =  720; depth = 16; };
     "1280x720x24" = { vga = "0x38e"; width = 1280; height =  720; depth = 24; };
     "1280x720x32" = { vga = "0x38f"; width = 1280; height =  720; depth = 32; };
    "1920x1080x16" = { vga = "0x390"; width = 1920; height = 1080; depth = 16; };
    "1920x1080x24" = { vga = "0x391"; width = 1920; height = 1080; depth = 24; };
    "1920x1080x32" = { vga = "0x392"; width = 1920; height = 1080; depth = 32; };
     "720x1280x32" = { vga = "0x393"; width =  720; height = 1280; depth = 32; };
    "1080x1920x32" = { vga = "0x394"; width = 1080; height = 1920; depth = 32; };
  };

  MODE = MODES."1080x1920x32";
in
{
  mobile.device.name = "qemu-x86_64";
  mobile.device.info = device_info // {
    # TODO : make kernel part of options.
    inherit kernel;
    kernel_cmdline = device_info.kernel_cmdline
    + " vga=${MODE.vga}" 
    # TODO : make cmdline configurable outside device.info (device.info would be used for device-specifics only)
    + lib.optionalString splash " quiet vt.global_cursor_default=0"
    ;
  };
  mobile.hardware = {
    soc = "generic-x86_64";
    screen = {
      inherit (MODE) height width;
    };
    ram = 512;
  };

  mobile.system.type = "kernel-initrd";
  mobile.boot.stage-1 = {
    redirect-log.targets = lib.mkIf (splash != true) [ "/dev/tty0" ];
    init = (lib.mkOrder BEFORE_READY_INIT ''
      echo "cmdline:"
      cat /proc/cmdline
      echo "Hi there from /init!"
    '');
    kernel = {
      modular = true;
      inherit modules;
    };
  };
}
