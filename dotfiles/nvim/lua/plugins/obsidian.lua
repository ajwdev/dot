return {
  {
    "epwalsh/obsidian.nvim",
    event = { "BufReadPre ~/Documents/obsidian_work/**.md" },
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function ()
      require("obsidian").setup({
        dir = "~/Documents/obsidian_work",
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "Daily",
          -- Optional, if you want to change the date format for daily notes.
          -- date_format = "%Y-%m-%d"
        },

        new_notes_location = "current_dir",

        completion = {
          -- If using nvim-cmp, otherwise set to false
          nvim_cmp = true,
          -- Trigger completion at 2 chars
          min_chars = 2,
          -- Where to put new notes created from completion. Valid options are
          --  * "current_dir" - put new notes in same directory as the current buffer.
          --  * "notes_subdir" - put new notes in the default notes subdirectory.
          -- new_notes_location = "current_dir",

          -- Whether to add the output of the node_id_func to new notes in autocompletion.
          -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
          -- prepend_note_id = true
        }
      })
    end
  },
}
