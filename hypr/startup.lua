
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("awww-daemon")
end)
hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
end)

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
