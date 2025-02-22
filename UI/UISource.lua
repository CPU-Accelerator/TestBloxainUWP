wait(1)
local tweenService = game:GetService'TweenService'
local inputService = game:GetService'UserInputService'
local runService = game:GetService'RunService'
local lighting = game:GetService("Lighting");
local runService = game:GetService("RunService");

local elements = {} -- [data, functions]
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local root = player.PlayerGui
local utility = {}
local ui = {}
local windowRoot, pages, page, pagelayout;
local binds = {}
local createdPages = {};
local tween = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local PC = inputService.MouseEnabled
local settings = {
	['windowmovetype'] = 'direct',
} local colors = {
	['windowBackground'] = Color3.fromRGB(25,25,25),
	['boaderColor'] = Color3.fromRGB(255,255,255),
	['textColor'] = Color3.fromRGB(255,255,255),
} local blur = Instance.new('BlurEffect', game.Lighting)
blur.Size = 0

function utility:round(element)
	local uiCorner = Instance.new('UICorner', element)
	uiCorner.Name = 'round'
end	function utility:outline(element)
	local uiStroke = Instance.new('UIStroke', element)
	uiStroke.Color = colors.boaderColor
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end function utility:newFrame(element)
	local frame = Instance.new('Frame', element)
	utility:round(frame)
	utility:outline(frame)
	frame.BackgroundColor3 = colors.windowBackground
	return frame
end function utility:updateText(Element, Text)
	local text = ''
	spawn(function()
		for _, char in next, string.split(Text, '') do
			text = text..char
			Element.Text = text
			wait(0.03)
		end
	end)
end function utility:newButton(element, text)
	local button = Instance.new('TextButton', element)
	if text then
		utility:updateText(button, text)
	else
		button.Text = ''
	end
	utility:round(button)
	utility:outline(button)
	button.BackgroundColor3 = colors.windowBackground
	button.Active = false
	return button
end function utility:newTextLabel(element, text)
	local textLabel = Instance.new('TextLabel', element)
	utility:updateText(textLabel, text)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextColor3 = colors.textColor
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(.7,-20,1,0)
	textLabel.Position = UDim2.fromOffset(5,0)
	textLabel.TextScaled = true
	return textLabel
end function utility:newTextBox(element, text)
	local textLabel = Instance.new('TextBox', element)
	utility:updateText(textLabel, text)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextColor3 = colors.textColor
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1,-20,1,0)
	textLabel.Position = UDim2.fromOffset(5,0)
	textLabel.TextSize = 30
	return textLabel
end function utility:newScrollingFrame(element)
	local scrollingFrame = Instance.new('ScrollingFrame', element)
	local padding = Instance.new('UIListLayout', scrollingFrame)
	scrollingFrame.ScrollBarThickness = 0
	scrollingFrame.BackgroundColor3 = colors.windowBackground
	scrollingFrame.Size = UDim2.fromScale(1,1)
	scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.Transparency = 1
	padding.Padding = UDim.new(0,5)
	padding.Name = 'padding'
	return scrollingFrame
end function utility:newItem(page)
	local frame = utility:newButton(page)
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.Transparency = .95
	return frame
end function utility:blur()
	tweenService:Create(blur, TweenInfo.new(0.75, Enum.EasingStyle.Linear), {Size = 30}):Play()
end function utility:unBlur()
	tweenService:Create(blur, TweenInfo.new(0.75, Enum.EasingStyle.Linear), {Size = 0}):Play()
end function utility:arrangePageButtons()
	local pageButtons = pages:GetChildren()
	local number = table.maxn(pageButtons) - 3
	local sizePerButton = 1 / number
	for _, button in pairs(pageButtons) do
		if button:IsA('Frame') then
			button.Size = UDim2.fromScale(sizePerButton,1)
		end
	end
end  function utility:directDrag(element)
	local OrignalPosition = inputService:GetMouseLocation()
	local OrignalGUIPosition = element.AbsolutePosition
	while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
		local CurrentLocation = inputService:GetMouseLocation()
		local Offset = (OrignalPosition - CurrentLocation) * -1
		element.Position = UDim2.new(0, Offset.X + OrignalGUIPosition.X, 0, Offset.Y + OrignalGUIPosition.Y)
		task.wait()
	end
