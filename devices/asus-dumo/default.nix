{ config, lib, pkgs, ... }:

{
  mobile.device.name = "asus-dumo";
  mobile.device.info = rec {
    format_version = "0";
    name = "ASUS Chromebook Tablet CT100PA";
    manufacturer = "ASUS";
    arch = "aarch64";
    keyboard = false;
    external_storage = true;
    # Serial console on ttyS2, using a suzyqable or equivalent.
    kernel_cmdline = "console=ttyS2,115200n8 earlyprintk=ttyS2,115200n8 loglevel=8 vt.global_cursor_default";
    # TODO : move kernel outside of the basic device details
    kernel = pkgs.callPackage ./kernel {};
    # This could be further pared down to only the required dtb files.
    dtbs = "${kernel}/dtbs/rockchip";
  };
  mobile.hardware = {
    soc = "rockchip-op1";
    ram = 1024 * 4;
    screen = {
      width = 1536; height = 2048;
    };
  };

  mobile.system.type = "depthcharge";

  # FIXME: into a common gru base platform?
  # FIXME: also add to stage-2 somehow.
  mobile.boot.stage-1.contents = [
    {
      object = let dptx = pkgs.runCommandNoCC "dptx.bin" {} ''
        cp "${pkgs.firmwareLinuxNonfree}/lib/firmware/rockchip/dptx.bin" $out
      ''; in "${dptx}";
      symlink = "/lib/firmware/rockchip/dptx.bin";
    }
    {
      object = let hw3 = pkgs.runCommandNoCC "ath10k-QCA6174-hw3.0" {} ''
        cp -prf "${pkgs.firmwareLinuxNonfree}/lib/firmware/ath10k/QCA6174/hw3.0" $out
      ''; in "${hw3}";
      symlink = "/lib/firmware/ath10k/QCA6174/hw3.0";
    }
    {
      object = let rampatch = pkgs.runCommandNoCC "rampatch_usb_00000302.bin" {} ''
        cp -prf "${pkgs.firmwareLinuxNonfree}/lib/firmware/qca/rampatch_usb_00000302.bin" $out
      ''; in "${rampatch}";
      symlink = "/lib/firmware/qca/rampatch_usb_00000302.bin";
    }
  ];
  # There no rndis gadget configured yet for the gru platform.
  mobile.boot.stage-1.networking.enable = false;
}
