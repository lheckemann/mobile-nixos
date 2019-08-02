{ config, lib, pkgs, ... }:
let
  inherit (config.mobile.device) name;
in {
  mobile.device.name = "xiaomi-tissot";
  mobile.device.info = (lib.importJSON ../postmarketOS-devices.json).${name} // rec {
    kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
    dtb = "${kernel}/dtbs/${name}.img";
  };
  mobile.hardware = {
    soc = "qualcomm-msm8953";
    ram = 1024 * 4;
    screen = {
      width = 1080; height = 1920;
    };
  };

  mobile.system.type = "android-bootimg";
}
