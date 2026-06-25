
local mainMod  = "SUPER"
local TERMINAL = "kitty"
local EDITOR   = "code"
local EXPLORER = "thunar"
local BROWSER  = "firefox"

-- floating-aware window move (mirrors original $moveactivewindow)
local function moveActiveWindowCmd(dx, dy, dispatchDir)
  return string.format(
    'grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive %s || hyprctl dispatch movewindow %s',
    dx .. " " .. dy, dispatchDir
  )
end

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + K", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())


-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))


-- Move/resize with mouse
hl.bind(mainMod .. " + Z", hl.dsp.window.drag())
hl.bind(mainMod .. " + X", hl.dsp.window.resize())
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Launcher apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(TERMINAL))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(EDITOR))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(BROWSER))

-- Rofi menus
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("sh ~/.config/rofi/launcher/launcher.sh"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("sh ~/.config/rofi/window/window.sh"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("sh ~/.config/rofi/search/search.sh"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("bash -c 'cliphist list | rofi -dmenu -theme ~/.config/rofi/cliphist.rasi -display-columns 2 | cliphist decode | wl-copy'"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("python ~/.config/hypr/scripts/wallpaper.py"))
hl.bind(mainMod .. " + SHIFT+ L", hl.dsp.exec_cmd("sh ~/.config/wofi/powermenu.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))


-- Audio (wpctl, capped at 100% via -l 1.0; locked = works through lockscreen)
hl.bind("F10", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("F11", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("F12", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness (brightnessctl; may need: sudo usermod -aG video $USER)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })


-- Screen capture
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + CONTROL + P", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grimblast --freeze copy area"))

-- Workspaces: switch
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + CONTROL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CONTROL + down", hl.dsp.focus({ workspace = "empty" }))

-- Workspaces: move window to
for i = 1, 9 do
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + CONTROL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }))

-- Workspaces: scroll to switch
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special", silent = true }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special())

-- Workspaces: move window silently
for i = 1, 9 do
  hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i, silent = true }))
end
hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10, silent = true }))

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
