{ pkgs, ... }:

{
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  musnix.enable = true;
  musnix.soundcardPciId = "0b:00.1";
  musnix.kernel.realtime = true;
  musnix.rtirq.enable = true;
}
