local myutil = require("config.util")

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

lspconfig.gopls.setup {
  cmd = {'gopls','--remote=auto'},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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
      codelenses = {
        generate = false,  -- Don't show the `go generate` lens.
        gc_details = true  -- Show a code lens toggling the display of gc's choices.
      },
      staticcheck = true,
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

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      completion = {
        callSnippet = "Replace"
      },
      format = {
        enable = true,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
    }
  }
}

lspconfig.nil_ls.setup {
  settings = {
        ['nil'] = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
}

lspconfig.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://api.spinnaker.mgmt.netflix.net/managed/delivery-configs/schema"] = "spinnaker.yml",
      },
    }
  }
}


lspconfig.clangd.setup {}
lspconfig.solargraph.setup {}
lspconfig.bashls.setup {}
lspconfig.racket_langserver.setup{}
lspconfig.tilt_ls.setup{}
lspconfig.racket_langserver.setup {}
lspconfig.tilt_ls.setup {}
lspconfig.ruby_lsp.setup {}

require("inlay-hints").setup {
  only_current_line = true,

  -- eol = {
  --   right_align = true,
  -- }
}

require("lsp_signature").setup { }

require("config.lsp.lightbulb")


-- Advertise nvim-cmp capabilities to the LSP server
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- This should match the configured servers above
local servers = { "gopls", "rust_analyzer", "tsserver" , "clangd" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilties = capabilities,
  }
end



local function opts(desc)
  return  {
    noremap = true,
    silent = true,
    desc = desc,
  }
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts("Open floating diagnostic window"))
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts("Goto previous diagnostic"))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts("Goto next diagnostic"))
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts("Add diagnostics to location list"))

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(ev.buf, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(ev.buf, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts("Goto definition"))
    buf_set_keymap('n', '<space>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts("Goto declaration"))
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts("Goto type definition"))
    -- Same as above but in a vertical split
    buf_set_keymap('n', '<c-w>gd', '<Cmd>vsp<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts("Goto definition in vertical split"))
    buf_set_keymap('n', '<c-w>gD', '<Cmd>vsp<CR><cmd>lua vim.lsp.buf.type_definition()<CR>', opts("Goto type definition in vertical split"))

    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts("List all implementations in quickfix"))
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts("List all references in quickfix"))
    buf_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts("List all references in Telescope"))

    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts("Show symbol information under cursor in floating window"))
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts("List all references in quickfix"))

    buf_set_keymap('n', '<space>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts())
    buf_set_keymap('n', '<space>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts())
    buf_set_keymap('n', '<space>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts())

    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts("Rename symbol under cursor"))
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts("Execute LSP code action"))
    buf_set_keymap("n", "<space>F", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts("Format buffer"))
  end
})

-- Window appearance. I need borders for my eyes
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
 vim.lsp.handlers.hover, {
   border = myutil.Windowstyle.border,
 }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
 vim.lsp.handlers.signature_help, {
   border = myutil.Windowstyle.border,
 }
)

vim.diagnostic.config {
    float = { border = myutil.Windowstyle.border },
}
