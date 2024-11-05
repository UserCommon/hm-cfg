{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "usercommon";
  home.homeDirectory = "/home/usercommon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  imports = [
    ./dev.nix
    ./media.nix
  ];
  
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # pkgs.discord
    pkgs.fd
    pkgs.ripgrep
  ];
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];
  };
  targets.genericLinux.enable=true;
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
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/usercommon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash.profileExtra = lib.mkAfter ''
    rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
    rm -rf ${config.home.homeDirectory}/.icons/nix-icons
    ls ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop > ${config.home.homeDirectory}/.cache/current_desktop_files.txt
  '';
  home.activation = {
    linkDesktopApplications = {
      after = ["writeBoundary" "createXdgUserDirectories"];
      before = [];
      data = ''
        rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
        rm -rf ${config.home.homeDirectory}/.icons/nix-icons
        mkdir -p ${config.home.homeDirectory}/.local/share/applications/home-manager
        mkdir -p ${config.home.homeDirectory}/.icons
        ln -sf ${config.home.homeDirectory}/.nix-profile/share/icons ${config.home.homeDirectory}/.icons/nix-icons

        # Check if the cached desktop files list exists
        if [ -f ${config.home.homeDirectory}/.cache/current_desktop_files.txt ]; then
          current_files=$(cat ${config.home.homeDirectory}/.cache/current_desktop_files.txt)
        else
          current_files=""
        fi

        # Symlink new desktop entries
        for desktop_file in ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop; do
          if ! echo "$current_files" | grep -q "$(basename $desktop_file)"; then
            ln -sf "$desktop_file" ${config.home.homeDirectory}/.local/share/applications/home-manager/$(basename $desktop_file)
          fi
        done

        # Update desktop database
        ${pkgs.desktop-file-utils}/bin/update-desktop-database ${config.home.homeDirectory}/.local/share/applications
      '';
    };
  }; 
}