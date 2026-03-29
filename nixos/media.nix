{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    makemkv
    mkvtoolnix
    handbrake
    libdvdcss
    dvdbackup
  ];
}
