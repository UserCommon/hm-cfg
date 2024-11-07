{pkgs, config, ...}: {
  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  programs.neovim = 
  let 
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = (nvim-treesitter.withPlugins(p: [
                    p.bash
                    p.json
                    p.lua
                    p.markdown
                    p.nix
                    p.python
                    p.rust
                    p.go
                    p.cpp
                  ]));
          config = toLuaFile ./nvim/lua/custom/plugin/treesitter.lua;
      }

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/lua/custom/plugin/lsp.lua;
      }

      {
       plugin = gruvbox;
       config = "colorscheme gruvbox";
      }

      {
        plugin = neogit;
        config = toLuaFile ./nvim/lua/custom/plugin/git.lua;
      }

      conform-nvim

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/lua/custom/plugin/telescope.lua;
      }
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      {
        plugin = nvim-surround;
        config = toLuaFile ./nvim/lua/custom/plugin/surround.lua;
      }

      { 
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/lua/custom/plugin/cmp.lua;
      }

      { 
        plugin = luasnip;
        config = toLuaFile ./nvim/lua/custom/plugin/snippets.lua;
      }

      # luasnip
      lspkind-nvim
      cmp-nvim-lsp

      {
        plugin = nvim-dap;
        config = toLuaFile ./nvim/lua/custom/plugin/dap.lua;
      }
 
      {
        plugin = nvim-dap-ui;
        config = toLuaFile ./nvim/lua/custom/plugin/dap.lua;
      }

      vimtex
    ];

    extraPackages = with pkgs; [
      lua-language-server
      ripgrep
      fd
      lldb
      vscode-extensions.vadimcn.vscode-lldb
      texlab
      texliveFull
      xclip
      wl-clipboard
      biber
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/lua/core/options.lua}
      ${builtins.readFile ./nvim/lua/core/keymap.lua}
    '';


    # extraConfig = ''
    #   " For faster startup
    #   lua vim.loader.enable()
    #
    #   " General
    #   set nocompatible            " get rid of Vi compatibility mode. SET FIRST!
    #   filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]
    #   syntax enable               " enable syntax highlighting (previously syntax on).
    #
    #   " Tabs/spaces
    #   set tabstop=2
    #   set expandtab
    #   set shiftwidth=2
    #
    #   " Navigation
    #   set scrolloff=3             " some lines around scroll for context
    #
    #   " Cursor/Line
    #   set number
    #   set colorcolumn=-0          " based on textwidth
    #   set cursorline              " highlight the current line
    #
    #   " Status/History
    #   set history=200             " remember a lot of stuff
    #   set ruler                   " Always show info along bottom.
    #   set cmdheight=1
    #
    #   " Scrolling
    #   set ttyfast
    #
    #   " Files
    #   set autoread                            " auto-reload files changed on disk
    #   set updatecount=0                       " disable swap files
    #   set wildmode=longest,list,full 
    #
    #   " Vimdiff
    #   set diffopt=filler,vertical
    #
    #   " Conceal (disabled by default)
    #   set conceallevel=0
    #
    #   " Wrapping
    #   set nowrap
    #
    #   " Leader
    #   nnoremap <Space> <Nop>
    #   let mapleader = ' '
    #   let maplocalleader = ' '
    #
    #   " Make F1 work like Escape.
    #   map <F1> <Esc>
    #   imap <F1> <Esc>
    #
    #   " Mouse issue (https://github.com/neovim/neovim/wiki/Following-HEAD#20170403)
    #   set mouse=a
    #
    #   " Use system clipboard for yanks.
    #   set clipboard+=unnamedplus
    #
    #   " Use ,t for 'jump to tag'.
    #   nnoremap <Leader>t <C-]>
    #
    #   " Allow hidden windows
    #   set hidden
    #
    #   " Grep with rg
    #   set grepprg=rg\ --line-number\ --column
    #   set grepformat=%f:%l:%c:%m
    #   " Theme
    #   set termguicolors        " Включить 24-битный цвет для Neovim
    #   set background=dark      " Использовать темный фон для Gruvbox
    #   colorscheme gruvbox      " Установить Gruvbox в качестве темы
    #
    #   " Дополнительные стили для Gruvbox
    #   highlight Keyword gui=bold
    #   highlight Comment gui=italic
    #   highlight Constant guifg=#d3869b
    #   highlight NormalFloat guibg=#3c3836
    #
    #   luafile ${vim/keymap.lua}
    #   luafile ${vim/formatting.lua}
    #   luafile ${vim/git.lua}
    #   luafile ${vim/lsp.lua}
    #   luafile ${vim/nvim-surround.lua}
    #   luafile ${vim/telescope.lua}
    #   luafile ${vim/nvim-cmp.lua}
    #   luafile ${vim/dap.lua}
    #   luafile ${vim/tex.lua}
    # '';    
  };

}
