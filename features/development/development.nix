# Development tools and environment
{ config, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Core development tools
    gnumake
    cmake
    meson
    ninja
    
    # Compilers
    gcc
    clang
    clang-tools
    llvm
    
    # Binary analysis
    binutils
    file
    hexdump
    xxd
    
    # Debuggers and profilers
    lldb
    strace
    ltrace
    valgrind
    perf-tools
    
    # Hex editors
    ghex
    okteta
    
    # Text processing and search
    ripgrep
    fd
    jq
    yq
    
    # Version control
    diff-so-fancy
    delta
    tig
    
    # Package analysis
    patchelf
    
    # Network debugging
    netcat
    nmap
    wireshark
    
    # System monitoring
    htop
    btop
    iotop
    lsof
    
    # Containerization
    docker
    docker-compose
    
    # Language servers
    nil
    taplo
    yaml-language-server
    
    # Documentation
    man-pages
    man-pages-posix
  ];

  # Development environment variables
  environment.sessionVariables = {
    LESS = "-R";
    PAGER = "less";
    GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
  };

  # Development programs
  programs = {
    bash.completion.enable = true;
    direnv.enable = true;
  };
}