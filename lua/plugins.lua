return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-dispatch'
  use 'tommcdo/vim-exchange'
  use 'andymass/vim-matchup'
  use 'wellle/targets.vim'

  use 'radenling/vim-dispatch-neovim'

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }

  use 'folke/neodev.nvim'

  use {
    'jiangmiao/auto-pairs',
    ft = {'clojure'}
  }

  use {
    'p00f/nvim-ts-rainbow'
  }

  use {
    'Olical/conjure',
    requires = 'clojure-vim/vim-jack-in',
    ft = {'clojure','scheme'}
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'ryanoasis/vim-devicons'}}
  }

  use 'neovim/nvim-lspconfig'

  use 'dense-analysis/ale'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'hrsh7th/nvim-compe'

  -- use 'sainnhe/sonokai'
  -- use 'morhetz/gruvbox'
  use 'ellisonleao/gruvbox.nvim'

  -- Delay repeat execution of certain keys
  --use 'ja-ford/delaytrain.nvim'

  use 'nvim-treesitter/nvim-treesitter-context'
end)
