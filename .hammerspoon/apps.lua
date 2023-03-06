function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
      tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

      for k, v in pairs(val) do
          tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
      end

      tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
      tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
      tmp = tmp .. string.format("%q", val)
  elseif type(val) == "userdata" then
      tmp = tmp .. tostring(val)
  elseif type(val) == "boolean" then
      tmp = tmp .. (val and "true" or "false")
  else
      tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end

local geometry = require "hs.geometry"

function moveMouseToCenterOfWindow(window, object)
  if is_debug == true then print("--- moveMouseToCenterOfWindow") end
  local frame = window:frame()
  -- hs.alert.show('switch')
  hs.mouse.absolutePosition(geometry.rectMidPoint(frame))
end

function getWindows(app_bundle_id)
  if is_debug == true then print("--- getWindows") end
  if hs.appfinder.appFromName(app_bundle_id) == nil then
    print(app_bundle_id .. ' app bundle id is not available')
  else
    if hs.application(app_bundle_id):isRunning() then
      local windows = hs.application(app_bundle_id):allWindows()
      print(app_bundle_id .. ' windows: ('  ..  serializeTable(windows) .. ')')
      print('number of windows: ' .. #windows)
    else
      print(app_bundle_id .. ' is not running')
    end
  end
end

hs.window.filter.forceRefreshOnSpaceChange = force_refresh_on_space_change

function launchApp(basicKey, object)
  if is_debug == true then print("--- launchApp") end
  hs.hotkey.bind(basicKey, object.key, function()
    local current_window = hs.window.focusedWindow()
    print("focused windows's app: " .. current_window:application():name())
    local app_name = object.app
    if object.app_name ~= nil then
      app_name = object.app_name
    end

    if current_window:application():name() == app_name then
      local wf = hs.window.filter.new{app_name}
      local filtered_windows = wf:getWindows(hs.window.filter.sortByFocused)
      print("list of the app's windows: " .. serializeTable(filtered_windows))
      if filtered_windows ~= nil and next(filtered_windows) ~=nil then
        print('focus on first filtered window')
        current_window = filtered_windows[1]:focus()
      else
        hs.alert.show('ERROR switching filtered windows')
        print('ERROR switching filtered windows')
      end
    else
      print('the app is not launched, open a new window of ' .. object.app)
      hs.application.launchOrFocus(object.app)
      current_window = hs.window.focusedWindow()
    end

    if current_window ~= nil and exit_from_full_screen == true then
      current_window:setFullScreen(false)
    end

    moveMouseToCenterOfWindow(current_window, object)
    hs.alert.show('-> ' .. object.app, current_window:screen())
    -- getWindows('' .. window:application():bundleID())
  end)
end

function setLayout(basicKey, object)
  if is_debug == true then print("--- setLayout") end
  hs.hotkey.bind(basicKey, object.key, function()
      previousLayout = hs.keycodes.currentLayout()
      hs.keycodes.setLayout(object.layout)
      newLayout = hs.keycodes.currentLayout()
      hs.alert.show(previousLayout .. ' -> ' .. newLayout)
  end)
end
