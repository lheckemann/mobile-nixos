{ mobile-nixos
, fetchFromGitHub
, kernelPatches ? []
}:

(mobile-nixos.kernel-builder-gcc6 {
  version = "3.18.71";
  configfile = ./config;
  src = fetchFromGitHub {
    owner = "lineageos";
    repo = "android_kernel_xiaomi_msm8953";
    rev = "80cb3f607eb78280642c3b9b6e89f676e9c263bf";
    sha256 = "13p326acpyqvlh5524bvy2qkgzgyhwxgy0smlwmcdl6y7yi04rg5";
  };
  isModular = false;
}).overrideAttrs ({ postInstall ? "", postPatch ? "", makeFlags ? [], ...}: {
  makeFlags = makeFlags ++ [ "dtbs" ];
  postInstall = postInstall + ''
    mkdir -p "$out/boot"
    for f in zImage-dtb Image.gz-dtb zImage Image.gz Image; do
      f=arch/arm/boot/$f
      [ -e "$f" ] || continue
      echo "zImage found: $f"
      cp -v "$f" "$out/"
      break
    done
    mkdir -p $out/dtb
    for f in arch/*/boot/dts/*/*.dtb; do
      cp -v "$f" $out/dtb/
    done
  '';
})
