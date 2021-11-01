require('plugins')

local opt = vim.opt
local g = vim.g
-- undofile
opt.undodir = os.getenv( "HOME" ) .. "/.local/share/nvim/undodir"
os.execute( "mkdir " .. vim.o.undodir )
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'a'
opt.wrap = false
opt.smarttab = true
opt.expandtab = true
opt.shiftwidth = 2
opt.signcolumn = 'number'
opt.cmdheight = 2
opt.splitbelow = true
opt.splitright = true
opt.equalalways = true
opt.incsearch = true
opt.hlsearch = true
opt.number = true
opt.relativenumber = false
opt.listchars = 'tab:> ,trail:-,extends:>,precedes:<,nbsp:+'
opt.list = true
opt.formatoptions:append('j')
opt.scrolloff = 2
opt.sidescrolloff=10
opt.autoread = true
opt.autoindent = true
opt.backspace = { 'indent', 'eol', 'start' }
opt.laststatus = 2
opt.ruler = true
opt.encoding = 'UTF-8'
opt.completeopt = 'menuone,noselect' -- For nvim-compe

vim.api.nvim_set_keymap('n', '<leader>cq', ':cclose<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>lq', ':lclose<cr>', { silent = true })

vim.api.nvim_set_keymap('n', '[t', ':tabp<cr>', { silent = true })
vim.api.nvim_set_keymap('n', ']t', ':tabn<cr>', { silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', 'zH', { silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', 'zL', { silent = true })

--ALE--------------------------------------------------------------------------
g.ale_disable_lsp = 1
g.ale_fixers = {
  rust = { "rustfmt" },
  typescript = { "eslint", "prettier" },
  javascript = { "eslint", "prettier" },
  typescriptreact = { "eslint", "prettier" },
  javascriptreact = { "eslint", "prettier" }
}

--Nvim Tree--------------------------------------------------------------------
require'nvim-tree'.setup {
  view = {
    width = 30
  }
}
g.nvim_tree_quit_on_open = 1
vim.api.nvim_set_keymap('n', '_', ':NvimTreeToggle<CR>', { silent = true })
vim.api.nvim_command('command FF NvimTreeFindFile')

g.sonokai_style = 'andromeda'
g.sonokai_enable_italic = 1
vim.cmd('colorscheme sonokai')

--Telescope--------------------------------------------------------------------
require'telescope'.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
      },
      n = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
      },
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        n = {
          ["d"] = require('telescope.actions').delete_buffer,
        }
      }
    },
  }
}
local shh = { noremap=true, silent=true }
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", shh)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", shh)
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", shh)
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", shh)

vim.api.nvim_set_keymap("n", "+", "<cmd>lua require('telescope.builtin').buffers()<CR>", shh)

--Tree sitter------------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}
--Auto completion-------------------------------------------------------------
vim.o.completeopt = "menuone,noselect"

-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<C-n>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<C-n>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-p>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<C-p>", "v:lua.s_tab_complete()", {expr = true})

--This line is important for auto-import
vim.api.nvim_set_keymap('i', '<C-y>', 'compe#confirm("<cr>")', {expr = true})

--LSP-------------------------------------------------------------------------
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', shh)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', shh)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', shh)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', shh)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', shh)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', shh)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', shh)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', shh)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', shh)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', shh)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', shh)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', shh)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', shh)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', shh)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', shh)
  -- buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', shh)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", shh)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver", "clangd" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