end function utility:fluidDrag(element)
	local OrignalPosition = inputService:GetMouseLocation()
	local OrignalGUIPosition = element.AbsolutePosition
	while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
		local CurrentLocation = inputService:GetMouseLocation()
		local Offset = (OrignalPosition - CurrentLocation) * -1
		tweenService:Create(element, tween, {Position = UDim2.fromOffset(Offset.X + OrignalGUIPosition.X, Offset.Y + OrignalGUIPosition.Y)}):Play()
		task.wait()
	end
end function utility:getSavedData(id)
	if elements[id] then
		print(elements[id][2], id)
		return elements[id][2]
	end
end


--[[
I did not make the blur creator this was made by imSnox
https://devforum.roblox.com/t/new-ui-blur-fully-automatic/2402850
Don't use this for your blurred UI's instead go to the above link for a newer vesion and usage docs.
]]
local blurCreator = {};

function blurCreator.new(frame, blurIntensity)
	local self = setmetatable({
		blurIntensity = blurIntensity or 0.5;
		depthOfField = Instance.new("DepthOfFieldEffect");
		root = Instance.new("Folder");

		parts = {};
		parents = {};

		camera = workspace.CurrentCamera;
		bindId = "neon:blur_effect";

		frame = Instance.new("Frame");
		folder = Instance.new("Folder");

	}, blurCreator);

	self.depthOfField.Name = "";
	self.depthOfField.Parent = lighting;
	self.depthOfField.FarIntensity = 0;
	self.depthOfField.FocusDistance = 51.6;
	self.depthOfField.InFocusRadius = 50;
	self.depthOfField.NearIntensity = self.blurIntensity;

	self.root.Name = "blurSnox";
	self.root.Parent = self.camera;

	self.frame.Name = "blurEffect";
	self.frame.Parent = frame;
	self.frame.Size = UDim2.new(0.95, 0, 0.95, 0);
	self.frame.Position = UDim2.new(0.5, 0, 0.5, 0);
	self.frame.AnchorPoint = Vector2.new(0.5, 0.5);
	self.frame.BackgroundTransparency = 1;

	self.folder.Parent = self.root;
	self.folder.Name = self.frame.Name;

	local function add(child)
		if child:IsA'GuiObject' then
			self.parents[#self.parents + 1] = child;
			add(child.Parent);
		end;
	end;

	add(self.frame);

	local continue = self:isNotNaN(self.camera:ScreenPointToRay(0, 0).Origin.x);
	while (not continue) do
		runService.RenderStepped:Wait();
		continue = self:isNotNaN(self.camera:ScreenPointToRay(0, 0).Origin.x);
	end;

	self:bindToRenderStep();

	return self;
end;

function blurCreator:isNotNaN(x)
	return x == x;
end;

function blurCreator:updateOrientation(fetchProperties)
	local properties = {
		Transparency = 0.98;
		BrickColor = BrickColor.new('Institutional white');
	};

	local zIndex = (1 - 0.05 * self.frame.ZIndex);

	local tl, br = self.frame.AbsolutePosition, self.frame.AbsolutePosition + self.frame.AbsoluteSize
	local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)

	local rot = 0;

	for _, v in ipairs(self.parents) do
		rot = rot + v.Rotation
	end

	if rot ~= 0 and rot%180 ~= 0 then
		local mid, s, c, vec = tl:lerp(br, 0.5), math.sin(math.rad(rot)), math.cos(math.rad(rot)), tl;
		tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid;
		tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid;
		bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid;
		br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid;
	end

	self:drawQuad(
		self.camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin,
		self.camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin,
		self.camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin,
		self.camera:ScreenPointToRay(br.x, br.y, zIndex).Origin,
		self.parts
	);

	if (fetchProperties) then
		for _, pt in pairs(self.parts) do
			pt.Parent = self.folder
		end;

		for propName, propValue in pairs(properties) do
			for _, pt in pairs(self.parts) do
				pt[propName] = propValue;
			end;
		end;
	end;
end;

function blurCreator:drawQuad(v1, v2, v3, v4, parts)
	parts[1], parts[2] = self:drawTriangle(v1, v2, v3, parts[1], parts[2]);
	parts[3], parts[4] = self:drawTriangle(v3, v2, v4, parts[3], parts[4]);
