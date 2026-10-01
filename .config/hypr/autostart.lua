-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	-- hl.exec_cmd("systemctl --user start hyprland-session.target")
	-- hl.exec_cmd("wl-clip-persist --clipboard regular")
	-- hl.exec_cmd("xrandr --output DP-1 --primary")
	-- hl.exec_cmd("udiskie")
	-- hl.exec_cmd("dms run")
	-- hl.exec_cmd("noctalia")
	-- hl.exec_cmd("vicinae server")
	-- hl.exec_cmd("powerprofilesctl set performance")
	-- hl.exec_cmd("hyprctl setcursor breeze_cursors 24")
	-- hl.exec_cmd("wl-paste --watch cliphist store")
	-- hl.exec_cmd("~/.config/hypr/scripts/caffeine-fullscreen.sh")
	hl.exec_cmd("kitty -1 --start-as=hidden")
	-- hl.exec_cmd("foot -s")
	-- hl.exec_cmd("hyprpm reload -n")
	-- hl.exec_cmd("wayle panel start")
	-- hl.exec_cmd("steam")
	-- hl.exec_cmd("nm-applet")
end)

-- hl.on("hyprland.shutdown", function()
-- 	os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
-- end)
