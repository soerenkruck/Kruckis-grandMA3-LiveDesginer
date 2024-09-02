local Strings =
{
  wings = "Wings",
  ltoR = "Left to Right",
}

local function main(displayHandle, args)
    Printf("Plugin called from "..displayHandle:ToAddr().." OS: ".. HostOS())
    if args then
        Printf("Plugin called with argument "..args)
    end

    local groupsA = 6
    local tricksPerGroup = 3

    local count = 1

    local gSelect = GetGroup(displayHandle)
    if gSelect then
        Printf("Selected Group:"..gSelect)
    end

    local selectedPreset = SelectPreset(displayHandle)
    EditGroupBumpPreset(gSelect, selectedPreset, displayHandle)

end

function EditGroupBumpPreset(group, preset, displayHandle)



    -- A table with two default buttons for the pop-up
    local defaultCommandButtons = {
        {value = 2, name = "Define"},
        {value = 1, name = "Cancel"}
    }
    -- A table with three state buttons
    -- The buttons will be displayed alphabetically in the pop-up
    local stateButtons = {
        {name = Strings.wings, state = false},
        {name = Strings.ltoR, state = false},
    }

    -- A table with the elements needed for the pop-up
    local messageTable = {
        icon = "object_smart",
        backColor = "Window.Plugins",
        title = "Edit Preset "..preset.. "of Group "..group,
        message = "",
        commands = defaultCommandButtons,
        states = stateButtons,
        
    }

    -- The creation on the actual pop-up with the result stored in a variable
    local returnTable = MessageBox(messageTable)

    -- Print the content of the returned table
    Printf("Success = "..tostring(returnTable.success))
    Printf("Result = "..returnTable.result)
    -- Print a list with the state of the stateButtons

    for name,state in pairs(returnTable.states) do
        Printf("State '%s' = '%s'",name,tostring(state))
        if name == Strings.wings then
            if state == true then
                DataPool().MAtricks[MAtricksIndex]:Set("XWings", 2)
            else
                DataPool().MAtricks[MAtricksIndex]:Set("XWings", "None")
            end
        end
    end
end

function GetGroup(displayHandle)
    local groups = {}
    for groupIndex = 1,6,1 do
        if DataPool().Groups[groupIndex] then
            groups[groupIndex] = DataPool().Groups[groupIndex].Name
            local g = DataPool().Groups[groupIndex].Name
            Printf("Added Group"..groupIndex.." \""..g)
        end
    end

    local descTable = {
        title = "Select Group",
        caller = displayHandle,
        items = groups,
        selectedValue = "Some",
        add_args = {FilterSupport="Yes"},
    }
    local a,b = PopupInput(descTable)
    return a
end

function SelectPreset(displayHandle)
    local descTable = {
        title = "Select Preset",
        caller = displayHandle,
        items = {"Preset 1", "Preset 2", "Preset 3"},
        selectedValue = "Preset 1",
        add_args = {FilterSupport="Yes"},
    }
    local a,b = PopupInput(descTable)
    return a
end

return main