end;

function blurCreator:drawTriangle(v1, v2, v3, p0, p1)
	local s1 = (v1 - v2).magnitude;
	local s2 = (v2 - v3).magnitude;
	local s3 = (v3 - v1).magnitude;

	local smax = math.max(s1, s2, s3);

	local A, B, C
	if (s1 == smax) then
		A, B, C = v1, v2, v3;
	elseif (s2 == smax) then
		A, B, C = v2, v3, v1;
	elseif (s3 == smax) then
		A, B, C = v3, v1, v2;
	end;

	local para = ((B - A).x * (C - A).x + (B - A).y * (C - A).y + (B - A).z * (C - A).z) / (A - B).magnitude;
	local perp = math.sqrt((C - A).magnitude ^ 2 - para * para);
	local dif_para = (A - B).magnitude - para;

	local st = CFrame.new(B, A);
	local za = CFrame.Angles(math.pi / 2, 0, 0);

	local cf0 = st;

	local Top_Look = (cf0 * za).lookVector;
	local Mid_Point = A + CFrame.new(A, B).lookVector * para;
	local Needed_Look = CFrame.new(Mid_Point, C).lookVector;
	local dot = (Top_Look.x * Needed_Look.x + Top_Look.y * Needed_Look.y + Top_Look.z * Needed_Look.z);

	local ac = CFrame.Angles(0, 0, math.acos(dot))

	cf0 = (cf0 * ac)

	if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
		cf0 = cf0 * CFrame.Angles(0, 0, -2 * math.acos(dot))
	end

	cf0 = (cf0 * CFrame.new(0, perp / 2, -(dif_para + para / 2)));

	local cf1 = st * ac * CFrame.Angles(0, math.pi, 0)
	if (((cf1 * za).lookVector - Needed_Look).magnitude > 0.01) then
		cf1 = cf1 * CFrame.Angles(0, 0, 2 * math.acos(dot))
	end

	cf1 = cf1 * CFrame.new(0, perp / 2, dif_para / 2);

	if (not p0) then
		p0 = Instance.new('Part');
		p0.FormFactor = "Custom";
		p0.TopSurface = 0;
		p0.BottomSurface = 0;
		p0.Anchored = true;
		p0.CanCollide = false;
		p0.CastShadow = false;
		p0.Material = Enum.Material.Glass;
		p0.Size = Vector3.new(0.2, 0.2, 0.2);

		local mesh = Instance.new("SpecialMesh", p0);
		mesh.MeshType = 2;
		mesh.Name = "WedgeMesh"
	end;

	p0.WedgeMesh.Scale = Vector3.new(0, perp / 0.2, para / 0.2);
	p0.CFrame = cf0;

	if (not p1) then
		p1 = p0:clone();
	end;

	p1.WedgeMesh.Scale = Vector3.new(0, perp / 0.2, dif_para / 0.2);
	p1.CFrame = cf1;

	return p0, p1;
end;

function blurCreator:setBlurIntensity(intensity)
	self.blurIntensity = intensity;
	self.depthOfField.NearIntensity = intensity;
end;

function blurCreator:bindToRenderStep()
	self:updateOrientation(true);
	runService:BindToRenderStep(self.bindId, 2000, function()
		self:updateOrientation(true);
	end);
end;

blurCreator.__index = blurCreator;

function ui:createWindow()
	if PC then
		return ui:createPCWindow()
	else
		return ui:createMobileWindow()
	end
end

