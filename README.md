# NixOS Configuration

A clean, modular NixOS configuration with high cohesion and low coupling. Designed to work across different machine types (laptops, desktops, servers) with minimal configuration changes.

## Structure

```
nixos-config/
├── flake.nix                 # Entry point and machine definitions
├── configuration.nix         # Main configuration with module imports
├── core/                     # Core system modules (always applied)
│   ├── base.nix             # Essential packages and Nix settings
│   ├── boot.nix             # Bootloader and kernel configuration
│   ├── networking.nix       # Network, time, locale settings
│   ├── users.nix            # User accounts and groups
│   └── security.nix        # SSH, audio, security services
├── features/                # Optional features per machine
│   ├── desktop/            # Desktop environment components
│   │   ├── desktop.nix     # Desktop environment, GUI apps
│   │   └── dwm.nix        # DWM window manager
│   ├── development/        # Development tools and environment
│   │   └── development.nix # Compilers, editors, LSPs, etc.
│   ├── gaming/             # Gaming setup and optimizations
│   │   └── gaming.nix      # Steam, GPU drivers, gaming tools
│   └── hardware/           # Hardware-specific configurations
│       └── hardware.nix    # ASUS, power management, YubiKey, etc.
├── machines/               # Machine-specific configurations
│   ├── laptop/            # Laptop-specific settings
│   │   ├── default.nix    # Custom laptop configuration
│   │   └── hardware-configuration.nix
│   └── desktop/           # Desktop-specific settings
│       ├── default.nix    # Custom desktop configuration
│       └── hardware-configuration.nix
├── home/                 # Home-manager configurations
│   ├── packages.nix      # User packages
│   ├── nixvim.nix        # Neovim configuration
│   ├── git.nix           # Git settings
│   └── ...               # Other home configurations
├── modules/              # Legacy modules (being phased out)
│   ├── gc.nix            # Garbage collection
│   ├── kanata.nix        # Keyboard remapping
│   ├── scripts.nix       # System scripts
│   ├── zsh.nix           # Shell configuration
│   └── wallpaper.nix      # Wallpaper management
└── packages/             # Custom package definitions
    ├── dwmstatus/        # Custom DWM status bar
    └── maple/            # Maple mathematical software
```

## Design Principles

### High Cohesion
- Each module has a single, clear responsibility
- Related functionality is grouped together
- Core functionality is separated from optional features

### Low Coupling
- Modules are independent and don't depend on each other
- Feature detection is done through configuration, not hard-coded dependencies
- Machine-specific configurations are isolated

### Reusability
- Features can be mixed and matched per machine
- No assumptions about specific hardware in core modules
- Easy to add new machines or features

## Machine Configuration

Machines are defined in `flake.nix` with their feature sets:

```nix
laptop = {
  hostname = "laptop";
  username = "rasmus";
  features = [
    "desktop"      # Enable desktop environment
    "dwm"          # Use DWM window manager
    "development"  # Development tools
    "gaming"       # Gaming support
    "asusctl"      # ASUS laptop controls
    "power_management"  # Power management
    "yubikey"      # YubiKey support
    "riscv32-dev"  # RISC-V development
  ];
  gpu = {
    amd_bus_id = "PCI:07:00:0";
    nvidia_bus_id = "PCI:01:00:0";
  };
  hardware_module = nixos-hardware.nixosModules.asus-zephyrus-ga503;
};
```

## Adding New Machines

1. Create machine directory in `machines/`
2. Add machine definition to `flake.nix`
3. Specify required features
4. Add any machine-specific configuration

## Adding New Features

1. Create feature file in appropriate `features/` subdirectory
2. Import the feature in `configuration.nix` with feature detection
3. Add feature to machine definitions in `flake.nix`

## Features

### Core (always applied)
- Essential system packages
- Bootloader and kernel
- Networking and locale
- User accounts
- Security services (SSH, audio, etc.)

### Optional
- **Desktop**: GUI desktop environment, file managers, utilities
- **DWM**: Dynamic window manager configuration
- **Development**: Compilers, editors, debugging tools
- **Gaming**: Steam, GPU drivers, gaming optimizations
- **Hardware**: Hardware-specific configurations (ASUS, YubiKey, etc.)

## Usage

### Build and switch
```bash
sudo nixos-rebuild switch --flake .#laptop
```

### Test configuration
```bash
sudo nixos-rebuild test --flake .#laptop
```

### Update flake inputs
```bash
nix flake update
```

## Migration Notes

This configuration has been refactored from a monolithic structure to a modular system:

- ❌ Removed hardcoded packages and mixed concerns
- ✅ Separated core system from optional features  
- ✅ Created independent, reusable modules
- ✅ Cleaned up ad hoc solutions and temporary fixes
- ✅ Maintained all existing functionality

## Maintenance

- Keep core modules minimal and essential
- Separate machine-specific concerns to machine configs
- Test new features on multiple machine types
- Update feature dependencies carefully
- Document new features in this README