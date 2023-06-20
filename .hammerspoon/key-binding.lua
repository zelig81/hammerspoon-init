local wm = require('window-management')
local hk = require "hs.hotkey"

-- * Key Binding Utility
--- Bind hotkey for window management.
-- @function windowBind
-- @param {table} hyper - hyper key set
-- @param { ...{key=value} } keyFuncTable - multiple hotkey and function pairs
--   @key {string} hotkey
--   @value {function} callback function
local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end

-- -- * Move window to screen
-- windowBind(mash.movement, {
--   left = wm.throwLeft,   -- ⌥⌃ + ←
--   right = wm.throwRight  -- ⌥⌃ + →
-- })

-- * Set Window Position on screen
windowBind(mash.resize, {
  m = wm.maximizeWindow,    -- ⌥⌘ + M
  c = wm.centerOnScreen,    -- ⌥⌘ + C
  f = wm.toggleFullscreen,  -- ⌥⌘ + F
  left = wm.leftHalf,       -- ⌥⌘ + ←
  right = wm.rightHalf,     -- ⌥⌘ + →
  up = wm.topHalf,          -- ⌥⌘ + ↑
  down = wm.bottomHalf      -- ⌥⌘ + ↓
})
-- * Set Window Position on screen
windowBind(mash.position, {
  left = wm.rightToLeft,      -- ⌃⌥⇧ + ←
  right = wm.rightToRight,    -- ⌃⌥⇧ + →
  up = wm.bottomUp,           -- ⌃⌥⇧ + ↑
  down = wm.bottomDown        -- ⌃⌥⇧ + ↓
})
-- * Set Window Position on screen
windowBind(mash.place, {
  left = wm.leftToLeft,      -- ⌥⌘⇧ + ←
  right = wm.leftToRight,    -- ⌥⌘⇧ + →
  up = wm.topUp,             -- ⌥⌘⇧ + ↑
  down = wm.topDown          -- ⌥⌘⇧ + ↓
})

-- * Windows-like cycle
windowBind(mash.movement, {
  left = wm.cycleLeft,          -- ⌥⌃ + ←
  right = wm.cycleRight         -- ⌥⌃ + →
})

-- launch and focus applications with below shortkey

hs.fnutils.each({
    { key = "`", app = "iTerm", app_name = "iTerm2" },
    { key = "=", app = "Finder" },
    { key = "b", app = "Brave Browser" },
    { key = "g", app = "Vivaldi" },
    -- { key = "c", app = "muCommander" },
    { key = "d", app = "Dictionary" },
    { key = "e", app = "Telegram" },
    { key = "escape", app = "Activity Monitor" },
    -- { key = "l", app = "LibreOffice" },
    { key = "m", app = "Meld" },
    -- { key = "n", app = "Notion" },
    -- { key = "n", app = "Notes" },
    { key = "o", app = "Opera" },
    -- { key = "p", app = "pgAdmin 4" },
    -- { key = "p", app = "Spotify" },
    -- { key = "r", app = "MySqlWorkbench" },
    { key = "s", app = "Slack" },
    { key = "t", app = "iTerm", app_name = "iTerm2" },
    { key = "v", app = "Visual Studio Code", app_name = "Code" },
    { key = "w", app = "WhatsApp" },
    -- { key = "x", app = "Google Meet" },
    { key = "z", app = "zoom.us", app_name = "Zoom" },
    { key = "4", app = "Skitch", app_name = "Skitch Helper" },
    -- { key = "5", app = "Screenshot" },
}, function(object)
  launchApp(mash.app, object)
end)

hs.hotkey.bind(mash.app, "h", function()
    hs.reload()
end)

hs.hotkey.bind(mash.app, "y", function()
  local running_applications = hs.application.runningApplications()
  print('map app to bunle:' .. serializeTable(running_applications))
  print('list of windows:' .. serializeTable(hs.window.allWindows()))
end)

hs.hotkey.bind(mash.app, "u", function()
  local wf = hs.window.filter.new{'Brave Browser', 'Vivaldi'}
  local filtered_windows = wf:getWindows(hs.window.filter.sortByFocused)
  print('list windows: ' .. serializeTable(filtered_windows))
  local all_spaces = hs.spaces.allSpaces()
  print("all spaces " .. serializeTable(all_spaces))
  -- local myTable = hs.spaces.windowsForSpace(27)
  -- print("my table: " .. serializeTable(myTable))
end)

-- cherry:bindHotkeys({
--   start = {mash.app, "p"}
-- })

-- Switcher for keyboard layouts by numbers
local keymapping_layouts = {}
for k, v in pairs(hs.keycodes.layouts()) do
    keymapping_layouts[tonumber(k)] = {["key"] = tostring(k), ["layout"] = tostring(v)}
end

hs.fnutils.each(keymapping_layouts, function(object)
    setLayout(mash.app, object)
end)