function ui:createMobileWindow()
	local open;
	local screen = Instance.new('ScreenGui', root)
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 1000
	windowRoot = Instance.new('Frame', screen)
	windowRoot.Size = UDim2.new(1, 0, 1, 60)
	windowRoot.Position = UDim2.fromScale(0,1)
	windowRoot.Transparency = 0.5
	windowRoot.BackgroundColor3 = colors.windowBackground
	utility:blur()

	pages = utility:newFrame(windowRoot)
	local pageslayout = Instance.new('UIListLayout', pages)
	pageslayout.FillDirection = Enum.FillDirection.Horizontal
	pages.Size = UDim2.new(.9, 0, 0, 60)
	pages.Position = UDim2.new(.05, 0, 0, 70)
	pages.Transparency = .95
	pages.Active = true

	page = utility:newFrame(windowRoot)
	pagelayout = Instance.new('UIPageLayout', page)
	pagelayout.Padding = UDim.new(1,0)
	page.Transparency = .9
	page.Size = UDim2.new(.9, 0, .95, -140)
	page.Position = UDim2.new(.05, 0, 0, 140)
	page.ClipsDescendants = false

	local button = utility:newFrame(screen)
	local logo = Instance.new('TextButton', button)
	button.Position = UDim2.new(0.5, 0, 0, 10)
	button.Size = UDim2.fromOffset(30,30)
	logo.TextScaled = true
	logo.Font = Enum.Font.BuilderSansExtraBold
	logo.Size = UDim2.fromScale(1,1)
	logo.Text = 'B'
	logo.TextColor3 = colors.textColor
	logo.BackgroundTransparency = 1
	logo.Active = true
	local function drag()
		local OrignalPosition = inputService:GetMouseLocation()
		local OrignalGUIPosition = button.AbsolutePosition
		while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
			local CurrentLocation = inputService:GetMouseLocation()
			local Offset = (OrignalPosition - CurrentLocation) * -1
			button.Position = UDim2.new(0, Offset.X + OrignalGUIPosition.X, 0, Offset.Y + OrignalGUIPosition.Y)
			task.wait()
		end
	end

	for	i = 1, 3 do
		local bind = utility:newFrame(screen)
		local text = utility:newButton(bind, tostring(i))
		bind.Position = UDim2.new(1, -75, (1/6) * i, 0)
		bind.Size = UDim2.fromOffset(60,60)
		text.TextScaled = true
		text.Name = 'button'
		text.Font = Enum.Font.BuilderSansExtraBold
		text.Text = 'B'
		text.TextColor3 = colors.textColor
		text.BackgroundTransparency = 1
		text.Size = UDim2.fromScale(1,1)
		bind.Visible = false
		binds[i] = {bind}

		text.MouseButton1Click:Connect(function()
			binds[i][2]()
		end) text.TouchLongPress:Connect(function()
			bind.Visible = false
			binds[i][2] = nil
		end)
	end

	pagelayout.EasingStyle = Enum.EasingStyle.Exponential
	pagelayout.TouchInputEnabled = false
	pages.MouseWheelForward:Connect(function(input)
		pagelayout:Next()
	end) pages.MouseWheelBackward:Connect(function(input)
		pagelayout:Previous()
	end)

	local function close()
		tweenService:Create(windowRoot, tween, {Position = UDim2.new(0,0,1,0)}):Play()
		utility:unBlur()
		open = false
	end local function openUi()
		tweenService:Create(windowRoot, tween, {Position = UDim2.new(0,0,0,-60)}):Play()
		utility:blur()
		open = true
	end local function toggleUi()
		if open == true then
			close()
		else
			openUi()
		end
	end

	logo.MouseButton1Down:Connect(function()
		drag()
	end)
	logo.MouseButton1Click:Connect(function()
		toggleUi()
	end)
	openUi()
	local functions = {}
	function functions:toggleui()
		toggleUi()
	end function functions:exit()
		screen:Destroy()
	end
	return functions
end

