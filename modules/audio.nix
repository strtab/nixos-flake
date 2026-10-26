{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        # Do not tear down BlueZ devices when the logind seat becomes inactive
        "51-bluez-no-seat" = {
          "wireplumber.profiles" = {
            main."monitor.bluez.seat-monitoring" = "disabled";
          };
        };
      };
    };
  };
  # Enable GStreamer and the PipeWire/PulseAudio sink plugins system-wide
  environment.systemPackages = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];
}
