{ config, pkgs, ... }: {

  # Mouse&keyborad and timeezone

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

   # Configure keyboard layout
  services.xserver = {
    enable = true;
    xkb.layout = "in";
    xkb.variant = "eng";
    videoDrivers = ["nvidia"];  # Use NVIDIA drivers
  };

 # Enable libinput for touchpad/mouse support
  services.libinput.enable = true;  

}