function ui:createPCWindow()
	local open;
	local bS = 20 -- boarderSize
	local screen = Instance.new('ScreenGui', root)
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 1000
	windowRoot = Instance.new('Frame', screen)
	windowRoot.Size = UDim2.fromOffset(800, 500)
	windowRoot.Position = UDim2.fromScale(0,1)
	windowRoot.Transparency = 0.5
	windowRoot.BackgroundColor3 = colors.windowBackground
	utility:round(windowRoot)
	utility:outline(windowRoot)
	blurCreator.new(windowRoot, 24)

	pages = utility:newFrame(windowRoot)
	local pageslayout = Instance.new('UIListLayout', pages)
	pageslayout.FillDirection = Enum.FillDirection.Horizontal
	pages.Size = UDim2.new(1, -(bS*2), 0, 60)
	pages.Position = UDim2.fromOffset(bS, bS)
	pages.Transparency = .95
	pages.Active = true

	page = utility:newFrame(windowRoot)
	pagelayout = Instance.new('UIPageLayout', page)
	pagelayout.Padding = UDim.new(1,0)
	page.Transparency = .9
	page.Size = UDim2.new(1, -(bS*2), 1, -60+(-bS*3))
	page.Position = UDim2.new(0, bS, 0, 60+(bS*2))
	page.ClipsDescendants = true

	local topBar = Instance.new('Frame', windowRoot)
	topBar.Size = UDim2.new(1, -bS, 0, bS)
	topBar.Transparency = 1
	topBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then utility:fluidDrag(windowRoot) end end)
	local sidebar = Instance.new('Frame', windowRoot)
	sidebar.Size = UDim2.new(0, bS, 1, -bS)
	sidebar.Position = UDim2.new(1,-bS,0,0)
	sidebar.Transparency = 1
	sidebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local OrignalPosition = inputService:GetMouseLocation()
			local OrignalGUIScale = windowRoot.AbsoluteSize
			while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local CurrentLocation = inputService:GetMouseLocation()
				local Offset = (OrignalPosition - CurrentLocation) * -1
				tweenService:Create(windowRoot, tween, {Size = UDim2.fromOffset(OrignalGUIScale.X + Offset.X, OrignalGUIScale.Y)}):Play()
				task.wait()
			end
		end 
	end)
	local footer = Instance.new('Frame', windowRoot)
	footer.Size = UDim2.new(1, -bS, 0, bS)
	footer.Position = UDim2.new(0,0,1,-bS)
	footer.Transparency = 1
	footer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local OrignalPosition = inputService:GetMouseLocation()
			local OrignalGUIScale = windowRoot.AbsoluteSize
			while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local CurrentLocation = inputService:GetMouseLocation()
				local Offset = (OrignalPosition - CurrentLocation) * -1
				tweenService:Create(windowRoot, tween, {Size = UDim2.fromOffset(OrignalGUIScale.X, Offset.Y + OrignalGUIScale.Y)}):Play()
				task.wait()
			end
		end 
	end)
	local coner = Instance.new('Frame', windowRoot)
	coner.Size = UDim2.fromOffset(bS, bS)
	coner.Position = UDim2.new(1, -bS, 1, -bS)
	coner.Transparency = 1
	coner.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local OrignalPosition = inputService:GetMouseLocation()
			local OrignalGUIScale = windowRoot.AbsoluteSize
			while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local CurrentLocation = inputService:GetMouseLocation()
				local Offset = (OrignalPosition - CurrentLocation) * -1
				tweenService:Create(windowRoot, tween, {Size = UDim2.fromOffset(Offset.X + OrignalGUIScale.X, Offset.Y + OrignalGUIScale.Y)}):Play()
				task.wait()
			end
		end 
	end)

	pagelayout.EasingStyle = Enum.EasingStyle.Exponential
	pagelayout.TouchInputEnabled = false
	pages.MouseWheelForward:Connect(function(input)
		pagelayout:Next()
	end) pages.MouseWheelBackward:Connect(function(input)
		pagelayout:Previous()
	end)

	local function close()
		tweenService:Create(windowRoot, tween, {Position = UDim2.new(0,0,1,0)}):Play()
		open = false
	end local function openUi()
		tweenService:Create(windowRoot, tween, {Position = UDim2.new(0,100,0,100)}):Play()
		open = true
	end local function toggleUi()
		if open == true then
			close()
		else
			openUi()
		end
	end
	openUi()
	local functions = {}
	function functions:toggleui()
		toggleUi()
	end function functions:exit()
		screen:Destroy()
	end
	return functions
end

