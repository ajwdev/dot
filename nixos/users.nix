{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Williams";
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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtiwx2PF6SRFaQD8MxWh9u/qiOgkfrbskl1JRMu6syUrrMsV81FrB7yGQyhGxjg0+Ks3KHqT1PiUOKxZtgbDBcEGcgdtuORo+cvvWJZkVgxWc4sw7laERmkRx9uPgDPdzYMLqR3R51JCU1D7TyCIyb3mE1G5DrEjlkJnfQrDZd7XmW7mijKLiqE7NuTsKQWbSaSvXjINkzmTOW/+YIDWglCbrdBBOjaeDww7LdrHFE4JBBYgdQq0oudl62h4bjeen9Xp1fSkHnHwPvgoqkW5lS6Xut3yV9xjpWzE49QS/R9ADOkhgALZQqmbUUn2lphlf1GaJfHWP+cA7urmXHbITnDl/5SJxkQuefLO7UQDKlhwxPVVhX7RM+qUM4tSnIk6CnWfvnvBF5YR6lFMLvqiNS6gUaqnxD4XmvsMgz66/Fd9ZvtpaFYCD8ZvwJLQU4/0QHJLzaUYe+PIvx+uLLYGNPWExMKMFTJtbwltyJ4+BwbGpkCliVfaFtS8MRpamxcjU= andrew@tomservo"
    ];
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
