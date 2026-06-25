-- █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █▀▀ █▀▀ █▀
-- █▄█ ▄█ ██▄ █▀▄   █▀▀ █▀▄ ██▄ █▀░ ▄█


hl.config({
  input = {
    -- kb_layout = "us",
    -- follow_mouse = 1,
    -- sensitivity = 0,
    -- force_no_accel = false,
    -- accel_profile = "flat",
    -- numlock_by_default = true,

    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#touchpad
    touchpad = {
      natural_scroll = false,
    },

    repeat_rate = 50,
    repeat_delay = 250,
  },
})

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#gestures
hl.config({
  gestures = {
    -- workspace_swipe = true,
    -- workspace_swipe_fingers = 3,
  },
})

-- for window swallow, similar to "devour"
hl.config({
  misc = {
    -- enable_swallow = true,
    -- swallow_regex = "(foot|kitty|allacritty|Alacritty|ghostty|Ghostty|org.wezfurlong.wezterm)",
  },
})

-- Gruvbox dark: gaps, borders, rounding, shadow
hl.config({
  general = {
    gaps_in  = 5,
    gaps_out = 10,

    border_size = 2,

    col = {
      -- dark gray, focused window just slightly lighter than unfocused
      active_border   = "rgba(665c54ee)",
      -- gruvbox bg1 (darker gray) for inactive
      inactive_border = "rgba(3c3836aa)",
    },
  },

  decoration = {
    rounding       = 4,
    rounding_power = 2,

    active_opacity   = 1.0,
    inactive_opacity = 0.92,

    shadow = {
      enabled = false,
    },
  },
})

-- Don't show update on first launch
hl.config({
  ecosystem = {
    -- no_update_news = true,
  },
})
