local terminal = "uwsm app -- kitty -1"
local fileManager = " uwsm app -- nautilus"
local browser = "uwsm app -- helium"
-- local browser = "helium"
-- local browser = "brave-origin-nightly"
local launcher = "vicinae toggle"
-- local launcher = "noctalia msg panel-toggle launcher"
-- local launcher = "pkill fuzzel || fuzzel"
local clipboard = "vicinae vicinae://close || vicinae vicinae://launch/clipboard/history"
-- local clipboard = "noctalia msg panel-toggle clipboard"
local configLister = "vicinae vicinae://close || ~/.config/noctalia/config-lister.sh"
-- local clipboard =
-- 	"pkill fuzzel || cliphist list | perl -C0 -pe '/[\\x00-\\x08]/ and s/\\t.*/\\t[image]/' | fuzzel --dmenu --with-nth=2 | cliphist decode | wl-copy -n && wtype -M ctrl v -m ctrl"

local Super = "SUPER"
local Hyper = "CTRL + ALT + SUPER"

hl.bind(Super .. " + C", hl.dsp.exec_cmd(configLister))
hl.bind(Hyper .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + F4", hl.dsp.window.close(), { repeating = true })
-- hl.bind(
-- 	Super .. " + M",
-- 	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- )
hl.bind(Hyper .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(Hyper .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(Hyper .. " + S", hl.dsp.exec_cmd("vicinae vicinae://close || vicinae vicinae://launch/@leiserfg/ssh/ssh"))
hl.bind(
	Hyper .. " + P",
	hl.dsp.exec_cmd("vicinae vicinae://close || vicinae vicinae://launch/@the_revolution/mpv-launcher/mpv-launcher")
	-- hl.dsp.exec_cmd("~/.config/noctalia/mpv-launcher.sh")
	-- hl.dsp.exec_cmd("pkill fuzzel || /home/rv/.config/fuzzel/scripts/mpv-launcher.sh")
)
-- hl.bind("ALT + TAB", hl.dsp.exec_cmd("vicinae vicinae://close || vicinae vicinae://launch/wm/switch-windows"))
hl.bind(Hyper .. " + R", hl.dsp.exec_cmd("vicinae vicinae://close || vicinae vicinae://launch/snippets/manage"))
hl.bind(Super .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(Super .. " + CTRL + F", function()
	local window = hl.get_active_window()
	hl.dispatch(hl.dsp.window.fullscreen({
		mode = window and window.class:match("foot") and "maximized" or "fullscreen",
	}))
end)
hl.bind(Super .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(Super .. " + semicolon", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(Hyper .. " + F", hl.dsp.exec_cmd(launcher))
hl.bind(Hyper .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(Super .. " + P", hl.dsp.window.pseudo())
hl.bind(Super .. " + CTRL + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with Super + arrow keys
hl.bind(Super .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(Super .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + S", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + W", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + A", hl.dsp.layout("focus l"), { repeating = true })
hl.bind("ALT + D", hl.dsp.layout("focus r"), { repeating = true })
hl.bind("SUPER + W", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + S", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
-- Move windows with Super + ALT + h/j/k/l
hl.bind("ALT + CTRL + W", hl.dsp.window.move({ direction = "up" }))
-- hl.bind(Super .. " + ALT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + CTRL + S", hl.dsp.window.move({ direction = "down" }))
-- hl.bind(Super .. " + ALT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("ALT + CTRL + A", hl.dsp.layout("swapcol l"))
hl.bind("ALT + CTRL + D", hl.dsp.layout("swapcol r"))
-- Switch workspaces with Super + [0-9]
-- Move active window to a workspace with Super + SHIFT + [0-9]
-- for i = 1, 10 do
-- 	local key = i % 10 -- 10 maps to key 0
-- 	hl.bind("ALT + " .. key, hl.dsp.focus({ workspace = i }))
-- 	hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
local function get_sorted_monitors()
	local monitors = hl.get_monitors()
	table.sort(monitors, function(first, second)
		return first.x < second.x
	end)
	return monitors
end

local function warp_cursor_to_monitor(monitor)
	hl.dispatch(hl.dsp.cursor.move({
		x = monitor.x + monitor.width / 2,
		y = monitor.y + monitor.height / 2,
	}))
end

local function focus_and_warp(monitor_index)
	return function()
		local monitor = get_sorted_monitors()[monitor_index]
		if monitor == nil then
			return
		end
		hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
		warp_cursor_to_monitor(monitor)
	end
end

local function move_window_to_monitor(monitor_index)
	return function()
		local monitor = get_sorted_monitors()[monitor_index]
		if monitor == nil then
			return
		end
		hl.dispatch(hl.dsp.window.move({ monitor = monitor.name }))
	end
end

hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind("SUPER + 1", focus_and_warp(1))
hl.bind("SUPER + 2", focus_and_warp(2))
hl.bind("SUPER + CTRL + 1", move_window_to_monitor(1))
hl.bind("SUPER + CTRL + 2", move_window_to_monitor(2))

local function focus_workspace(ws)
	hl.dispatch(hl.dsp.focus({ workspace = ws }))

	for _, workspace in ipairs(hl.get_workspaces()) do
		if tonumber(workspace.id) == ws then
			local mon = hl.get_monitor(workspace.monitor)
			if mon then
				hl.dispatch(hl.dsp.cursor.move({
					x = mon.x + mon.width / 2,
					y = mon.y + mon.height / 2,
				}))
			end
			break
		end
	end
end

for i = 1, 10 do
	local key = i % 10
	hl.bind("ALT + " .. key, function()
		focus_workspace(i)
	end)
	hl.bind("ALT + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(Super .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(Super .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with Super + scroll
hl.bind(Super .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(Super .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with Super + LMB/RMB and dragging
hl.bind(Super .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(Super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + comma", hl.dsp.layout("consume_or_expel prev"))
hl.bind("ALT + period", hl.dsp.layout("consume_or_expel next"))
-- hl.bind("SUPER + S", function()
-- 	hl.plugin.hyprcapture.open()
-- end)
--
-- hl.bind("SUPER + SHIFT + S", function()
-- 	hl.plugin.hyprcapture.open("window")
-- end)

-- hl.bind(
-- 	"SUPER + S",
-- 	hl.dsp.exec_cmd(
-- 		[[hyprctl clients -j | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -c '#00e993ff' -w 2 | xargs -I{} grim -g "{}" - | tensaku --filename -]]
-- 	)
-- )
hl.bind("CTRL + SHIFT + 1", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("CTRL + SHIFT + 2", hl.dsp.exec_cmd("record video"))
hl.bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd("record gif"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("wl-paste -t image/png | tensaku -f -"))
hl.bind("CTRL + SUPER + S", hl.dsp.exec_cmd("noctalia msg plugin noctalia/screen_recorder:service all toggle"))
