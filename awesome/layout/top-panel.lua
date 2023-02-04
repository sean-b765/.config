local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local TagList = require('widget.tag-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')
local battery_widget = require('widget.battery')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')

-- Horizontal Tray
beautiful.systray_icon_spacing = 20
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(24)
systray.forced_height = 24

-- Clock / Calendar 12AM/PM fornat
local textclock = wibox.widget.textclock('<span font="JetBrains Mono 12">%I:%M %p</span>')
--textclock.forced_height = 36

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
    screen = s,
    start_sunday = false,
    week_numbers = true
})
month_calendar:attach(textclock)

local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(9), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(
gears.table.join(
awful.button(
{},
1,
nil,
function()
    awful.spawn(
    awful.screen.focused().selected_tag.defaultApp,
    {
        tag = _G.mouse.screen.selected_tag,
        placement = awful.placement.bottom_right
    }
    )
end
)
)
)

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
    awful.util.table.join(
    awful.button(
    {},
    1,
    function()
        awful.layout.inc(1)
    end
    ),
    awful.button(
    {},
    3,
    function()
        awful.layout.inc(-1)
    end
    ),
    awful.button(
    {},
    4,
    function()
        awful.layout.inc(1)
    end
    ),
    awful.button(
    {},
    5,
    function()
        awful.layout.inc(-1)
    end
    )
    )
    )
    return layoutBox
end

local TopPanel = function(s)

    local panel =
    wibox(
    {
        opacity = 0.75,
        ontop = true,
        screen = s,
        height = dpi(32),
        width = s.geometry.width - 20,
        x = 10,
        y = 10,
        stretch = false,
        bg = beautiful.background.hue_800,
        fg = beautiful.fg_normal,
        struts = {
            top = dpi(32)
        }
    }
    )

    panel:struts(
    {
        top = dpi(32)
    }
    )

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            -- Create a taglist widget
            TagList(s),
            TaskList(s)
            -- (+) Add window button
            --add_button
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.margin(systray, dpi(4), dpi(50), dpi(6), dpi(0)),
            battery_widget,
            -- Layout box (switches between tiling, floating, etc. modes)
            --LayoutBox(s),
            -- Clock
            clock_widget,
        }
    }

    return panel
end

return TopPanel
