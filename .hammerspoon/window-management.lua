-- -----------------------------------------------------------------------
--                         ** Something Global **                       --
-- -----------------------------------------------------------------------

-- todo: try to use the following
-- https://www.hammerspoon.org/docs/hs.spaces.html#allSpaces
-- https://www.hammerspoon.org/docs/hs.layout.html#maximized

-- function toggleFullscreen()
--   appwindow = hs.window.frontmostWindow()
--   appwindow:toggleFullScreen()
-- end

-- Comment out this following line if you wish to see animations
local windowMeta = {}
window = require "hs.window"
hs.window.animationDuration = 0
grid = require "hs.grid"
grid.setMargins('0, 0')

module = {}

-- Set screen watcher, in case you connect a new monitor, or unplug a monitor
screens = {}
screenArr = {}
local screenwatcher = hs.screen.watcher.new(function()
  screens = hs.screen.allScreens()
end)
screenwatcher:start()

-- Construct list of screens
indexDiff = 0
for index=1,#hs.screen.allScreens() do
  local xIndex,yIndex = hs.screen.allScreens()[index]:position()
  screenArr[xIndex] = hs.screen.allScreens()[index]
end

-- Find lowest screen index, save to indexDiff if negative
hs.fnutils.each(screenArr, function(e)
  local currentIndex = hs.fnutils.indexOf(screenArr, e)
  if currentIndex < 0 and currentIndex < indexDiff then
    indexDiff = currentIndex
  end
end)

-- Set screen grid depending on resolution
  -- TODO: set grid according to pixels
for _index,screen in pairs(hs.screen.allScreens()) do
  if screen:frame().w / screen:frame().h > 2 then
    -- 10 * 4 for ultra wide screen
    grid.setGrid('10 * 4', screen)
  else
    if screen:frame().w < screen:frame().h then
      -- 4 * 8 for vertically aligned screen
      grid.setGrid('4 * 8', screen)
    else
      -- 8 * 4 for normal screen
      grid.setGrid('8 * 4', screen)
    end
  end
end

-- Some constructors, just for programming
function Cell(x, y, w, h)
  return hs.geometry(x, y, w, h)
end

-- Bind new method to windowMeta
function windowMeta.new()
  if is_debug == true then print("--- windowMeta.new()") end
  local self = setmetatable(windowMeta, {
    -- Treate table like a function
    -- Event listener when windowMeta() is called
    __call = function (cls, ...)
      return cls.new(...)
    end,
  })

  self.window = window.focusedWindow()
  self.screen = window.focusedWindow():screen()
  self.windowGrid = grid.get(self.window)
  self.screenGrid = grid.getGrid(self.screen)

  return self
end

-- -----------------------------------------------------------------------
--                   ** ALERT: GEEKS ONLY, GLHF  :C **                  --
--            ** Keybinding configurations locate at bottom **          --
-- -----------------------------------------------------------------------

module.maximizeWindow = function ()
  if is_debug == true then print("--- module.maximizeWindow") end
  local this = windowMeta.new()
  grid.maximizeWindow(this.window)
end

module.toggleFullscreen = function ()
  if is_debug == true then print("--- module.toggleFullscreen") end
  local this = windowMeta.new()
  this.window:toggleFullScreen()
end

module.centerOnScreen = function ()
  if is_debug == true then print("--- module.centerOnScreen") end
  local this = windowMeta.new()
  this.window:centerOnScreen(this.screen)
end

-- module.throwLeft = function ()
--   if is_debug == true then print("--- module.throwLeft") end
--   local this = windowMeta.new()
--   this.window:moveOneScreenWest(true, true)
-- end

-- module.throwRight = function ()
--   if is_debug == true then print("--- module.throwRight") end
--   local this = windowMeta.new()
--   this.window:moveOneScreenEast(true, true)
-- end

