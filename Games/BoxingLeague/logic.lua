local TweenService = game:GetService("TweenService")
local NC = game:GetService("NetworkClient")
local Players = game['Players']
local Player = Players.LocalPlayer


local function Spawnplatform(Transparency, Size)
	local Clone = Instance.new("Part")
	Clone.Parent = workspace
	Clone.Anchored = true
	Clone.Size = Vector3.new(Size, 1, Size)
	Clone.Name = "falksjdhflkjasdhflkjasdhflkjasdfhj"
	Clone.Transparency = Transparency

	if game.Players.LocalPlayer.Character:FindFirstChild("Left Leg") then
		Clone.Position = game.Players.LocalPlayer.Character["Left Leg"].Position
	else
		Clone.Position = game.Players.LocalPlayer.Character["LeftFoot"].Position
	end
	return Clone
end

local function FindPlayer(Name)
	for i, v in pairs(game.Players:GetPlayers()) do
		if string.find(string.lower(v.Name), string.lower(Name)) then
			return v
		end
	end
end

local function Workout(thing, num)
	if thing == 'box' then
		while true do
			task.wait(0.03)
			game:GetService("ReplicatedStorage").Action.GymUse:FireServer("CL")
			workspace.Machinery['BOX'..num].RemoteEvent:FireServer({'Interact'})
			game:GetService("ReplicatedStorage").Level:FireServer("Upgrade","DEX")
		end

	elseif thing == 'punch' then
		game.ReplicatedStorage.Action.GymUse:FireServer('CL')
	elseif thing == 'Push' then
		workspace.Machinery['PUSH'..num].RemoteEvent:FireServer({'Interact'})
	elseif thing == 'Pull' then
		workspace.Machinery['GRAB'..num].RemoteEvent:FireServer({'Interact'})
	end
	elseif thing == '' then
		workspace.Machinery['GRAB'..num].RemoteEvent:FireServer({'Interact'})
end



-- Function to find a player's character
local function Char(player)
	if not player then
		while not Player.Character do task.wait(.1) end
		return Player.Character
	end

	local target = Players:FindFirstChild(player) or object.Find(Players, player, 'DisplayName')
	while target and not target.Character do task.wait(.1) end
	return target and target.Character
end

-- Teleport locations for different game places
local TP_Locations = {
	["3738115442"] = {
		Vector3.new(322.366, 115.474, -373.346),
		Vector3.new(303.332, 132.560, -286.631),
		Vector3.new(402.663, 132.237, -312.941),
		Vector3.new(368.907, 122.893, 102.679),
		Vector3.new(342.195, 102.695, 304.216),
		Vector3.new(-0.664, -0.726, 0.372),
		Vector3.new(343.428, 92.575, -168.662),
		Vector3.new(347.262, 158.575, -106.821),
	},
	["4574912733"] = {
		Vector3.new(-81.098, 3.474, 145.984),
		Vector3.new(-8.957, 3.973, 132.100),
		Vector3.new(-103.246, 3.974, 139.786),
		Vector3.new(100.834, 65.768, 149.459),
		Vector3.new(-37.582, 34.972, 120.361),
		Vector3.new(-41.180, 100.568, 262.102),
		Vector3.new(-192.414, 3.973, 185.089),
		Vector3.new(2.651, 136.972, 410.073),
	}
}

-- Select teleport locations based on the current place
local TP_Table = TP_Locations[tostring(game.PlaceId)] or TP_Locations["4574912733"]

-- Function to handle teleportation
local function bypass_teleport(index)
	local character = Char()
	if character and character:FindFirstChild("HumanoidRootPart") then
		local cf = CFrame.new(TP_Table[index])
		local tween = TweenService:Create(character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = cf})
		tween:Play()
	end
end

-- Button Teleport Assignments
local TeleportButtons = {
	[IntroFightEmoteTPBtn] = 1,
	[GlovesTPBtn] = 2,
	[ChestsTPBtn] = 3,
	[_2v2ArenaTPBtn] = 4,
	[TrainingAreaTPBtn] = 5,
	[HideoutArea1TPBtn] = 6,
	[HideoutArea2TPBtn] = 7,
	[AboveMapTPBtn] = 8
}

for button, index in pairs(TeleportButtons) do
	button.MouseButton1Click:Connect(function()
		bypass_teleport(index)
	end)
end


local function lagClient(setbitrate)
	NC:SetOutgoingKBPSLimit(setbitrate)
end

--[[

local function snipebox()

end

]]

