--[[

     Awesome WM configuration template
     github.com/lcpz
     modified by
     github.com/Joshua-Hwang

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
local cyclefocus    = require('cyclefocus')

local markup = lain.util.markup
local separators = lain.util.separators
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "urxvtd", "unclutter -root" }) -- entries must be separated by commas

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "urxvt"
local floating_terminal = "urxvt -name floating"
local editor       = os.getenv("EDITOR") or "vim"
local gui_editor   = "gvim"
local browser      = "firefox"
local guieditor    = "gvim"
local scrlocker    = "physlock"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    --awful.button({ }, 2, function (c) c:kill() end), -- dangerous
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        -- No borders with only one humanly visible client
        if c.maximized then
          -- NOTE: also handled in focus, but that does not cover maximizing from a
          -- tiled state (when the client had focus).
          c.border_width = 0
        elseif layout == "max" or layout == "fullscreen" then
          c.border_width = 0
        else
          local tiled = awful.client.tiled(c.screen)
          if #tiled == 1 then -- and c == tiled[1] then
            tiled[1].border_width = 0
            -- if layout ~= "max" and layout ~= "fullscreen" then
            -- XXX: SLOW!
            -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
            -- end
          else
            c.border_width = beautiful.border_width
          end
        end
        --[[
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
        --]]
    end
end)

-- Textclock
local clockicon = wibox.widget.imagebox(beautiful.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(beautiful.font, stdout))
    end
)

-- Calendar
local cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = beautiful.font,
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- MEM
local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        local cpucolor = beautiful.fg_normal
        if tonumber(cpu_now.usage) >= 90 then
            cpucolor = beautiful.fg_panic
        elseif tonumber(cpu_now.usage) >= 75 then
            cpucolor = beautiful.fg_alarm
        end
        widget:set_markup("<span color=\"" .. cpucolor .."\">"
            .. markup.font(beautiful.font, " " .. cpu_now.usage .. "% ")
            .. "</span>")
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        local tempcolor = beautiful.fg_normal
        if tonumber(coretemp_now) >= 65 then
            tempcolor = beautiful.fg_panic
        elseif tonumber(coretemp_now) >= 60 then
            tempcolor = beautiful.fg_alarm
        end
        widget:set_markup("<span color=\"" .. tempcolor .."\">"
            .. markup.font(beautiful.font, " " .. coretemp_now .. "°C ")
            .. "</span>")
    end
})

-- / fs
local fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fs = lain.widget.fs({
    notification_preset = { fg = beautiful.fg_normal, bg = beautiful.bg_normal, font = beautiful.font },
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. fs_now["/"].percentage .. "% "))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(beautiful.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            local batcolor = beautiful.fg_normal
            if bat_now.status ~= "Discharging" then
                baticon:set_image(beautiful.widget_ac)
            elseif bat_now.perc and tonumber(bat_now.perc) <= 10 then
                batcolor = beautiful.fg_panic
                baticon:set_image(beautiful.widget_battery_empty)
            elseif bat_now.perc and tonumber(bat_now.perc) <= 25 then
                batcolor = beautiful.fg_alarm
                baticon:set_image(beautiful.widget_battery_low)
            else
                batcolor = beautiful.base0C
                baticon:set_image(beautiful.widget_battery)
            end
            widget:set_markup("<span color=\"" .. batcolor .."\">"
                .. markup.font(beautiful.font, " " .. bat_now.perc .. "% ")
                .. "</span>")
        else
            widget:set_markup(markup.font(beautiful.font, " AC "))
            baticon:set_image(beautiful.widget_ac)
        end
    end
})

-- Pulse (note there is a concurrency issue with spawning a shell then
-- updating haven't bothered to try and fix)
local volicon = wibox.widget.imagebox(beautiful.widget_vol_low)
local volume = lain.widget.pulse({
    settings = function()
        local volcolor = beautiful.fg_normal
        local volavg = (tonumber(volume_now.left) + tonumber(volume_now.right))/2
        vlevel = volume_now.left .. "-" .. volume_now.right .. "% | " .. volume_now.device

        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
            volcolor = beautiful.bg_normal
            volicon:set_image(beautiful.widget_vol_mute)
        elseif volavg > 100 then
            volcolor = beautiful.fg_alarm
            volicon:set_image(beautiful.widget_vol)
        elseif volavg <= 1  then
            volcolor = beautiful.bg_normal
            volicon:set_image(beautiful.widget_vol_no)
        else
            volicon:set_image(beautiful.widget_vol_low)
        end

        widget:set_markup("<span color=\"" .. volcolor .. "\">"
            .. markup.font(beautiful.font, " " .. vlevel .. " ")
            .. "</span>")
    end
})
volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn.with_shell(string.format("pactl set-sink-mute %d toggle", volume.device))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn.with_shell(string.format("pactl set-sink-volume %d +1%%", volume.device))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn.with_shell(string.format("pactl set-sink-volume %d -1%%", volume.device))
        volume.update()
    end)
))
-- }}}

-- Separators
local spr     = wibox.widget.textbox(' ')
local arrl_ld = separators.arrow_left(beautiful.bg_focus, "alpha")
local arrl_dl = separators.arrow_left("alpha", beautiful.bg_focus)
local arrr_ld = separators.arrow_right(beautiful.bg_focus, "alpha")
local arrr_dl = separators.arrow_right("alpha", beautiful.bg_focus)

