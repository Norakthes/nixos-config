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

      # LSP keybindings
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Show hover documentation";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Show references";
      }

      # Buffer navigation
      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>bdelete<CR>";
        options.desc = "Close buffer";
      }
      {
        mode = "n";
        key = "<leader>X";
        action = "<cmd>BufferLineCloseOthers<CR>";
        options.desc = "Close other buffers";
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
        
        settings = {
          #open_on_setup = false;
          hijack_cursor = true;
          update_focused_file.enable = true;

          view = {
            width = 30;
            side = "left";
          };

          renderer = {
            group_empty = true;
            highlight_git = true;
            icons.glyphs = {
              default = "";
              symlink = "";
              folder = {
                arrow_open = "";
                arrow_closed = "";
                default = "";
                open = "";
                empty = "";
                empty_open = "";
                symlink = "";
                symlink_open = "";
              };
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
          zls = {
            enable = true;
            # Zig inlay hints config
            settings = {
              enable_inlay_hints = true;
              inlay_hints_show_builtin = true;
              inlay_hints_exclude_single_argument = true;
              inlay_hints_hide_redundant_param_names = false;
              inlay_hints_hide_redundant_param_names_last_token = false;
            };
          };
          clangd.enable = false;   # C/C++
        };
        
        # Enable inlay hints globally
        inlayHints = true;
        };

        # Buffer/tab line (like VSCode tabs)
        bufferline = {
          enable = true;
          settings = {
            options = {
              mode = "buffers";
              numbers = "none";
              close_command = "bdelete! %d";
              right_mouse_command = "bdelete! %d";
              left_mouse_command = "buffer %d";
              middle_mouse_command = null;
              indicator = {
                style = "icon";
                icon = "▎";
              };
              buffer_close_icon = "󰅖";
              modified_icon = "●";
              close_icon = "";
              left_trunc_marker = "";
              right_trunc_marker = "";
              diagnostics = "nvim_lsp";
              offsets = [
                {
                  filetype = "NvimTree";
                  text = "File Explorer";
                  text_align = "left";
                  separator = true;
                }
              ];
              show_buffer_close_icons = true;
              show_close_icon = true;
              separator_style = "thin";
            };
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
              {
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, {'i', 's'}),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
                end, {'i', 's'}),
              }
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
      #lualine = {
      #  enable = true;
      #  settings.options.theme = "onedark";
      #};

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

      -- Enable inlay hints automatically
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })
    '';
  };
}
