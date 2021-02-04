{ config, pkgs, ... }:

{
  imports =
    [
      # the default for the machine
      /etc/nixos/hardware-configuration.nix

      # bootloader config
      ./bootloader.nix

      # fonts
      ./fonts.nix

      # neovim configuration
      ./neovim.nix

      # networking
      ./network.nix

      # in case you want low latency on your Pulseaudio setup
      # mostly applicable to producers and osu! players
      # NOTE: not needed anymore if you use PipeWire
      ./pulse.nix

      # packages to install system-wide
      ./packages.nix
      
      # service configration
      ./services.nix

      # configure shells and console
      ./shell.nix

      # user accounts
      ./users.nix

      # in case you use Xorg
      ./xorg.nix
    ];

  # enable tmpfs
  boot.tmpOnTmpfs = true;

  # timezone
  time.timeZone = "Europe/Bucharest";

  # internationalisation
  i18n.defaultLocale = "ro_RO.UTF-8";

  # IBus IME
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = [ pkgs.ibus-engines.anthy ];
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # support hardware accelerated encoding/decoding
    extraPackages = with pkgs; [
      vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel libvdpau-va-gl vaapiVdpau
    ];
  };

  # update Intel ucode
  hardware.cpu.intel.updateMicrocode = true;

  #
  # kernel
  #

  # kernel to use
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];

  # make modules available to modprobe
  boot.extraModulePackages = [ pkgs.linuxPackages_zen.v4l2loopback ];

  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  # auto optiomise the nix store
  nix.optimise.automatic = true;

  # enable sound throuth PipeWire
  #services.pipewire = {
  #  enable = true;
  #  socketActivation = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  jack.enable = true;
  #  pulse.enable = true;
  #};

  # enable realtime capabilities to user processes
  security.rtkit.enable = true;

  # allow users in `wheel` to use doas without prompting for password
  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
    # keep environment when running as root
    extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
    }];
  };

  # disable sudo
  security.sudo.enable = false;

  # system version
  system.stateVersion = "20.09";

  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;

  # enable libvirt
  virtualisation.libvirtd.enable = true;
}
