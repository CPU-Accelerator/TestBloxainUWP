local UI = loadstring(game:HttpGet('about:blank')) -- these will be changed later.
local Logic = loadstring(game:HttpGet('about:blank')) -- these will be changed later.

-- global variables
pcall(function()
	elements = game.HttpService:JSONDecode(readfile('blxsavefile.txt'))
end)

local inOutPut;
local window;

function saveData()
	if writefile then
		writefile('blxsavefile.txt', game.HttpService:JSONEncode(elements))
	else
		inOutPut:setText(game.HttpService:JSONEncode(elements))
	end
end
function loadData()
	elements = game.HttpService:JSONDecode(inOutPut:getText())
	window:exit()
	createUI()
	wait(1)
	pcall(updateAllCharacter)
end


function createUI()

    -- Window Management
    wn = ui:createWindow()
    local lpPage = ui:newPage('LocalPlayer')
    local gP = ui:newPage('Game')
    local autofarmpage = ui:newPage('Autofarm')
    local teleportsPage = ui:newPage('Teleports')
    local combatPage = ui:newPage('Combat')
    local tradingPage = ui:newPage('Trading')
    local miscPage = ui:newPage('Misc')
    local settingsPage = ui:newPage('Settings')

    lpPage:newLabel('Basic')
    lpPage:newSlider('WalkSpeed', 0, 100, 1, 16 ,updateAllCharacter)
    lpPage:newSlider('JumpPower', 0, 350, 1, 50, updateAllCharacter)
    lpPage:newSlider('Gravity', -10, 350, 1, 196.2, function(value) workspace.Gravity = value end)
    lpPage:newLabel('Standard')
    lpPage:newToggle('Infinite Jump', false)
    lpPage:newToggle('Noclip', false, HandelNoClip)
    lpPage:newBind('Spawn Platform', spawnPlatform)
    lpPage:newBind('Clear Platforms', clearPlatforms)
    lpPage:newSlider('Platform Size', 1, 100, 1, 7)
    if PC then
        lpPage:newBind('Click TP')
        lpPage:newBind('Click Delete')
    end

    gP:newLabel('RTX')
	gP:newToggle('Shadows', false, (function(value) if value then game.Lighting.GlobalShadows = value end end))
	gP:newToggle('RTX', false)
	gP:newToggle('Surface Light', false, (function() RTXON(false) wait(1) RTXON(true) end))
	gP:newSlider('RTX Brightness', 1, 100, 1, 7, (function(Value) RTXON(false, true) end))
	gP:newSlider('RTX Range', 1, 100, 1, 20, (function(Value) RTXON(false, true) end))
	gP:newSlider('Exposure', -20, 20, 1, 3, (function(Value) game.Lighting.ExposureCompensation = Value/10 end))
	gP:newSlider('Time of Day', 0, 24, 1, 14, (function(Value) game.Lighting.TimeOfDay = tostring(Value) end))

    
    teleportsPage:newLabel('Teleports')
    teleprotsPage:newButton("Glove Shop", (function() end))
    teleportsPage:newButton("Chests Shop", (function() end))
    teleportsPage:newButton("Currency Shop", (function() end))
    teleportsPage:newButton("Secret Shop", (function() end))
    teleportsPage:newButton("Training Area", (function() end))
    teleportsPage:newButton('Above Map', (function() end))
    teleportsPage:newButton("Secret Area 1", (function() end))
    teleportsPage:newButton("Secret Area 2", (function() end))



    tradingPage:newLabel('Coming Soon. (probably not lol)')