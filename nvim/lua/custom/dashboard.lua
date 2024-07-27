local M = {
  theme = "hyper",
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
      {
        icon = " ",
        icon_hl = "@variable",
        desc = "Files",
        group = "Label",
        action = "Telescope find_files",
        key = "f",
      },
      {
        desc = " Words",
        group = "DiagnosticHint",
        action = "Telescope live_grep",
        key = "a",
      },
      {
        desc = " dotfiles",
        group = "Number",
        action = "Telescope dotfiles",
        key = "d",
      },
      {
        desc = " Mason install",
        group = "Label",
        action = "MasonInstallAll",
        key = "m",
      },
      {
        desc = " CheatSheet",
        group = "Label",
        action = "NvCheatsheet",
        key = "c",
      },
    },
  },
}
return M
