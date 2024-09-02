local function tmp(displayHandle, args)
    Printf("Plugin called from "..displayHandle:ToAddr().." OS: ".. HostOS())
    if args then
        Printf("Plugin called with argument "..args)
    end

    local groupsA = 6
    local tricksPerGroup = 3

    local count = 1

    for matricksI = 1, groupsA, 1 do
        for tricksIn = 1,tricksPerGroup,1 do
            if DataPool().MAtricks[count] then
                Cmd("Delete MAtricks "..count)
            end
            if (DataPool().MAtricks[count+1]) then
                Cmd("Delete MAtricks "..count+1)
            end
            Cmd("Store MAtricks "..count.." \"Group "..matricksI.." In Preset "..tricksIn.."\"")
            count = count + 1
            Cmd("Store MAtricks "..count.." \"Group "..matricksI.." Out Preset "..tricksIn.."\"")
            count = count + 1
        end
    end

    local gSelect = getGroup(displayHandle)
    if gSelect then
        Printf("Selected Group:"..gSelect)
    end

end

function getGroup(displayHandle)
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

function DisplayPopup(displayHandle)
    local modes = {"Off", "Auto", "Slow", "10% Steps", "Large Jumps", "Small Jumps", "Tiny Jumps", "Random"}
    local selectedIndex, selectedMode
    selectedIndex, selectedMode = PopupInput({title = "Mode", caller = displayHandle, items = modes})
    Echo("Selected index: " .. selectedIndex .. ", mode: " .. selectedMode)
end

local function main(displayHandle, args)

    
    DisplayPopup(displayHandle)

	-- create inputs:
	local states = {
		{name = "State A", state = true, group = 1},
		{name = "State B", state = false, group = 1},
		{name = "State C", state = true, group = 2},
		{name = "State D", state = false, group = 2}
	}
	local inputs = {
		{name = "Numbers Only", value = "1234", whiteFilter = "0123456789"},
		{name = "Text Only", value = "TextOnly", blackFilter = "0123456789"},
		{name = "Maximum 10 characters", value = "abcdef", maxTextLength = 10}
	}
	local selectors = {
		{ name="Swipe Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=0},
		{ name="Radio Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=1}
	}

	-- open messagebox:
	local resultTable =
		MessageBox(
		{
			title = "Messagebox example",
			message = "This is a message",
			message_align_h = Enums.AlignmentH.Left,
			message_align_v = Enums.AlignmentV.Top,
			commands = {{value = 1, name = "Ok"}, {value = 0, name = "Cancel"}},
			states = states,
			inputs = inputs,
			selectors = selectors, selectors,
			backColor = "Global.Default",
			-- timeout = 10000, --milliseconds
			-- timeoutResultCancel = false,
			icon = "logo_small",
			titleTextColor = "Global.AlertText",
			messageTextColor = "Global.Text"
		}
	)

	-- print results:
	Printf("Success = "..tostring(resultTable.success))
	Printf("Result = "..resultTable.result)
	for k,v in pairs(resultTable.inputs) do
		Printf("Input '%s' = '%s'",k,v)
	end
	for k,v in pairs(resultTable.states) do
		Printf("State '%s' = '%s'",k,tostring(v))
	end
	for k,v in pairs(resultTable.selectors) do
		Printf("Selector '%s' = '%d'",k,v)
	end
end

return main

