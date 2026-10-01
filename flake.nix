{
  description = "zxc-flake";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    flyline.url = "github:HalFrgrd/flyline";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oniri = {
      url = "github:Antiz96/oniri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      cachyos-kernel,
      fenix,
      flyline,
      helium-browser,
      home-manager,
      oniri,
      ...
    }:
    let
      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./config.nix
            ./hosts/${hostname}.nix
            flyline.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # backupFileExtension = "backup";
                extraSpecialArgs = { inherit oniri fenix; };
                users.rv = import ./home.nix;
              };
            }
            helium-browser.nixosModules.default
            ({ pkgs, ... }: {
              nixpkgs.overlays = [
                helium-browser.overlays.default
                cachyos-kernel.overlays.pinned
              ];
              programs.helium = {
                enable = true;
                # flags = [ "--enable-features=VaapiOnNvidiaGPUs" ];
                flags = [
                  "--enable-features=HeliumMiddleClickAutoscroll,EnableTLS13EarlyData"
                  "--disable-features=OverlayScrollbar"
                ];
                policies = {
                  ExtensionInstallForcelist = [
                    "ghmbeldphafepmbegfdlkpapadhbakde"
                    # "ajopnjidmegmdimjlfnijceegpefgped"
                    # "mnjggcdmjocbbbhaepdhchncahnbgone"
                    # "gkeojjjcdcopjkbelgbcpckplegclfeg"
                  ];
                };
              };
            })
          ];
        };
    in
    {
      nixosConfigurations.revolution-pc = mkHost "revolution-pc";
      nixosConfigurations.revolution-lt = mkHost "revolution-lt";
    };
}
