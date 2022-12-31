{ inputs, lib, config, pkgs, ... }:

{
  hardware.nvidia.powerManagement.enable = true;

  boot.blacklistedKernelModules = [ "nouveau" ];
  # environment.variables.__NV_PRIME_RENDER_OFFLOAD = "1";
  # environment.variables.__NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
  # environment.variables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # environment.variables.__VK_LAYER_NV_optimus = "NVIDIA_only";
  # # services.xserver.videoDrivers = [ "nvidia" ];

  # services.xserver.videoDrivers = [ "nvidia" ];
  # environment.variables = {
  #   VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  # };
  #
  # hardware.opengl.extraPackages = with pkgs; [
  #   vaapiIntel
  #   libvdpau-va-gl
  #   intel-media-driver
  # ];

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.prime = {
    #   # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
    #
    #   # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:3:0:0";
  };

}
