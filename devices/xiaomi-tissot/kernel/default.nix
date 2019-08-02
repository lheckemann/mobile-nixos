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
})
