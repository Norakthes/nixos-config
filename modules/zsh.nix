{ config, pkgs, lib, global_config, ... }:

{
  # Set Zsh as default shell
  programs.zsh = {
    enable = true;
    
    # Oh My Zsh configuration
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "docker" 
        "docker-compose"
        "python"
        "pip"
        "virtualenv"
        "node"
        "npm"
        "yarn"
        "systemd"
        "sudo"
        "history"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "z"  # Directory jumping
      ];
      #theme = "powerlevel10k/powerlevel10k";
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    
    # Additional Zsh configuration
    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      l = "eza --icons -CF";

      tree = "eza --icons --tree";

      grep = "rg --color=auto";
      cat = "bat";
      top = "btop";
      find = "fd";
      
      # NixOS rebuild shortcuts
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos/.#${global_config.hostname}";
      nix-dry = "sudo nixos-rebuild dry-run --flake /etc/nixos/.#${global_config.hostname}";
      nix-boot = "sudo nixos-rebuild boot --flake /etc/nixos/.#${global_config.hostname}";
      nix-test = "sudo nixos-rebuild test --flake /etc/nixos/.#${global_config.hostname}";
    };
    
    # Smart nixos-rebuild function (overrides the original command)
    shellInit = ''
      nixos-rebuild() {
        local action="''${1:-switch}"
        sudo nixos-rebuild "$action" --flake /etc/nixos/.#${global_config.hostname} "''${@:2}"
      }
    ''; 

    # Auto-suggestions and syntax highlighting
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    # History configuration
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
  };

  # Install Powerlevel10k theme
  environment.systemPackages = with pkgs; [
    # Powerlevel10k theme
    zsh-powerlevel10k
    
    # Additional shell tools
    eza          # Modern ls replacement
    bat          # Better cat with syntax highlighting
    fd           # Better find
    ripgrep      # Better grep
    fzf          # Fuzzy finder
    zoxide       # Smart directory jumping (better than z)
    starship     # Alternative prompt (backup)
    
    # Development tools that show in prompt
    git
    docker
    docker-compose
    python3
    nodejs
    
    # Terminal utilities
    htop
    btop
  ];

  # Set user's default shell to zsh
  users.users.${global_config.username} = {
    shell = pkgs.zsh;
  };

  # Fonts (you mentioned nerd fonts are already installed, but just in case)
  fonts.packages = with pkgs; [
    #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    nerd-fonts.liberation
  ];
  
  # Enable command-not-found for better error messages
  programs.command-not-found.enable = true;
}
