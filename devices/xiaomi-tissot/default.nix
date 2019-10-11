{ config, lib, pkgs, ... }:
let
  inherit (config.mobile.device) name;
  originalKernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
in {
  mobile.device.name = "xiaomi-tissot";
  mobile.device.info = (lib.importJSON ../postmarketOS-devices.json).${name} // rec {
    kernel = originalKernel // pkgs.runCommandNoCC originalKernel.name {} ''
      k=${originalKernel}
      cp -r $k $out
      chmod +w $out
      rm $out/Image
      cat $k/Image $k/dtb/msm8953-qrd-sku3-tissot.dtb > $out/Image
    '';
    dtb = "${kernel}/dtbs/msm8953-qrd-sku3-tissot.dtb";
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
