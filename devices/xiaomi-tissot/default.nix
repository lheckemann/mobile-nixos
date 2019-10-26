{ config, lib, pkgs, ... }:
let
  inherit (config.mobile.device) name;
  originalKernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
in {
  mobile.device.name = "xiaomi-tissot";
  mobile.device.info = (lib.importJSON ../postmarketOS-devices.json).${name} // {
    kernel = originalKernel;
    #dtb = "${kernel}/dtbs/msm8953-qrd-sku3-tissot.dtb";
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
