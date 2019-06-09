{ config, lib, pkgs, ... }:

{
  mobile.device.name = "oneplus-bacon";
  mobile.device.info = (lib.importJSON ../postmarketOS-devices.json).oneplus-bacon // rec {
    # TODO : make kernel part of options.
    kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
    dtb = "${kernel}/dtbs/oneplus-bacon.img";
  };
  mobile.hardware = {
    #soc = "qualcomm-apq8064-1aa";
    # Qualcomm Snapdragon 801 MSM8974PRO-AC r2p1
    soc = "qualcomm-msm8974";
    ram = 1024 * 3;
    screen = {
      width = 1080; height = 1920;
    };
  };

  mobile.system.type = "android-bootimg";
}