-- Create a wibox for each screen and add it
-- awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
awful.screen.connect_for_each_screen(function(s)
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(s.mytaglist, beautiful.bg_focus),
            arrr_ld,
            spr,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            spr,
            arrl_dl,
            wibox.container.background(volicon, beautiful.bg_focus),
            wibox.container.background(volume.widget, beautiful.bg_focus),
            arrl_ld,
            memicon,
            mem.widget,
            spr,
            cpuicon,
            cpu.widget,
            spr,
            tempicon,
            temp.widget,
            arrl_dl,
            wibox.container.background(baticon, beautiful.bg_focus),
            wibox.container.background(bat.widget, beautiful.bg_focus),
            arrl_ld,
            spr,
            wibox.widget.systray(),
            spr,
            arrl_dl,
            wibox.container.background(clock, beautiful.bg_focus),
            wibox.container.background(spr, beautiful.bg_focus),
            arrl_ld,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    --awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({         }, "Print", function() awful.spawn.with_shell("/usr/bin/i3-scrot -d") end,
              {description = "take a screenshot", group = "screenshot"}),
    awful.key({"Control"}, "Print", function () awful.spawn.with_shell("/usr/bin/i3-scrot -w")   end,
              {description = "capture a screenshot of active window", group = "screenshot"}),
    awful.key({"Shift"  }, "Print", function () awful.spawn.with_shell("/usr/bin/i3-scrot -s")   end,
              {description = "capture a screenshot of selection", group = "screenshot"}),

    -- X screen locker
    awful.key({ altkey, "Control" }, "l", function () os.execute(scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    -- Note: remove modkey if errors
    awful.key({ modkey, altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view previous nonempty", group = "tag"}),
    awful.key({ modkey, altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)  end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)  end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
--[[ Used to cycle windows previously see clientkeys for the cyclefocus solution
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            -- awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
--]]

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "z", function () awful.spawn(floating_terminal) end,
              {description = "open a floating terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "Escape", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    --[[ I think these are useless
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    --]]
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    --[[ Overrides the floating
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    --]]

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    --[[ Using this for floating terminal
    awful.key({ modkey }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),
    --]]

    -- Widgets popups
    awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.spawn.with_shell("xbacklight -inc 1")
            --awful.spawn.with_shell("notify-send \"Backlight: $(xbacklight -get)\"")
        end,
        {description = "+1%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.spawn.with_shell("xbacklight -dec 1")
            --awful.spawn.with_shell("notify-send \"Backlight: $(xbacklight -get)\"")
        end,
        {description = "-1%", group = "hotkeys"}),

    -- PulseAudio volume control
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +1000")
            volume.update()
            --awful.spawn("pavolume show")
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -1000")
            volume.update()
            --awful.spawn("pavolume show")
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
            volume.update()
            --awful.spawn("pavolume show")
        end,
        {description = "toggle mute", group = "hotkeys"}),

    -- Prompt
    awful.key({ modkey }, "r",
        function ()
            --awful.screen.focused().mypromptbox:run()
            cmdmsg = "bemenu-run"
            cmdmsg = cmdmsg .. " --fn '" .. beautiful.menu_font .. "'"
            cmdmsg = cmdmsg .. " --tb '" .. beautiful.bg_focus .. "'"
            cmdmsg = cmdmsg .. " --tf '" .. beautiful.fg_focus .. "'"
            cmdmsg = cmdmsg .. " --fb '" .. beautiful.bg_normal .. "'"
            cmdmsg = cmdmsg .. " --ff '" .. beautiful.fg_normal .. "'"
            cmdmsg = cmdmsg .. " --nb '" .. beautiful.bg_normal .. "'"
            cmdmsg = cmdmsg .. " --nf '" .. beautiful.fg_normal .. "'"
            cmdmsg = cmdmsg .. " --hb '" .. beautiful.border_focus .. "'"
            cmdmsg = cmdmsg .. " --hf '" .. beautiful.bg_normal .. "'"
            awful.spawn(cmdmsg)
        end,
        {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "semicolon",
        function ()
            --awful.screen.focused().mypromptbox:run()
            cmdmsg = "bemenu-run"
            cmdmsg = cmdmsg .. " --fn '" .. beautiful.menu_font .. "'"
            cmdmsg = cmdmsg .. " --tb '" .. beautiful.bg_focus .. "'"
            cmdmsg = cmdmsg .. " --tf '" .. beautiful.fg_focus .. "'"
            cmdmsg = cmdmsg .. " --fb '" .. beautiful.bg_normal .. "'"
            cmdmsg = cmdmsg .. " --ff '" .. beautiful.fg_normal .. "'"
            cmdmsg = cmdmsg .. " --nb '" .. beautiful.bg_normal .. "'"
            cmdmsg = cmdmsg .. " --nf '" .. beautiful.fg_normal .. "'"
            cmdmsg = cmdmsg .. " --hb '" .. beautiful.border_focus .. "'"
            cmdmsg = cmdmsg .. " --hf '" .. beautiful.bg_normal .. "'"
            awful.spawn(cmdmsg)
        end,
        {description = "run prompt", group = "launcher"})
)

clientkeys = my_table.join(
    --[[ Don't think magnify is useful
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    --]]
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),
    cyclefocus.key({ altkey, }, "Tab", {
        cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
        keys = {'Tab', 'ISO_Left_Tab'}
    })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    --[[ Just deal with it
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    --]]
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey, "Shift" }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    --[[ Titlebars are default no
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },
    --]]

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "floating",
          "matplotlib",
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "matplotlib",
         },
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, titlebars_enabled = true }},

    -- Set Firefox to always map on the first tag on screen 1.
    --[[ No thank you
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = awful.util.tagnames[1] } },
    --]]

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end)
        --[[ I press these buttons on accident too much
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
        --]]
    )

    awful.titlebar(c, {size = dpi(16)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter")
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("property::floating", function (c)
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}
