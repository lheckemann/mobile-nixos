{ mobile-nixos
, fetchFromGitHub
, kernelPatches ? []
, dtbTool
}:

(mobile-nixos.kernel-builder-gcc6 {
  version = "3.18.71";
  configfile = ./config;
  dtb = "unknown";
  file = "Image.gz-dtb";
  src = fetchFromGitHub {
    owner = "lineageos";
    repo = "android_kernel_xiaomi_msm8953";
    rev = "80cb3f607eb78280642c3b9b6e89f676e9c263bf";
    sha256 = "13p326acpyqvlh5524bvy2qkgzgyhwxgy0smlwmcdl6y7yi04rg5";
  };
  isModular = false;
}).overrideAttrs ({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" "Image.gz-dtb" "install" ];
  postInstall = postInstall + ''
    # FIXME : find proper make invocation.
    cp arch/arm64/boot/Image.gz-dtb $out/
    #set -x
    # Generate master DTB (deviceinfo_bootimg_qcdt)
    echo "Generating master DTB"
    ${dtbTool}/bin/dtbTool -s 2048 -p "scripts/dtc/" -o "arch/arm64/boot/dt.img" "$out/dtbs/qcom/"

    mkdir -p "$out/boot"
    cp "arch/arm64/boot/dt.img" \
             "$out/boot/dt.img"

    # Copies the dtb, could always be useful.
    (
    mkdir -p $out/dtb
    for prefix in / /qcom; do
      for f in arch/*/boot/dts/$prefix/*.dtb; do
        cp -v "$f" $out/dtb/$prefix
      done
    done
    )
  '';
})
