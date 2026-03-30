#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ rake ])"

# Based on Mitchell's config here https://github.com/mitchellh/nixos-config/blob/main/Makefile

require 'rake'

UNAME = `uname`.strip
NIXNAME = `hostname`.strip

desc "Switch to the new configuration. Examples: rake switch / rake switch REMOTE=glados01 / rake switch REMOTE=glados01 TARGET=192.168.15.10"
task :switch do
  remote = ENV["REMOTE"]
  host = remote || NIXNAME
  target = ENV["TARGET"] || remote

  if ENV["FORCE"] == "1"
    rm_f [File.expand_path("~/.ssh/config.bak"), File.expand_path("~/.gitconfig.bak")]
  end

  if target
    sh "nixos-rebuild switch --flake \".##{host}\" --target-host #{target} --build-host localhost --sudo --ask-sudo-password"
  else
    sh "./hack/confpatch save" if host == "work"
    sh "#{nix_command} switch --flake \".##{host}\""
    sh "./hack/confpatch apply" if host == "work"
  end
end

desc "Test the configuration. Examples: rake test / rake test REMOTE=glados01 / rake test REMOTE=glados01 TARGET=192.168.15.10"
task :test do
  remote = ENV["REMOTE"]
  host = remote || NIXNAME
  target = ENV["TARGET"] || remote

  if target
    sh "nixos-rebuild test --flake \".##{host}\" --target-host #{target} --build-host localhost --sudo --ask-sudo-password"
  else
    case UNAME
    when "Darwin"
      sh "nix build \".#darwinConfigurations.#{host}.system\""
      sh "./result/sw/bin/#{nix_command(false)} test --flake \".##{host}\""
    else
      sh "#{nix_command} test --flake \".##{host}\" --show-trace"
    end
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
  sh "stylua --check **/*.lua"
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
