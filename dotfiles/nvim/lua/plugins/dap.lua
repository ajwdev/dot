return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
  },
  -- keys = {
  --   {"<F8>", function() require'dap'.toggle_breakpoint() end, desc = "Toggle breakpoint"},
  -- },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    require("dapui").setup()
    require("dap-go").setup()
    require("nvim-dap-virtual-text").setup()

    vim.keymap.set("n", "<space>B", dap.toggle_breakpoint)
    vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

    -- Eval var under cursor
    vim.keymap.set("n", "<space>?", function()
      require("dapui").eval(nil, { enter = true })
    end)

    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F6>", dap.step_into)
    vim.keymap.set("n", "<F7>", dap.step_over)
    vim.keymap.set("n", "<F8>", dap.step_out)
    vim.keymap.set("n", "<F9>", dap.step_back)
    vim.keymap.set("n", "<F12>", dap.restart)

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
