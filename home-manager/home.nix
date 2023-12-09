# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 

# let section to allow OS-specific definitions
let
  globalPackages = with pkgs; [

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    #terminal applications
    lesspipe
    nixfmt
    gh
    lf
    bottom
    yadm

    #desktop applications
    spotify-qt
    emacs29
    firefox

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  linuxPackages = with pkgs; [ ];
  darwinPackages = with pkgs; [ ];

in {
  # stitch platforms' package lists together
  home.packages = globalPackages
    ++ (if pkgs.hostPlatform.isLinux then linuxPackages else darwinPackages);

  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "paul";
    homeDirectory =
    if pkgs.hostPlatform.isLinux then "/home/paul" else "/Users/paul";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  # stuff from pop/mac-based nix config
    # os-specific packages yoinked from here: https://github.com/esselius/setup/blob/main/modules/home-packages.nix

  # fonts!
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #
    # if you don't want to manage your shell through Home Manager.
  };
  home.sessionVariables = {
    # EDITOR = "emacs";
    PATH = "$PATH:/home/paul/.local/share/JetBrains/Toolbox/scripts";
    QSYS_ROOTDIR = "/home/paul/intelFPGA_lite/22.1std/quartus/sopc_builder/bin";
    LM_LICENSE_FILE = "/usr/local/flexlm/licenses/LR-133714_License.dat";
    skip_global_compinit = 1;
  };

  # these are modified such that they only activate on Linux since I share this config with a Mac
  # based on https://github.com/nix-community/home-manager/issues/3864
  xdg.enable = pkgs.hostPlatform.isLinux;
  xdg.mime.enable = pkgs.hostPlatform.isLinux;
  targets.genericLinux.enable = pkgs.hostPlatform.isLinux;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # let home-manager manage bash and zsh but still use my own rc files -
  # should also fix completions from home-manager installed programs
  programs = {
    bash = {
      enable = true;
      initExtra = ''

        if [ -f $HOME/.config/bash/.bashrc ];
        then
          source $HOME/.config/bash/.bashrc
        fi
      '';

      profileExtra = ''
        export XDG_DATA_DIRS="/home/paul/.nix-profile/share:$XDG_DATA_DIRS"
      '';
    };

    zsh = {
      enable = true;

      enableCompletion = false; # my plugins handle this for me

      initExtra = ''

        if [ -f $HOME/.config/zsh/.zshrc ];
        then
          source $HOME/.config/zsh/.zshrc
        fi
      '';
    };

    git = {
      enable = true;
      userName = "Herschenglime";
      userEmail = "herschenglime@gmail.com";
    };

    gh = {
      enable = true;
      settings = { prompt = "enabled"; };
    };
  };

}