function ui:newPage(title)
	local pageButton = utility:newFrame(pages)
	pageButton.Size = UDim2.new(0, 100, 1, 0)
	pageButton.Transparency = .95
	local text = utility:newTextLabel(pageButton, title)
	text.TextSize = 30
	text.Font = Enum.Font.BuilderSansBold
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.Size = UDim2.new(1, -10, 1, 0)
	local scrollingFrame = utility:newScrollingFrame(page)
	pageButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			pagelayout:JumpTo(scrollingFrame)
		end
	end)
	local functions = {}
	function functions:activate()
		pagelayout:JumpTo(scrollingFrame)
	end function functions:newLabel(text)
		return ui:newLabel(scrollingFrame, text)
	end function functions:newToggle(text, default, callback)
		return ui:newToggle(scrollingFrame, text, default, callback)
	end function functions:newSlider(text, min, max, step, default, callback)
		return ui:newSlider(scrollingFrame, text, min, max, step, default, callback)
	end function functions:newButton(text, callback)
		return ui:newButton(scrollingFrame, text, callback)
	end function functions:newBind(text, callback)
		if PC then
			return ui:newPCBind(scrollingFrame, text, callback)
		else
			return ui:newMobileBind(scrollingFrame, text, callback)
		end
	end function functions:newMutiToggle(text, default, callback)
		return ui:newMutiToggle(scrollingFrame, text, default, callback)
	end function functions:newTextBox(text, default, callback)
		return ui:newTextBox(scrollingFrame, text, default, callback)
	end
	elements[title] = {functions}
	utility:arrangePageButtons()
	return functions
end

function ui:newLabel(page, text)
	local item = utility:newItem(page)
	local text = utility:newTextLabel(item, text)
	text.Size = UDim2.fromScale(1,1)
	text.TextColor3 = Color3.fromRGB(100,100,100)
	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end
	return functions
end

function ui:newTextBox(page, text, default, callback)
	local item = utility:newItem(page)
	local text = utility:newTextLabel(item, text)
	local default = utility:getSavedData(text) or default or ''
	local textBox = utility:newTextBox(item, default)
	utility:outline(textBox)
	textBox.Size = UDim2.fromScale(.5, 1)
	textBox.Position = UDim2.fromScale(.5, 0)
	textBox.Text = default
	textBox.ClearTextOnFocus = false

	text.Size = UDim2.fromScale(.5 ,1)

	textBox:GetPropertyChangedSignal('Text'):Connect(function()
		elements[text][2] = textBox.Text
		if callback then
			callback(textBox.Text)
		end
	end)

	local functions = {}
	function functions:setText(newText)
		textBox.Text = newText
	end function functions:getText(newText)
		return textBox.Text
	end
	elements[text] = {functions, default}
	return functions
end

function ui:newToggle(page, text, default, callback)
	local value=utility:getSavedData(text) or default or false;
	local item = utility:newItem(page)
	local textLabel = utility:newTextLabel(item, text)
	local indicator = utility:newTextLabel(item, 'Off')
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	indicator.Size = UDim2.fromScale(.3, .7)
	indicator.Position = UDim2.new(.7, -20, 0, 0)
	indicator.Size = UDim2.fromScale(.3, 1)
	item.BackgroundColor3 = Color3.fromRGB(255,0,0)

	local function turnOn()
		tweenService:Create(item, tween, {BackgroundColor3 = Color3.fromRGB(0,255,0)}):Play()
		utility:updateText(indicator, 'On')
	end local function turnOff()
		tweenService:Create(item, tween, {BackgroundColor3 = Color3.fromRGB(255,0,0)}):Play()
		utility:updateText(indicator, 'Off')
	end
	task.spawn(function()
		wait(1)
		if value then
			turnOn()
		end
	end)
	local function toggle()
		if value then
			turnOff()
			value = false
		else
			turnOn()
			value = true
		end
		elements[text][2] = value
	end
	item.MouseButton1Click:Connect(function(input)
		toggle()
		if callback then
			callback(value)
		end
	end)

	if default then
		turnOn()
	end

	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end function functions:setToggle(bool)
		if bool then
			turnOn()
		else
			turnOff()
		end
	end function functions:getValue(newText)
		return value
	end
	elements[text] = {functions, value}
	return functions
end

