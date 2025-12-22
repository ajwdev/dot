return {
  {
    "nvimtools/hydra.nvim",
    event = { "BufReadPost", "BufNew" },
    config = function()
      require("config.hydra")
    end,
  },

  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
  },
}
