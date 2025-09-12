# modules/development.nix
{ config, pkgs, lib, global_config, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core development tools
    git
    gnumake
    cmake
    meson
    ninja
    
    # Compilers and build systems (host architecture)
    (lib.hiPrio gcc)
    clang
    clang-tools  # clang-format, clang-tidy, clangd LSP, etc.
    llvm
    
    # Binary analysis and debugging
    (lib.hiPrio binutils)      # objdump, readelf, nm, strip, etc.
    file          # File type detection
    hexdump       # Hex dump utility
    xxd           # Another hex dump tool
    
    # Debuggers and profilers
    #gdb           # GNU debugger
    lldb          # LLVM debugger
    strace        # System call tracer
    ltrace        # Library call tracer
    valgrind      # Memory debugging and profiling
    perf-tools    # Performance analysis
    
    # Hex/binary editors
    ghex          # GTK hex editor
    okteta        # KDE hex editor
    
    # Text processing and search
    ripgrep       # Fast grep alternative
    fd            # Fast find alternative
    jq            # JSON processor
    yq            # YAML processor
    
    # Version control and diff tools
    diff-so-fancy # Better git diffs
    delta         # Another syntax-highlighting pager for git
    tig           # Text-mode interface for git
    
    # Package and dependency analysis
    patchelf      # Modify ELF files
    
    # Network debugging
    netcat        # Network swiss army knife
    nmap          # Network discovery
    wireshark     # Packet analyzer
    
    # System monitoring
    htop
    btop
    iotop
    lsof
    
    # Container and virtualization (if you need them)
    docker
    docker-compose
    
    # Language servers and development environments
    nil           # Nix language server
    taplo         # TOML language server
    yaml-language-server
    
    # Documentation
    man-pages
    man-pages-posix
  ];

  # Development environment variables
  environment.sessionVariables = {    
    # Better less/man page experience
    LESS = "-R";
    PAGER = "less";
    
    # Colored GCC warnings and errors
    GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
  };

  # Enable some useful development services
  programs = {
    # Better command completion
    bash.completion.enable = true;
    
    # Development shells
    direnv.enable = true;  # Automatic environment loading
  };
}
