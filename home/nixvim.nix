# nixvim-config.nix
{ pkgs, config, ... }:
{
  programs.nixvim = {
    enable = true;
    
    # Create vim and vi aliases
    viAlias = true;
    vimAlias = true;
    
    # Set leader key
    globals.mapleader = " ";
    
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;
      
      # Indentation (3 spaces by default)
      expandtab = true;
      tabstop = 3;
      shiftwidth = 3;
      softtabstop = 3;
      smartindent = true;
      autoindent = true;
      
      # Search behavior
      incsearch = true;
      hlsearch = true;
      
      # File handling
      backup = false;
      swapfile = false;
      undofile = true;
      undodir = "${config.home.homeDirectory}/.local/share/nvim/undodir";
      autoread = true;
      
      # Editor behavior  
      updatetime = 50;
      scrolloff = 10;
      colorcolumn = "80";
      
      # Character encoding
      encoding = "utf-8";
      fileencoding = "utf-8";
      
      # Disable cursor blinking
      guicursor = "a:blinkon0";
      
      # Backspace behavior
      backspace = "indent,eol,start";
    };

    # Key mappings
    keymaps = [
      # Disable arrow keys (force good habits)
      {
        mode = "n";
        key = "<Up>";
        action = "<cmd>echo 'No up for you bitch!'<CR>";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<Down>";
        action = "<cmd>echo 'No down for you bitch!'<CR>";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<Left>";
        action = "<cmd>echo 'No left for you bitch!'<CR>";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<Right>";
        action = "<cmd>echo 'No right for you bitch!'<CR>";
        options.noremap = true;
      }
      
      # File tree toggle (like IDE)
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file tree";
      }
      
      # Telescope fuzzy finder
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
    ];

    # Theme
    colorschemes.onedark.enable = true;

    # Autocommand groups
    autoGroups = {
      filetype_indent = {
        clear = true;
      };
    };
    
    # Filetype-specific indentation rules
    autoCmd = [
      {
        event = ["FileType"];
        pattern = ["nix"];
        group = "filetype_indent";
        callback = {
          __raw = ''
            function()
              vim.opt_local.tabstop = 2
              vim.opt_local.shiftwidth = 2
              vim.opt_local.softtabstop = 2
            end
          '';
        };
      }
      {
        event = ["FileType"];
        pattern = ["yaml" "yml" "json"];
        group = "filetype_indent";
        callback = {
          __raw = ''
            function()
              vim.opt_local.tabstop = 2
              vim.opt_local.shiftwidth = 2
              vim.opt_local.softtabstop = 2
            end
          '';
        };
      }
    ];

    # Plugins
    plugins = {
      # Icons for file tree and other UI elements
      web-devicons.enable = true;

      # File explorer (IDE-style)
      nvim-tree = {
        enable = true;
        openOnSetup = false;
        hijackCursor = true;
        updateFocusedFile.enable = true;
        
        view = {
          width = 30;
          side = "left";
        };
        
        renderer = {
          groupEmpty = true;
          highlightGit = true;
          icons.glyphs = {
            default = "";
            symlink = "";
            folder = {
              arrowOpen = "";
              arrowClosed = "";
              default = "";
              open = "";
              empty = "";
              emptyOpen = "";
              symlink = "";
              symlinkOpen = "";
            };
          };
        };
      };

      # Syntax highlighting engine
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # Language server protocol
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;   # Nix
          ruff.enable = true;     # Python  
          lua_ls.enable = true;   # Lua
          zls.enable = true;      # Zig
        };
      };

      # Code completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        
        settings = {
          snippet = {
            expand = { __raw = "function(args) require('luasnip').lsp_expand(args.body) end"; };
          };
          
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
              })
            '';
          };
          
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };

      # Snippet engine
      luasnip.enable = true;

      # Fuzzy finder
      telescope.enable = true;

      # Status line
      lualine = {
        enable = true;
        settings.options.theme = "onedark";
      };

      # Git integration
      gitsigns.enable = true;

      # Auto-close brackets and quotes
      nvim-autopairs.enable = true;

      # Comment toggling
      comment.enable = true;

      # Keybinding help
      which-key.enable = true;
    };

    # Additional configuration
    extraConfigLua = ''
      -- Custom highlight for column marker
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2d3748" })
    '';
  };
}
