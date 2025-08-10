{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg
    makemkv
    mkvtoolnix
    handbrake
    libdvdcss
    dvdbackup
    ffmpeg-full
  ];
}
