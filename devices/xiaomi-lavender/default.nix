{ config, lib, pkgs, ... }:

{
  mobile.device.name = "xiaomi-lavender";
  mobile.device.info = rec {
    name = "Xiaomi Redmi Note 7";
    # TODO : make kernel part of options.
    kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
    ##kernel_file = ./Image.gz-dtb;
    ##kernel = {};
    #dtb = "${kernel}/boot/dt.img";


    #kernel_cmdline = lib.concatStringsSep " " [
    #  "console=ttyMSM0,115200,n8"
    #  "androidboot.console=ttyMSM0"
    #  "earlycon=msm_serial_dm,0xc170000"
    #  "androidboot.hardware=qcom"
    #  "user_debug=31"
    #  "msm_rtb.filter=0x37"
    #  "ehci-hcd.park=3"
    #  "lpm_levels.sleep_disabled=1"
    #  "sched_enable_hmp=1"
    #  "sched_enable_power_aware=1"
    #  "service_locator.enable=1"
    #  "swiotlb=1"
    #  "firmware_class.path=/vendor/firmware_mnt/image"
    #  "loop.max_part=7"
    #  "androidboot.selinux=permissive"
    #  "buildvariant=userdebug"
    #];
    #flash_method = "fastboot";
    #generate_bootimg = true;
    #bootimg_qcdt = true;
    #flash_offset_base = "0x80000000";
    #flash_offset_kernel = "0x00008000";
    #flash_offset_ramdisk = "0x01000000";
    #flash_offset_second = "0x00f00000";
    #flash_offset_tags = "0x00000100";
    #flash_pagesize = "4096";


    format_version = "0";
    #name = "Xiaomi Redmi Note 7";
    manufacturer = "Xiaomi";
    codename = "xiaomi-lavender";
    date = "";
    dtb = "";
    modules_initfs = "";
    arch = "aarch64";
    keyboard = "false";
    external_storage = "true";
    screen_width = "1080";
    screen_height = "2340";
    dev_touchscreen = "";
    dev_touchscreen_calibration = "";
    dev_keyboard = "";
    flash_method = "fastboot";
    kernel_cmdline = lib.concatStringsSep " " [
      "console=ttyMSM0,115200,n8"
      "androidboot.console=ttyMSM0"
      "earlycon=msm_serial_dm,0xc170000"
      "androidboot.hardware=qcom"
      "user_debug=31"
      "msm_rtb.filter=0x37"
      "ehci-hcd.park=3"
      "lpm_levels.sleep_disabled=1"
      "sched_enable_hmp=1"
      "sched_enable_power_aware=1"
      "service_locator.enable=1"
      "swiotlb=1"
      "firmware_class.path=/vendor/firmware_mnt/image"
      "loop.max_part=7"
      "androidboot.selinux=permissive"
      "buildvariant=userdebug"

      # # ABL
      # # BootLinux.c~1140   if (AsciiStrStr (BootParamlistPtr.CmdLine, "root=")) {
      # # This disables adding `skip_initramfs`
      # "root="
    ];
    generate_bootimg = "true";
    bootimg_qcdt = false;
    flash_offset_base = "0x00000000";
    flash_offset_kernel = "0x00008000";
    flash_offset_ramdisk = "0x01000000";
    flash_offset_second = "0x00f00000";
    flash_offset_tags = "0x00000100";
    flash_pagesize = "4096";

  };
  mobile.hardware = {
    soc = "qualcomm-sdm660";
    # 4GB for the specific revision supported.
    # When this will be actually used, this may be dropped to 3, and/or
    # document all ram types as a list and work with min/max of those.
    ram = 1024 * 4;
    screen = {
      width = 1080; height = 2340;
    };
  };

  mobile.system.type = "android-bootimg";
}
