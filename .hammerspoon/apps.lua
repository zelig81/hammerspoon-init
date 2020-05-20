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
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

local geometry = require "hs.geometry"

function moveToCenterOfWindow(window) 
--    local window = hs.window.focusedWindow()
    local frame = window:frame()
    hs.mouse.setAbsolutePosition(geometry.rectMidPoint(frame))
end

function launchApp(basicKey, object)
    hs.hotkey.bind(basicKey, object.key, function() 
        hs.application.launchOrFocus(object.app)
        local application = hs.application.get(object.app)
        hs.alert.show('' .. object.app)
        if application ~= nil then
            local window = application:focusedWindow()
            window = application:focusedWindow()
            -- hs.grid.maximizeWindow(window)
            if window ~= nil then
                moveToCenterOfWindow(window)
            end
        end
    end)
end

function setLayout(basicKey, object)
    hs.hotkey.bind(basicKey, object.key, function() 
        previousLayout = hs.keycodes.currentLayout()
        hs.keycodes.setLayout(object.layout)
        newLayout = hs.keycodes.currentLayout()
        hs.alert.show(previousLayout .. ' -> ' .. newLayout)
    end)
end
