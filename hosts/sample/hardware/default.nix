{
  imports = [
    ./gpu.nix
    ../../../mods/hardware/i2c.nix
    ../../../mods/hardware/audio.nix
    ../../../mods/hardware/bluetooth.nix
  ];

  hardware = {
    ksm.enable = true; # kernel same-page merging.
  };
}
