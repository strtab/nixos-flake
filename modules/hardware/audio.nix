# Audio configuration for NixOS using PipeWire
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
      # extraConfig = {
      #   "10-disable-camera" = {
      #     "wireplumber.profiles" = {
      #       main."monitor.libcamera" = "disabled";
      #     };
      #   };
      # };
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
