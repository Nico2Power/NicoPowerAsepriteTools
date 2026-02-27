local useSprite = app.sprite
local useLayer = app.layer

if not useSprite or not useLayer then
    app.alert("There is no sprite or layer")
    return
end


local function findLayerString(layerKeyword)
    local FindLayerTable = {}
    local keyword = layerKeyword:lower()

    local function insertAllLayerKeywordGroup(searchedLayers)
        for _, eachLayer in ipairs(searchedLayers.layers) do
            table.insert(FindLayerTable, eachLayer)
            if eachLayer.isGroup then
                insertAllLayerKeywordGroup(eachLayer)
            end
        end
    end

    local function searchKeywordLayers(searchedLayers)
        for _, eachLayer in ipairs(searchedLayers.layers) do
            if eachLayer.isGroup then
                if string.find(eachLayer.name:lower(), keyword) then
                    table.insert(FindLayerTable, eachLayer)
                    insertAllLayerKeywordGroup(eachLayer)
                end
                searchKeywordLayers(eachLayer)
            else
                if string.find(eachLayer.name:lower(), keyword) then
                    table.insert(FindLayerTable, eachLayer)
                end
            end
        end
    end



    searchKeywordLayers(useSprite)

    return FindLayerTable
end

local function doVisibleAllLayers(doVisible, allFindLayers)
    if #allFindLayers > 0 then
        for _, layerInTable in ipairs(allFindLayers) do
            if doVisible == true then
                layerInTable.isVisible = true
            else
                layerInTable.isVisible = false
            end
        end
    end
    app.refresh()
end

local function doLockAllLayers(doLock, allFindLayers)
    if #allFindLayers > 0 then
        for _, layerInTable in ipairs(allFindLayers) do
            if doLock == true then
                layerInTable.isEditable = false
            else
                layerInTable.isEditable = true
            end
        end
    end
    app.refresh()
end

local function changeOpacityForAllLayers(layersOpacity, allFindLayers)
    if #allFindLayers > 0 then
        for _, layerInTable in ipairs(allFindLayers) do
            if not layerInTable.isGroup then
                layerInTable.opacity = layersOpacity / 100 * 255
            end
        end
    end
    app.refresh()
end



local dlg = Dialog("Name-Based Layer Manager")
dlg:label { text = "Find Layer Name: " }:newrow()
    :entry { id = "layerKeyword", text = "", focus = true }:newrow()

    :separator {}

    :label { text = "Layers Visible" }:newrow()
    :button { id = "VisibleFindString", text = "Visible All", onclick = function()
        local keyword = dlg.data.layerKeyword
        local findAllLayers = {}

        if keyword ~= "" then
            findAllLayers = findLayerString(keyword)
            doVisibleAllLayers(true, findAllLayers)
        else
            app.alert("Please type keykord")
        end
    end }
    :button { id = "InVisibleFindString", text = "InVisible All", onclick = function()
        local keyword = dlg.data.layerKeyword
        local findAllLayers = {}

        if keyword ~= "" then
            findAllLayers = findLayerString(keyword)
            doVisibleAllLayers(false, findAllLayers)
        else
            app.alert("Please type keykord")
        end
    end }

    :separator {}

    :label { text = "Lock Layers" }:newrow()
    :button { id = "LockFindString", text = "Lock All", onclick = function()
        local keyword = dlg.data.layerKeyword
        local findAllLayers = {}
        if keyword ~= "" then
            findAllLayers = findLayerString(keyword)
            doLockAllLayers(true, findAllLayers)
        else
            app.alert("Please type keykord")
        end
    end }

    :button { id = "UnlockFindString", text = "Unlock All", onclick = function()
        local keyword = dlg.data.layerKeyword
        local findAllLayers = {}
        if keyword ~= "" then
            findAllLayers = findLayerString(keyword)
            doLockAllLayers(false, findAllLayers)
        else
            app.alert("Please type keykord")
        end
    end }

    :separator {}

    :label { text = "Layers Opacity" }:newrow()
    :slider { id = "layersOpacity", min = 0, max = 100 }:newrow()
    :button { id = "changeLayersOpacity", text = "Change Opacity", onclick = function()
        local keyword = dlg.data.layerKeyword
        local sliderOpacity = dlg.data.layersOpacity
        local findAllLayers = {}
        if keyword ~= "" then
            findAllLayers = findLayerString(keyword)
            changeOpacityForAllLayers(sliderOpacity, findAllLayers)
        end
    end }

dlg:show { wait = false, bounds = Rectangle() }
