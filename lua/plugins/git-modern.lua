-- ~/.config/nvim/lua/plugins/git-modern.lua
-- Modern Git integration for easy workflows
return {
  -- Neogit: Modern Git interface (like Magit)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit: Open" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit: Commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Neogit: Push" },
      { "<leader>gP", "<cmd>Neogit pull<cr>", desc = "Neogit: Pull" },
    },
    opts = {
      kind = "split", -- or "tab", "floating", "split_above"
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },

  -- Diffview: Beautiful diff viewer
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Project History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },

  -- Enhanced GitSigns with better keybindings
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation (nav_hunk: API atual; next_hunk/prev_hunk deprecados)
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next Hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Prev Hunk")

        -- Actions (stage_hunk agora alterna stage/unstage; undo_stage_hunk foi removido)
        map("n", "<leader>gs", gs.stage_hunk, "Stage/Unstage Hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage/Unstage Hunk")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")

        map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gv", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Blame")
      end,
    },
  },

  -- Git-related Telescope pickers
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fgc", "<cmd>Telescope git_commits<cr>", desc = "Git: Commits" },
      { "<leader>fgb", "<cmd>Telescope git_branches<cr>", desc = "Git: Branches" },
      { "<leader>fgs", "<cmd>Telescope git_status<cr>", desc = "Git: Status" },
      { "<leader>fgh", "<cmd>Telescope git_stash<cr>", desc = "Git: Stash" },
    },
  },
}
