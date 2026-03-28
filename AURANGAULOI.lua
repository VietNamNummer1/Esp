-- SCRIPT GUI AURA (LocalScript) - Đặt vào StarterPlayer > StarterPlayerScripts
-- ĐÃ THÊM: Nút mở GUI lại (🌟) luôn hiển thị ở góc trên bên trái
-- Nhấn ✕ để đóng GUI, nhấn 🌟 để mở lại bất kỳ lúc nào

local particle_auras = {
    ["StarLight"] = "rbxassetid://134645216613107",
    ["Heavenly"] = "rbxassetid://139300897520961",
    ["Ribbons"] = "rbxassetid://132069507632161",
    ["Sakura"] = "rbxassetid://81755778619404",
    ["wings"] = "rbxassetid://97658130917593",
    ["Wind"] = "rbxassetid://80694081850877",
    ["Flow"] = "rbxassetid://119913533725648",
    ["Star"] = "rbxassetid://73754563740680",
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local particles = {}
local currentColor = Color3.fromRGB(255, 255, 255)
local currentAssetId = "rbxassetid://97658130917593"

local function UpdateAuraColors(color)
	currentColor = color or currentColor
	for _, particle in ipairs(particles) do
		if particle and particle.Parent then
			for _, emitter in ipairs(particle:GetDescendants()) do
				if emitter:IsA("ParticleEmitter") then
					emitter.Color = ColorSequence.new(currentColor)
				end
			end
		end
	end
end

local function applyAura(assetId)
	if assetId then
		currentAssetId = assetId
	end
	
	for i = #particles, 1, -1 do
		if particles[i] and particles[i].Parent then
			particles[i]:Destroy()
		end
	end
	particles = {}
	
	local character = LocalPlayer.Character
	if not character then return end
	
	local success, aura = pcall(function()
		return game:GetObjects(currentAssetId)[1]
	end)
	
	if not success or not aura then 
		warn("Failed to load aura asset")
		return 
	end
	
	for _, part in ipairs(aura:GetChildren()) do
		local targetPart = character:FindFirstChild(part.Name)
		if targetPart then
			for _, child in ipairs(part:GetChildren()) do
				child.Name = "\0\0"
				child.Parent = targetPart
				table.insert(particles, child)
			end
		end
	end
	
	aura:Destroy()
	UpdateAuraColors()
end

-- ====================== TẠO GUI ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AuraGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 520)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🌟 AURA SELECTOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- NÚT ĐÓNG GUI (✕)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- ====================== NÚT MỞ GUI LẠI (🌟) - LUÔN HIỂN THỊ ======================
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 60, 0, 60)
openButton.Position = UDim2.new(0, 20, 0, 20) -- Góc trên bên trái màn hình
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
openButton.Text = "🌟"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 30) -- Làm tròn hoàn toàn
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(100, 200, 255)
openStroke.Thickness = 3
openStroke.Parent = openButton

openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
end)

-- ScrollingFrame cho các nút Aura
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 0, 280)
scrolling.Position = UDim2.new(0, 10, 0, 70)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 6
scrolling.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
scrolling.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrolling

for auraName, assetId in pairs(particle_auras) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.Text = auraName
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamSemibold
	btn.Parent = scrolling
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		applyAura(assetId)
	end)
end

scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

-- Phần chọn màu
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -20, 0, 30)
colorLabel.Position = UDim2.new(0, 10, 0, 370)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "🎨 Chọn màu aura"
colorLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
colorLabel.TextScaled = true
colorLabel.Font = Enum.Font.GothamBold
colorLabel.Parent = mainFrame

local colorContainer = Instance.new("Frame")
colorContainer.Size = UDim2.new(1, -20, 0, 60)
colorContainer.Position = UDim2.new(0, 10, 0, 400)
colorContainer.BackgroundTransparency = 1
colorContainer.Parent = mainFrame

local colorList = Instance.new("UIListLayout")
colorList.FillDirection = Enum.FillDirection.Horizontal
colorList.Padding = UDim.new(0, 8)
colorList.HorizontalAlignment = Enum.HorizontalAlignment.Center
colorList.Parent = colorContainer

local colors = {
	{Color3.fromRGB(255,255,255), "Trắng"},
	{Color3.fromRGB(255,0,0), "Đỏ"},
	{Color3.fromRGB(0,255,0), "Xanh Lá"},
	{Color3.fromRGB(0,100,255), "Xanh Dương"},
	{Color3.fromRGB(255,255,0), "Vàng"},
	{Color3.fromRGB(255,0,255), "Hồng"},
	{Color3.fromRGB(0,255,255), "Cyan"},
	{Color3.fromRGB(180,0,255), "Tím"}
}

for _, data in ipairs(colors) do
	local colorBtn = Instance.new("TextButton")
	colorBtn.Size = UDim2.new(0, 45, 0, 45)
	colorBtn.BackgroundColor3 = data[1]
	colorBtn.Text = ""
	colorBtn.Parent = colorContainer
	
	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(0, 10)
	cCorner.Parent = colorBtn
	
	colorBtn.MouseButton1Click:Connect(function()
		UpdateAuraColors(data[1])
	end)
end

-- Nút Remove Aura
local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(1, -20, 0, 45)
removeBtn.Position = UDim2.new(0, 10, 0, 470)
removeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
removeBtn.Text = "🗑️ XÓA AURA"
removeBtn.TextColor3 = Color3.fromRGB(255,255,255)
removeBtn.TextScaled = true
removeBtn.Font = Enum.Font.GothamBold
removeBtn.Parent = mainFrame

local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0, 10)
rCorner.Parent = removeBtn

removeBtn.MouseButton1Click:Connect(function()
	for i = #particles, 1, -1 do
		if particles[i] and particles[i].Parent then
			particles[i]:Destroy()
		end
	end
	particles = {}
end)

-- ====================== TỰ ĐỘNG RE-APPLY ======================
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	applyAura()
end)

if LocalPlayer.Character then
	task.wait(1)
	applyAura()
end

print("✅ Aura GUI đã load thành công!")
print("   • Nhấn 🌟 (góc trên trái) để mở GUI")
print("   • Nhấn ✕ để đóng GUI")