function ui:newSlider(page, text, min, max, step, default, callback)
	local item = utility:newItem(page)
	local textLabel = utility:newTextLabel(item, text)
	local default = default or 0
	local sliderValue = utility:getSavedData(text) or default
	local indicator = utility:newTextBox(item, tostring(sliderValue))
	local slider = utility:newFrame(item)
	local resetButton = utility:newButton(item)
	slider.Transparency = .9
	slider.Size = UDim2.new(0,0,1,0)
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	indicator.ClearTextOnFocus = false
	indicator.Position = UDim2.new(.7, -20, 0, 0)
	indicator.Size = UDim2.fromScale(.2, 1)
	indicator.TextScaled = true
	resetButton.Size = UDim2.new(.1,-20,1,0)
	resetButton.Position = UDim2.fromScale(.9,0)
	resetButton.Transparency = 1
	resetButton.TextTransparency = 0
	resetButton.Text = 'R'
	resetButton.UIStroke:Destroy()
	resetButton.TextScaled = true
	resetButton.TextColor3 = colors.textColor
	utility:round(indicator)
	item.BackgroundColor3 = Color3.fromRGB(255,0,0)
	item.Active = true

	local function round(number, idk)
		if not idk then
			idk	= 1
		end
		number = number / idk
		local decimal = number - math.floor(number)
		if decimal >= .5 then
			return math.ceil(number) * idk
		else
			return math.floor(number) * idk
		end
	end local function Updateslider(value)
		local Mouse = player:GetMouse()
		local Start = item.AbsolutePosition.X
		local Percent = (Mouse.X - Start) / item.AbsoluteSize.X
		Percent = math.clamp(Percent, 0, 1)
		value = value or math.floor(min + (max - min) * Percent)
		if value then Percent = (value - min) / (max - min) end
		value = round(value, step)
		Percent = math.clamp(Percent, 0, 1)
		tweenService:Create(slider, tween, {Size = UDim2.new(Percent, 0, 1, 0), BackgroundColor3 = Color3.new((100 - value)/100, value/100, 0)}):Play()
		elements[text][2] = value
		sliderValue = value
		indicator.Text = value
		return value
	end

	local function sliderActive()
		local updater;
		local old = Updateslider()
		if callback then
			spawn(function() callback(old) end)
		end
		updater = runService.Stepped:Connect(function()
			if inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
				updater:Disconnect()
			end
			local new = Updateslider()
			if new ~= old and callback then
				spawn(function() callback(new) end)
				old = new
			end
		end)
	end

	item.TouchSwipe:Connect(function(swipeDirection, idk, id2)
		print(swipeDirection, idk, id2)
		if swipeDirection == Enum.SwipeDirection.Left or swipeDirection == Enum.SwipeDirection.Right then
			sliderActive()
		end
	end) slider.TouchSwipe:Connect(function(swipeDirection, idk, id2)
		print(swipeDirection, idk, id2)
		if swipeDirection == Enum.SwipeDirection.Left or swipeDirection == Enum.SwipeDirection.Right then
			sliderActive()
		end
	end) textLabel.TouchSwipe:Connect(function(swipeDirection, idk, id2)
		print(swipeDirection, idk, id2)
		if swipeDirection == Enum.SwipeDirection.Left or swipeDirection == Enum.SwipeDirection.Right then
			sliderActive()
		end
	end)
	item.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliderActive()
		end
	end) indicator.FocusLost:Connect(function()
		local number = tonumber(indicator.Text)
		if number then
			Updateslider(number)
			if callback then
				callback(number)
			end
		end
	end) 
	resetButton.MouseButton1Click:Connect(function()
		Updateslider(default)
		indicator.Text = default
		if callback then
			callback(default)
		end
	end)

	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end function functions:setValue(number)
		Updateslider(number)
		indicator.Text = tostring(number)
	end function functions:getValue()
		return sliderValue
	end
	elements[text] = {functions, default}
	Updateslider(sliderValue)
	return functions
end

function ui:newButton(page, text, callback)
	local item = utility:newItem(page)
	local text = utility:newTextLabel(item, text)
	text.Size = UDim2.fromScale(1,1)
	item.MouseButton1Click:Connect(function(input)
		callback()
	end)
end

