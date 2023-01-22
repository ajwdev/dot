-- Must be defined before the remaining LSP config per the docs
require("neodev").setup {}

local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
  cmd = {'gopls','--remote=auto'},
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  capabilties = {
    textDocuemnt = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true
  }
}
lspconfig.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
}
lspconfig.clangd.setup {}
lspconfig.solargraph.setup {}
lspconfig.bashls.setup {}

lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
}


require("inlay-hints").setup {
  only_current_line = true,

  -- eol = {
  --   right_align = true,
  -- }
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  require("lsp_signature").on_attach()

  -- local ih = require("inlay-hints")
  -- ih.on_attach(client, bufnr)

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<space>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', '<space>gd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Same as above but in a vertical split
  buf_set_keymap('n', '<c-w>gd', '<Cmd>vsp<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<c-w>gD', '<Cmd>vsp<CR><cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  buf_set_keymap('n', '<space>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- NOTE - rust-analyzer is not setup here as the rust-tools plugin will handle that

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { "gopls", "tsserver" , "clangd", "zls" }
-- local servers = { "gopls", "rust_analyzer", "tsserver" , "clangd" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilties = capabilities,
    on_attach = on_attach,
  }
end

require('rust-tools').setup({ server = { on_attach = on_attach, } })
require('rust-tools.expand_macro').expand_macro()

require "config.lsp.lightbulb"
