{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "andrew"
      "plugdev"
      "docker"
      "wheel"
      "video"
      "audio"
      "cdrom"
      "dialout"
      "networkmanager"
      "libvirtd"
      "gamemode"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tmux
      vim
      git
      wget
      curl
      rsync
      screen
    ];
  };

  users.groups.andrew.gid = 1000;
}
