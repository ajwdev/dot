#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ rake ])"

# Based on Mitchell's config here https://github.com/mitchellh/nixos-config/blob/main/Makefile

require "rake"

UNAME = `uname`.strip
NIXNAME = ENV["NIXNAME"] || `hostname`.strip

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
    sh "./hack/confpatch save" if confpatch_host?(host)
    sh "#{nix_command} switch --flake \".##{host}\""
    if confpatch_host?(host)
      sh "./hack/confpatch apply"
      sh "./hack/confpatch save"
    end
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

namespace :hm do
  desc "Switch home-manager configuration. Examples: rake hm:switch / rake hm:switch NIXNAME=bender"
  task :switch do
    host = ENV["NIXNAME"] || NIXNAME
    sh "home-manager switch --flake \".#andrew@#{host}\""
  end
end

desc "Build live ISO. ARCH=aarch64 for ARM (default: x86_64)"
task :build_live do
  arch = ENV["ARCH"]
  host = arch == "aarch64" ? "ajwlive-aarch64" : "ajwlive"
  sh "nix build '.#nixosConfigurations.#{host}.config.system.build.isoImage' --out-link ajwliveiso"
end

desc "Update flake inputs to the latest fully-cached nixos-unstable commit"
task :update do
  rev = `curl -sL https://channels.nixos.org/nixos-unstable/git-revision`.strip
  abort "Failed to fetch nixos-unstable revision" if rev.empty?
  puts "Pinning nixpkgs to nixos-unstable @ #{rev}"
  sh "nix flake update --override-input nixpkgs github:NixOS/nixpkgs/#{rev}"
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

def confpatch_host?(host)
  %w[work coder].include?(host)
end

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