module.leftHalf = function ()
  if is_debug == true then print("--- module.leftHalf") end
  local this = windowMeta.new()
  local cell = Cell(0, 0, 0.5 * this.screenGrid.w, this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
  -- this.window.setShadows(true) #does not work
end

module.rightHalf = function ()
  if is_debug == true then print("--- module.rightHalf") end
  local this = windowMeta.new()
  local cell = Cell(0.5 * this.screenGrid.w, 0, 0.5 * this.screenGrid.w, this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

-- Windows-like cycle left
module.cycleLeft = function ()
  if is_debug == true then print("--- module.cycleLeft") end
  local this = windowMeta.new()
  -- Check if this window is on left or right
  if this.windowGrid.x == 0 then
    local currentIndex = hs.fnutils.indexOf(screenArr, this.screen)
    local newIndex = (currentIndex - indexDiff - 1) % #hs.screen.allScreens() + indexDiff
    local previousScreen = screenArr[newIndex]
    print("module.cycleLeft: \ncurrentIndex " .. currentIndex .. "\nindexDiff " .. indexDiff .. "\ncount of screens: " .. #hs.screen.allScreens() .. "\nnewIndex " .. newIndex)
    -- start workaround for WebKit based applications moveToScreen issue
    local axApp = hs.axuielement.applicationElement(this.window:application())
    local wasEnhanced = axApp.AXEnhancedUserInterface
    if wasEnhanced and is_browser[this.window:application():name()] then
      axApp.AXEnhancedUserInterface = false
    end
    -- moveToScreen itself
    local wasFullScreen = this.window:isFullScreen()
    if wasFullScreen then
      this.window:setFullScreen(false)
    end
    this.window:moveToScreen(previousScreen)
    if wasFullScreen then
      this.window:setFullScreen(true)
    else
      grid.maximizeWindow(this.window)
    end
    -- second part of the workaround
    if wasEnhanced and is_browser[this.window:application():name()] then
      axApp.AXEnhancedUserInterface = true
    end
    -- end of the workaround
  end
end

-- Windows-like cycle right
module.cycleRight = function ()
  if is_debug == true then print("--- module.cycleRight") end
  local this = windowMeta.new()
  -- Check if this window is on left or right
  if this.windowGrid.x == 0 then
  --   module.rightHalf()
  -- else
    local currentIndex = hs.fnutils.indexOf(screenArr, this.screen)
    local newIndex = (currentIndex - indexDiff + 1) % #hs.screen.allScreens() + indexDiff
    local nextScreen = screenArr[newIndex]
    print("module.cycleLeft: \ncurrentIndex " .. currentIndex .. "\nindexDiff " .. indexDiff .. "\ncount of screens: " .. #hs.screen.allScreens() .. "\nnewIndex " .. newIndex)
    -- start workaround for WebKit based applications moveToScreen issue
    local axApp = hs.axuielement.applicationElement(this.window:application())
    local wasEnhanced = axApp.AXEnhancedUserInterface
    if wasEnhanced and is_browser[this.window:application():name()] then
      axApp.AXEnhancedUserInterface = false
    end
    -- moveToScreen itself
    local wasFullScreen = this.window:isFullScreen()
    if wasFullScreen then
      this.window:setFullScreen(false)
    end
    this.window:moveToScreen(nextScreen, true)
    if wasFullScreen then
      this.window:setFullScreen(true)
    else
      grid.maximizeWindow(this.window)
    end
    -- second part of the workaround
    if wasEnhanced and is_browser[this.window:application():name()] then
      axApp.AXEnhancedUserInterface = false
    end
    -- end of the workaround
  end
end

module.topHalf = function ()
  if is_debug == true then print("--- module.topHalf") end
  local this = windowMeta.new()
  local cell = Cell(0, 0, this.screenGrid.w, 0.5 * this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

module.bottomHalf = function ()
  if is_debug == true then print("--- module.bottomHalf") end
  local this = windowMeta.new()
  local cell = Cell(0, 0.5 * this.screenGrid.h, this.screenGrid.w, 0.5 * this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

module.rightToLeft = function ()
  if is_debug == true then print("--- module.rightToLeft") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y, this.windowGrid.w - 1, this.windowGrid.h)
  if this.windowGrid.w > 1 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Small Enough :)")
  end
end

module.rightToRight = function ()
  if is_debug == true then print("--- module.rightToRight") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y, this.windowGrid.w + 1, this.windowGrid.h)
  if this.windowGrid.w < this.screenGrid.w - this.windowGrid.x then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Touching Right Edge :|")
  end
end

module.bottomUp = function ()
  if is_debug == true then print("--- module.bottomUp") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y, this.windowGrid.w, this.windowGrid.h - 1)
  if this.windowGrid.h > 1 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Small Enough :)")
  end
end

module.bottomDown = function ()
  if is_debug == true then print("--- module.bottomDown") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y, this.windowGrid.w, this.windowGrid.h + 1)
  if this.windowGrid.h < this.screenGrid.h - this.windowGrid.y then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Touching Bottom Edge :|")
  end
end

module.leftToLeft = function ()
  if is_debug == true then print("--- module.leftToLeft") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x - 1, this.windowGrid.y, this.windowGrid.w + 1, this.windowGrid.h)
  if this.windowGrid.x > 0 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Touching Left Edge :|")
  end
end

module.leftToRight = function ()
  if is_debug == true then print("--- module.leftToRight") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x + 1, this.windowGrid.y, this.windowGrid.w - 1, this.windowGrid.h)
  if this.windowGrid.w > 1 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Small Enough :)")
  end
end

module.topUp = function ()
  if is_debug == true then print("--- module.topUp") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y - 1, this.windowGrid.w, this.windowGrid.h + 1)
  if this.windowGrid.y > 0 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Touching Top Edge :|")
  end
end

module.topDown = function ()
  if is_debug == true then print("--- module.topDown") end
  local this = windowMeta.new()
  local cell = Cell(this.windowGrid.x, this.windowGrid.y + 1, this.windowGrid.w, this.windowGrid.h - 1)
  if this.windowGrid.h > 1 then
    grid.set(this.window, cell, this.screen)
  else
    hs.alert.show("Small Enough :)")
  end
end

return module
