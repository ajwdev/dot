{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg
    unstable.makemkv
    mkvtoolnix
    handbrake
    libdvdcss
    dvdbackup
    unstable.ffmpeg-full
  ];
}
