local wezterm = require 'wezterm'

local config = {}

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Your existing configuration settings
config.font = wezterm.font 'Fira Code'
config.font_size = 12.0
config.window_padding = {
  left = 10,
  right = 10,
  top = 0,
  bottom = 0,
}

-- **Set PowerShell as the default shell**
config.default_prog = { 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-NoLogo' }
-- For PowerShell 7+, use:
-- config.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' }

-- **Define the Miasma color scheme within the configuration**
config.color_schemes = {
  ['Miasma'] = {
    -- **Primary colors**
    foreground = '#c2c2b0',
    background = '#222222',
    cursor_bg = '#c2c2b0',
    cursor_border = '#c2c2b0',
    cursor_fg = '#222222',
    selection_bg = '#404040',
    selection_fg = '#c2c2b0',

    -- **Normal colors**
    ansi = {
      '#222222', -- black
      '#685742', -- red
      '#5f875f', -- green
      '#b36d43', -- yellow
      '#78824b', -- blue
      '#bb7744', -- magenta
      '#c9a554', -- cyan
      '#d7c483', -- white
    },

    -- **Bright colors**
    brights = {
      '#666666', -- bright black
      '#685742', -- bright red
      '#5f875f', -- bright green
      '#b36d43', -- bright yellow
      '#78824b', -- bright blue
      '#bb7744', -- bright magenta
      '#c9a554', -- bright cyan
      '#d7c483', -- bright white
    },

    -- **Indexed colors**
    indexed = {
      [16] = '#222222',
    },
  },
}

-- **Set the color scheme to Miasma**
config.color_scheme = 'Miasma'

-- **Map vi mode activation to CTRL+,**
config.keys = {
  { key = ',', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
-- Pane management
{ key = 'n', mods = 'CTRL|SHIFT', action = wezterm.action{ SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
{ key = 'm', mods = 'CTRL|SHIFT', action = wezterm.action{ SplitVertical = { domain = 'CurrentPaneDomain' } } },
{ key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action{ ActivatePaneDirection = 'Left' } },
{ key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action{ ActivatePaneDirection = 'Right' } },
{ key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action{ ActivatePaneDirection = 'Up' } },
{ key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action{ ActivatePaneDirection = 'Down' } },
{ key = 'x', mods = 'CTRL|SHIFT', action = wezterm.action{ CloseCurrentPane = { confirm = false } } },
}

-- **Function to activate or create a tab at a given index**
local function activate_or_create_tab(index)
  return function(window, pane)
    local tabs = window:mux_window():tabs()
    if tabs[index] then
      window:perform_action(wezterm.action.ActivateTab(index - 1), pane)
    else
      window:perform_action(wezterm.action.SpawnTab 'DefaultDomain', pane)
      -- Move the new tab to the desired index
      window:perform_action(wezterm.action.MoveTab(index - 1), pane)
      window:perform_action(wezterm.action.ActivateTab(index - 1), pane)
    end
  end
end

-- **Switch between tabs with Alt + numbers, creating if necessary**
for i = 1, 9 do
  local event_name = 'activate-tab-' .. i
  wezterm.on(event_name, activate_or_create_tab(i))
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = wezterm.action.EmitEvent(event_name),
  })
end

-- **ALT+0 to activate or create the 10th tab**
local event_name = 'activate-tab-10'
wezterm.on(event_name, activate_or_create_tab(10))
table.insert(config.keys, {
  key = '0',
  mods = 'ALT',
  action = wezterm.action.EmitEvent(event_name),
})

-- **Optional: Hide the tab bar when only one tab is open**
config.hide_tab_bar_if_only_one_tab = true

return config
