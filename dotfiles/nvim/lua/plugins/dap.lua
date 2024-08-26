return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    {
      'leoluz/nvim-dap-go',
      ft = "go", -- TODO I dont think this actually works
    }
  },
  keys = {
    {"<leader>B", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint"},
    {"<leader>gb", function() require("dap").run_to_cursor() end, desc = "Run to cursor"},
    {"<F5>", function() require("dap").continue() end, desc = "Continue"},
    {"<F6>", function() require("dap").step_into() end, desc = "Step into"},
    {"<F7>", function() require("dap").step_over() end, desc = "Step over"},
    {"<F8>", function() require("dap").step_out() end, desc = "Step out"},
    {"<F9>", function() require("dap").step_back() end, desc = "Step back"},
    {"<F12>", function() require("dap").restart() end, desc = "Step back"},
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    require("nvim-dap-virtual-text").setup()
    require("dap-go").setup()

    -- Eval var under cursor
    -- vim.keymap.set("n", "<space>?", function()
    --   require("dapui").eval(nil, { enter = true })
    -- end)

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
