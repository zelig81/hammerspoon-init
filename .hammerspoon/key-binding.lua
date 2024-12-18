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
    -- { key = "a", app = "Arc" },
    { key = "b", app = "Brave Browser" },
    -- { key = "g", app = "Arc" },
    -- { key = "g", app = "Vivaldi" },
    { key = "g", app = "Firefox" },
    -- { key = "c", app = "muCommander" },
    { key = "d", app = "Reverso" },
    { key = "e", app = "Telegram" },
    { key = "escape", app = "Activity Monitor" },
    -- { key = "l", app = "LibreOffice" },
    { key = "m", app = "KDiff3" },
    { key = "n", app = "Notion" },
    -- { key = "n", app = "Notes" },
    -- { key = "o", app = "Opera" },
    -- { key = "p", app = "pgAdmin 4" },
    { key = "p", app = "Spotify" },
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

-- replacement function
hs.hotkey.bind(mash.app, "r", function()
  hs.eventtap.keyStroke({"cmd"}, "c")
  local current_content = hs.pasteboard.getContents()
  print('current content: [' .. current_content .. ']')
  -- local js = 'node replacer.js'
  -- local handle = io.popen(js)
  -- handle:close()


  -- current_content = string.gsub(current_content, "(.)Content", "!%1CONTENT")
  -- current_content = string.gsub(current_content, "job=\"$job\"", "app=\"$app\"")
  current_content = string.lower(current_content)
  print('new content: [' .. current_content .. ']')
  hs.pasteboard.setContents(current_content)
  hs.eventtap.keyStroke({"cmd"}, "v")
end)
hs.hotkey.bind(mash.app, "y", function()
  hs.spotify.displayCurrentTrack()

  hs.task.new("/usr/local/bin/dash", function(_code, stdout, stderr)
    callback(stdout)
  end, {cmd, args}):start():waitUntilExit()

  -- NOTE: timer.waitUntil is like 'await' in javascript
  hs.timer.waitUntil(winIdxIsSet, function() return data end)

  -- Checker func to confirm that win.stackIdx is set
  -- For hs.timer.waitUntil
  -- NOTE: Temporarily using hs.task:waitUntilExit() to accomplish the
  -- same thing
  function winIdxIsSet()
    if win.stackIdx ~= nil then
        return true
    end
  end
  local handle = io.popen('pgrep -l -f "sh /Users/ilya/MuteSpotifyAds/NoAdsSpotify.sh"')
  local stdout = handle:read()
  print("result of command: " .. stdout)
  local success = handle:close()

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
