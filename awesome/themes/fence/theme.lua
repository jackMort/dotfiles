--------------------------
-- Edited awesome theme --
---------------------------

theme = {}

theme.font          = "Monospace 6"

theme.bg_normal     = "#05050595"
theme.bg_focus      = "#191919"
theme.bg_urgent     = "#d6d9ba"
theme.bg_minimize   = "#19191995"

theme.fg_normal     = "#d0d0cc"
theme.fg_focus      = "#d6d9ba"
theme.fg_urgent     = "#2c2c2c"
theme.fg_minimize   = "#2c2c2c"

theme.border_width  = "0"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = "~/.config/awesome/themes/fence/taglist/squarefw.png"
theme.taglist_squares_unsel = "~/.config/awesome/themes/fence/taglist/squarew.png"

theme.tasklist_floating_icon = "~/.config/awesome/themes/fence/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "~/.config/awesome/themes/fence/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "~/.config/awesome/themes/fence/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "~/.config/awesome/themes/fence/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "~/.config/awesome/themes/fence/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "~/.config/awesome/themes/fence/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "~/.config/awesome/themes/fence/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "~/.config/awesome/themes/fence/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "~/.config/awesome/themes/fence/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "~/.config/awesome/themes/fence/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "~/.config/awesome/themes/fence/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "~/.config/awesome/themes/fence/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "~/.config/awesome/themes/fence/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "~/.config/awesome/themes/fence/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "~/.config/awesome/themes/fence/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "~/.config/awesome/themes/fence/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "~/.config/awesome/themes/fence/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "~/.config/awesome/themes/fence/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "~/.config/awesome/themes/fence/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "~/.config/awesome/themes/fence/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg /home/jorick/.config/awesome/themes/fence/old_fence.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/themes/fence/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/themes/fence/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/themes/fence/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/themes/fence/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/fence/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/themes/fence/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/fence/layouts/tilebottomw.png"
theme.layout_tileleft   = "~/.config/awesome/themes/fence/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/fence/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/themes/fence/layouts/tiletopw.png"
theme.layout_spiral  = "~/.config/awesome/themes/fence/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/themes/fence/layouts/dwindlew.png"

theme.awesome_icon = "~/.config/awesome/themes/fence/logo20.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
