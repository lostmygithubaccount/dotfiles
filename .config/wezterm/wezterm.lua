local wezterm = require 'wezterm'
local act = wezterm.action

return {
  -- Window: gradient background with opacity
  window_background_gradient = {
    orientation = 'Vertical',
    colors = {
      '#0d0d1a',  -- deep dark at top
      '#1a1a2e',  -- base purple-black
      '#1f1f3d',  -- slightly lighter at bottom
    },
    interpolation = 'Linear',
    blend = 'Rgb',
  },
  -- IMPORTANT: Do not change opacity without explicit user direction
  window_background_opacity = 0.5,

  -- Inactive panes: dim to highlight active pane
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  },

  -- Window padding
  window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  },

  -- Colors: violet/purple + cyan theme
  colors = {
    foreground = '#e0e0ff',
    background = '#1a1a2e',

    cursor_bg = '#87ffff',
    cursor_fg = '#1a1a2e',
    cursor_border = '#87ffff',

    selection_bg = '#af87ff',
    selection_fg = '#1a1a2e',

    split = '#875fff',
    scrollbar_thumb = '#875fff',

    -- Visual bell flash
    visual_bell = '#af87ff',

    -- Copy mode highlighting
    copy_mode_active_highlight_bg = { Color = '#87ffff' },
    copy_mode_active_highlight_fg = { Color = '#1a1a2e' },
    copy_mode_inactive_highlight_bg = { Color = '#875fff' },
    copy_mode_inactive_highlight_fg = { Color = '#ffffff' },

    -- Quick select mode
    quick_select_label_bg = { Color = '#ff5f87' },
    quick_select_label_fg = { Color = '#ffffff' },
    quick_select_match_bg = { Color = '#875fff' },
    quick_select_match_fg = { Color = '#ffffff' },

    ansi = {
      '#1a1a2e',  -- black
      '#ff5f87',  -- red
      '#87ffaf',  -- green
      '#ffff87',  -- yellow
      '#875fff',  -- blue (violet)
      '#af87ff',  -- magenta (purple)
      '#87ffff',  -- cyan
      '#ffffff',  -- white
    },
    brights = {
      '#4a4a5e',  -- bright black
      '#ff87af',  -- bright red
      '#afffcf',  -- bright green
      '#ffffaf',  -- bright yellow
      '#af87ff',  -- bright blue (purple)
      '#d7afff',  -- bright magenta (light purple)
      '#afffff',  -- bright cyan
      '#ffffff',  -- bright white
    },

    tab_bar = {
      background = '#0d0d1a',
      active_tab = {
        bg_color = '#875fff',
        fg_color = '#ffffff',
        intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = '#2a2a4e',
        fg_color = '#a0a0c0',
      },
      inactive_tab_hover = {
        bg_color = '#87ffff',
        fg_color = '#1a1a2e',
        italic = true,
      },
      new_tab = {
        bg_color = '#1a1a2e',
        fg_color = '#87ffff',
      },
      new_tab_hover = {
        bg_color = '#87ffff',
        fg_color = '#1a1a2e',
        intensity = 'Bold',
      },
    },
  },

  -- Fancy tab bar styling
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,
  window_frame = {
    font_size = 12.0,
    active_titlebar_bg = '#0d0d1a',
    inactive_titlebar_bg = '#0d0d1a',
  },

  -- Keybindings
  keys = {
    -- Split panes
    { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Navigate panes
    { key = 'h', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },

    -- Cycle panes
    { key = '[', mods = 'CMD', action = act.ActivatePaneDirection 'Prev' },
    { key = ']', mods = 'CMD', action = act.ActivatePaneDirection 'Next' },

    -- Swap panes (interactive: shows labels to pick which pane to swap with)
    { key = '[', mods = 'CMD|OPT', action = act.PaneSelect { mode = 'SwapWithActive' } },
    { key = ']', mods = 'CMD|OPT', action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' } },

    -- Close pane
    { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },

    -- Toggle pane zoom (fullscreen focused pane)
    { key = 'Return', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  },
}
