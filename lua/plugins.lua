return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-speeddating'
  use 'rstacruz/vim-closer'
  use 'andymass/vim-matchup'

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

  use 'sainnhe/sonokai'
end)
