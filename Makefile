# Based on Mitchell's config here https://github.com/mitchellh/nixos-config/blob/main/Makefile

UNAME := $(shell uname)
NIXNAME := $(shell hostname)

switch:
ifeq ($(UNAME), Darwin)
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes ".#darwinConfigurations.${NIXNAME}.system"
	./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#${NIXNAME}"
else ifeq ($(UNAME), Linux)
	if [ -f /etc/NIXOS ]; then \
		sudo nixos-rebuild switch --flake ".#${NIXNAME}"; \
	else \
		home-manager switch --flake ".#${NIXNAME}"; \
	fi
else
	echo "uknown system ${UNAME}"
	exit 1
endif

test:
ifeq ($(UNAME), Darwin)
	nix build ".#darwinConfigurations.${NIXNAME}.system"
	./result/sw/bin/darwin-rebuild test --flake "$$(pwd)#${NIXNAME}"
else
	sudo nixos-rebuild test --flake ".#$(NIXNAME)" --show-trace
endif

build-live:
	nixos-generate -f iso -c ./nixos/ajwlive/configuration.nix -o ajwliveiso
