#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ rake ])"

# Based on Mitchell's config here https://github.com/mitchellh/nixos-config/blob/main/Makefile

require 'rake'

UNAME = `uname`.strip
NIXNAME = `hostname`.strip

desc "Switch to the new configuration"
task :switch do
  if ENV["FORCE"] == "1"
    rm_f [File.expand_path("~/.ssh/config.bak"), File.expand_path("~/.gitconfig.bak")]
  end
  if NIXNAME == "work"
    sh "./hack/confpatch save"
  end
  sh "#{nix_command} switch --flake \".##{NIXNAME}\""
  if NIXNAME == "work"
    sh "./hack/confpatch apply"
  end
end

desc "Test the configuration"
task :test do
  case UNAME
  when "Darwin"
    sh "nix build \".#darwinConfigurations.#{NIXNAME}.system\""
    sh "./result/sw/bin/#{nix_command(false)} test --flake \".##{NIXNAME}\""
  else
    sh "#{nix_command} test --flake \".##{NIXNAME}\" --show-trace"
  end
end

desc "Build live ISO"
task :build_live do
  sh "nixos-generate -f iso -c ./nixos/ajwlive/configuration.nix -o ajwliveiso"
end

desc "Format code"
task :fmt do
  sh "treefmt"
end

desc "Check formatting without making changes"
task :check do
  sh "treefmt --fail-on-change"
end

task default: :check

def nix_command(use_sudo = true)
  sudo_wrap = lambda do |s|
    return s unless use_sudo

   "sudo #{s}"
  end

  case UNAME
  when "Darwin"
    sudo_wrap["darwin-rebuild"]
  when "Linux"
    if File.exist?("/etc/NIXOS")
      return sudo_wrap["nixos-rebuild"]
    end

    "home-manager"
  else
    puts "unknown system #{UNAME}"
    exit 1
  end
end