function ui:newPCBind(page, text, callback)
	local id = text
	local item = utility:newItem(page)
	local textLabel = utility:newTextLabel(item, text)
	local triggerKey = (function() if utility:getSavedData(text) then return Enum.KeyCode[utility:getSavedData(text)] else return nil end end)()
	local indicator = utility:newTextLabel(item, utility:getSavedData(text) or 'notSet')
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	indicator.TextSize = 25
	indicator.Position = UDim2.new(.7, -20, 0, 0)
	indicator.Size = UDim2.fromScale(.3, 1)
	local setOnNextKey = false

	inputService.InputBegan:Connect(function(input, typing)
		if input.UserInputType == Enum.UserInputType.Keyboard and typing == false then
			if setOnNextKey then
				if input.KeyCode == Enum.KeyCode.Backspace then
					setOnNextKey = false
					indicator.Text = 'notSet'
					triggerKey = nil
					elements[text][2] = nil
					return
				end
				triggerKey = input.KeyCode
				indicator.Text = input.KeyCode.Name
				setOnNextKey = false
				elements[text][2] = input.KeyCode.Name
			elseif triggerKey and input.KeyCode == triggerKey and callback then
				callback()
			end
		end
	end)
	local function activate()
		setOnNextKey = true
		indicator.Text = 'Press any key..'
	end
	item.MouseButton1Click:Connect(function(input)
		activate()
	end)
	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end function functions:activate()
		activate()
	end function functions:getValue(number)
		return triggerKey
	end
	elements[text] = {functions, (function() if utility:getSavedData(text) then return utility:getSavedData(text) else return nil end end)()}
	return functions
end

function ui:newMobileBind(page, text, callback)
	local id = text
	local item = utility:newItem(page)
	local textLabel = utility:newTextLabel(item, text)
	local indicator = utility:newTextLabel(item, 'Tap to set bind')
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	indicator.TextSize = 25
	indicator.Position = UDim2.new(.7, -20, 0, 0)
	indicator.Size = UDim2.fromScale(.3, 1)
	local setOnNextKey = false
	local trigger = false

	local function activate()
		windowRoot.Visible = false
		for i, v in pairs(binds) do
			task.spawn(function()
				local btn = v[1]
				btn.Visible = true
				print(btn, btn.Parent, btn.Visible)
				local connection;
				connection = btn.button.MouseButton1Click:Connect(function(input)
					print(btn.button.Text)
					v[2] = callback
					for __, button in pairs(binds) do
						if button[2] == nil then
							button[1].Visible = false
						end
					end
					windowRoot.Visible = true
					trigger = true
					indicator.Text = tostring(i)
					connection:Disconnect()
				end)
				repeat wait() until trigger
				connection:Disconnect()
				wait(.5)
				trigger = false
			end)
		end
	end
	item.MouseButton1Click:Connect(function(input)
		activate()
	end)
	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end function functions:activate()
		activate()
	end function functions:getValue(number)
		return nil
	end
	elements[text] = {functions}
	return functions
end

function ui:newMutiToggle(page, text, default, callback)
	local value=utility:getSavedData(text) or default or 1;
	local item = utility:newItem(page)
	local textLabel = utility:newTextLabel(item, text)
	local indicator = utility:newTextLabel(item, 'Idle')
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	item.BackgroundColor3 = Color3.fromRGB(255,0,0)

	indicator.Position = UDim2.new(.7, -20, 0, 0)
	indicator.Size = UDim2.fromScale(.3, 1)

	local function turnOn()
		tweenService:Create(item, tween, {BackgroundColor3 = Color3.fromRGB(0,255,0)}):Play()
		utility:updateText(indicator, 'On')
	end local function turnOff()
		tweenService:Create(item, tween, {BackgroundColor3 = Color3.fromRGB(255,0,0)}):Play()
		utility:updateText(indicator, 'Off')
	end local function turnIdle() -- stupid name copy+pasted from normal toggle
		tweenService:Create(item, tween, {BackgroundColor3 = Color3.fromRGB(150,100,0)}):Play()
		utility:updateText(indicator, 'Idle')
	end

	local function toggle()
		if value == 0 then
			turnIdle()
			value = 1
		elseif value == 1 then
			turnOn()
			value = 2
		else
			turnOff()
			value = 0
		end
		elements[text][2] = value
	end

	item.MouseButton1Click:Connect(function(input)
		toggle()
		if callback then
			callback(value)
		end
	end)
	task.spawn(function()
		task.wait(1)
		if value == 2 then
			turnOn()
		elseif value == 0 then
			turnOff()
		end
	end)

	local functions = {}
	function functions:setText(newText)
		utility:updateText(text, newText)
	end function functions:setToggle(bool)
		if bool then
			turnOn()
		else
			turnOff()
		end
	end function functions:getValue(newText)
		return value
	end
	elements[text] = {functions, value}
	return functions
end