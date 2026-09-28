# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "tcp_bbr3" ];
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr3";
    # kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };
  gtk.iconCache.enable = true;

  services = {
    xserver.xkb = {
      layout = "ru";
      variant = "";
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    # scx = {
    #   enable = true;
    #   scheduler = "scx_lavd";
    #   extraArgs = [ "--performance" ];
    # };
    displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="event*", ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
    openssh.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    logind.settings.Login.HandlePowerKey = "ignore";
  };

  users.users."rv" = {
    isNormalUser = true;
    description = "rv";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
    ];
    # packages = with pkgs; [ ];
  };
  security = {
    rtkit.enable = true;
    sudo.extraRules = [
      {
        users = [ "rv" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nft";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    sessionVariables.QS_ICON_THEME = "hicolor";
    systemPackages = with pkgs; [
      adwaita-icon-theme
      cups-pk-helper
      gtk3
      gtk4
      glib
      kdePackages.breeze
      kdePackages.qt6ct
      nautilus
      nftables
      wget
      xwayland-satellite
      gpu-screen-recorder-gtk
    ];
  };

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.overlays = [
    (final: prev: {
      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: rec {
        version = "0.8.1";
        src = final.fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          rev = "v${version}";
          hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
        };
        cargoDeps = final.rustPlatform.importCargoLock {
          lockFile = "${src}/Cargo.lock";
        };
      });
      niri =
        let
          niriSrc = prev.fetchFromGitHub {
            owner = "neunato";
            repo = "niri";
            rev = "fill-empty-space";
            hash = "sha256-MWMajitHZ1LMjJR+VV0jGpnN8BgDIDbfZE8vhIN9B8U=";
          };
        in
        prev.niri.overrideAttrs (old: {
          src = niriSrc;
          cargoDeps = prev.rustPlatform.fetchCargoVendor {
            src = niriSrc;
            hash = "sha256-HypBB3PL4nVFMNH2+jEK0+dG9dJ920nHi8GwRoeH/v4=";
          };
        });
    })
  ];

  programs = {
    nano.enable = false;
    mtr.enable = true;
    niri.enable = true;
    # hyprland = {
    #   enable = true;
    #   withUWSM = true;
    # };
    dms-shell.enable = true;
    steam.enable = true;
    flyline.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };

  };
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    keyboard.qmk.enable = true;
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # system.copySystemConfiguration = true; # (/run/current-system/configuration.nix)
  system.stateVersion = "26.05";
}
