{
  pkgs,
  lib,
  oniri,
  ...
}:
{
  home = {
    username = "rv";
    homeDirectory = "/home/rv";
    stateVersion = "26.05";
    file = {
      # ".config/mpv".source = ./.config/mpv;
      ".config/kitty/ssh.conf".text = "shell_integration no-cursor";
    };
    packages = with pkgs; [
      (writeShellScriptBin "xkeen-run" (builtins.readFile ./scripts/xkeen-run))
      (writeShellScriptBin "cs" (builtins.readFile ./scripts/cs))
      (writeShellScriptBin "edit" (builtins.readFile ./scripts/edit))
      (writeShellScriptBin "record" (builtins.readFile ./scripts/record))
      (writeShellScriptBin "games-idle-inhibition" (builtins.readFile ./scripts/games-idle-inhibition))
      oniri.packages.${pkgs.stdenv.hostPlatform.system}.default
      ayugram-desktop
      bash-completion
      btop
      bun
      codex
      dysk
      fastfetch
      fd
      fetch
      ffmpeg
      foot
      fzf
      wireshark
      gamescope
      gcc
      gifski
      go
      gpu-screen-recorder-gtk
      gum
      helix
      htop
      ipinfo
      jq
      just
      knot-dns
      lazygit
      libnotify
      localsend
      mpv
      nil
      nixfmt
      nodejs
      nvtopPackages.nvidia
      nwg-look
      pkgsCross.aarch64-multiplatform-musl.stdenv.cc
      playerctl
      protonplus
      python3
      qbittorrent
      ripgrep
      rustup
      slurp
      statix
      tcpdump
      tree-sitter
      umu-launcher
      unzip
      vesktop
      vial
      wf-recorder
      wl-clipboard
    ];
    activation.xkeenVesktopDesktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.local/share/applications"
      ${pkgs.gnused}/bin/sed "s|^Exec=vesktop \(.*\)|Exec=sh -c 'xkeen-run vesktop \1 > /dev/null 2>&1'|" \
        ${pkgs.vesktop}/share/applications/vesktop.desktop \
        > "$HOME/.local/share/applications/vesktop.desktop"
    '';
  };
  services = {
    wl-clip-persist.enable = true;
    udiskie.enable = true;
    udiskie.tray = "never";
  };
  programs = {
    vicinae.enable = true;
    vicinae.systemd.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = [
        "--keep"
        "10"
      ];
    };
    imv.enable = true;
    satty.enable = true;
    opencode = {
      enable = true;
      tui = {
        theme = "system";
      };
    };
    starship.enable = true;
    bash = {
      enable = true;
      shellAliases = {
        sns = "sudo nixos-rebuild switch --impure --flake path:/home/rv/nix#revolution-pc";
        update = "nix flake update --flake path:/home/rv/nix && sudo nixos-rebuild switch --impure --flake path:/home/rv/nix#revolution-pc";
        lg = "lazygit";
        e = "nvim";
        ii = "ipinfo";
        j = "just";
      };
      bashrcExtra = ''
        flyline editor --show-inline-history-metadata false
        flyline mouse --mode disabled
        flyline set-cursor --backend terminal
        flyline key bind Enter 'tabCompletionEntrySelected=tabCompletionAcceptEntry+submitOrNewline'
        flyline key bind Tab 'tabCompletionEntrySelected=tabCompletionAcceptEntry'
        flyline key remap Ctrl+d Alt+d
      '';
    };
    git = {
      enable = true;
      settings.user = {
        name = "zxc-rv";
        email = "the.revolution@icloud.com";
      };
    };
    kitty = {
      enable = true;
      shellIntegration.mode = "no-cursor";
      enableGitIntegration = true;
      settings = {
        auto_reload_config = "0.1";
        background_blur = "1";
        background_opacity = "0.8";
        bold_font = "auto";
        bold_italic_font = "auto";
        confirm_os_window_close = "0";
        copy_on_select = "clipboard";
        cursor_blink_interval = "0";
        cursor_shape = "underline";
        cursor_trail = "1";
        cursor_trail_decay = "0.1 0.4";
        font_family = "JetBrainsMono Nerd Font";
        font_size = "11.5";
        input_delay = "0";
        italic_font = "auto";
        mouse_hide_wait = "3.0";
        paste_actions = "quote-urls-at-prompt";
        remember_window_size = "no";
        repaint_delay = "2";
        scrollback_lines = "10000";
        select_by_word_characters = ",│`|:\"' ()[]{}<>";
        sync_to_monitor = "no";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        url_style = "curly";
        wayland_enable_ime = "no";
        wheel_scroll_multiplier = "3.0";
        window_padding_width = "20";
      };
      keybindings = {
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+shift+f" = "launch --type=overlay kitty +kitten icat";
        "shift+page_up" = "scroll_page_up";
        "shift+page_down" = "scroll_page_down";
        "shift+home" = "scroll_home";
        "shift+end" = "scroll_end";
        "ctrl+0" = "change_font_size all 0";
      };
      extraConfig = ''
        mouse_map middle release ungrabbed paste_from_selection
        include dank-tabs.conf
        include dank-theme.conf
      '';
    };
  };
}
