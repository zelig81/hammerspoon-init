-- -----------------------------------------------------------------------
--           ** HammerSpoon Config File by S1ngS1ng with ❤️ **           --
--               https://github.com/S1ngS1ng/HammerSpoon                --
--           https://github.com/danshan/hammerspoon-config              --
-- -----------------------------------------------------------------------

--   ***   Please refer to README.MD for instructions. Cheers!    ***   --

-- -----------------------------------------------------------------------
--                         ** Something Global **                       --
-- -----------------------------------------------------------------------
logger = hs.logger.new("config", "verbose")

-- cherry = hs.loadSpoon("Cherry")
-- ad = hs.loadSpoon("ArrangeDesktop")
-- ad.createArrangement()
-- arrangements = ad._loadConfiguration()
-- hs.alert.show('arrangements ' .. arrangements)
-- arrangements
-- ad.arrange(arrangements)
-- ad.addMenuItems()
-- ad._writeConfiguration()

hs.alert.defaultStyle.strokeColor = { white = 0, alpha = 0.75 }
hs.alert.defaultStyle.textSize = 25

-- Comment this following line if you wish to see animations
hs.window.animationDuration = 0
hs.window.setShadows(false)

hs.application.enableSpotlightForNameSearches(true)

mash = {
  app = { "alt" },                    -- ⌥
  movement = { "alt", "ctrl" },       -- ⌥⌃
  resize = { "alt", "cmd" },          -- ⌥⌘
  place = { "alt", "cmd", "shift" },  -- ⌥⌘⇧
  position ={"ctrl", "alt", "shift"}  -- ⌃⌥⇧
}
exit_from_full_screen = false
is_debug = true
force_refresh_on_space_change = true
-- -----------------------------------------------------------------------
--                            ** Requires **                            --
-- -----------------------------------------------------------------------

require("helpers")
require("window-management")
require("apps")
require("key-binding")

is_browser = Set {'Brave Browser', 'Vivaldi', 'Google Meet', 'Opera', 'Google Chrome', 'Firefox', 'Safari', 'Arc'}
hs.alert.show('Hammerspoon config reload')
