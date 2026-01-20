--[[
    MOUNT MAROHMOY EXECUTOR
    • Update: Nama UI menjadi "Mount Marohmoy"
    • Update: Koordinat Checkpoint 1-40 + Submit
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- === CHECKPOINT DATA (UPDATED: MOUNT MAROHMOY) ===
local checkpoints = {
    {name = "Checkpoint 1",  pos = Vector3.new(-743, 98, -832)},
    {name = "Checkpoint 2",  pos = Vector3.new(-211, 98, -869)},
    {name = "Checkpoint 3",  pos = Vector3.new(218, 246, -529)},
    {name = "Checkpoint 4",  pos = Vector3.new(277, 247, 139)},
    {name = "Checkpoint 5",  pos = Vector3.new(73, 346, 838)},
    {name = "Checkpoint 6",  pos = Vector3.new(-361, 350, 1361)},
    {name = "Checkpoint 7",  pos = Vector3.new(-836, 175, 757)},
    {name = "Checkpoint 8",  pos = Vector3.new(-966, 350, 885)},
    {name = "Checkpoint 9",  pos = Vector3.new(-1500, 318, 1089)},
    {name = "Checkpoint 10", pos = Vector3.new(-2377, 318, 1325)},
    {name = "Checkpoint 11", pos = Vector3.new(-2776, 152, 662)},
    {name = "Checkpoint 12", pos = Vector3.new(-2647, 291, -363)},
    {name = "Checkpoint 13", pos = Vector3.new(-2953, 586, -1155)},
    {name = "Checkpoint 14", pos = Vector3.new(-4014, 594, -1209)},
    {name = "Checkpoint 15", pos = Vector3.new(-4922, 694, -1457)},
    {name = "Checkpoint 16", pos = Vector3.new(-5892, 686, -1684)},
    {name = "Checkpoint 17", pos = Vector3.new(-7037, 722, -1680)},
    {name = "Checkpoint 18", pos = Vector3.new(-7792, 726, -1119)},
    {name = "Checkpoint 19", pos = Vector3.new(-8041, 878, -1324)},
    {name = "Checkpoint 20", pos = Vector3.new(-8383, 878, -1839)},
    {name = "Checkpoint 21", pos = Vector3.new(-8143, 878, -2896)},
    {name = "Checkpoint 22", pos = Vector3.new(-8362, 882, -3770)},
    {name = "Checkpoint 23", pos = Vector3.new(-8737, 906, -4406)},
    {name = "Checkpoint 24", pos = Vector3.new(-9130, 994, -4900)},
    {name = "Checkpoint 25", pos = Vector3.new(-9664, 1002, -5515)},
    {name = "Checkpoint 26", pos = Vector3.new(-10242, 1174, -5523)},
    {name = "Checkpoint 27", pos = Vector3.new(-11462, 1178, -5455)},
    {name = "Checkpoint 28", pos = Vector3.new(-12185, 1238, -5951)},
    {name = "Checkpoint 29", pos = Vector3.new(-12540, 1222, -6446)},
    {name = "Checkpoint 30", pos = Vector3.new(-12797, 1294, -6286)},
    {name = "Checkpoint 31", pos = Vector3.new(-13975, 1294, -6433)},
    {name = "Checkpoint 32", pos = Vector3.new(-14017, 1294, -7278)},
    {name = "Checkpoint 33", pos = Vector3.new(-14186, 1470, -7652)},
    {name = "Checkpoint 34", pos = Vector3.new(-14093, 1470, -8489)},
    {name = "Checkpoint 35", pos = Vector3.new(-14068, 1470, -9111)},
    {name = "Checkpoint 36", pos = Vector3.new(-13968, 1450, -9982)},
    {name = "Checkpoint 37", pos = Vector3.new(-13387, 1658, -10434)},
    {name = "Checkpoint 38", pos = Vector3.new(-12894, 1782, -10505)},
    {name = "Checkpoint 39", pos = Vector3.new(-12099, 1782, -10623)},
    {name = "Checkpoint 40", pos = Vector3.new(-11390, 1782, -10742)},
    {name = "Submit",        pos = Vector3.new(-10823, 2058, -12291)}
}

local currentStep = 1
local isAuto = false
local ActiveGradients = {} 
local UI_Active = true -- Penanda status UI

-- === HELPER FUNCTION ===
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

-- === SISTEM RGB OVERLAY ===
local function ApplyRGBBorder(target, cornerRadius, zIndex)
    local z = zIndex or 100
    
    local overlay = create("Frame", {
        Name = "RGB_Overlay",
        Parent = target,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = z 
    })
    
    if cornerRadius then
        create("UICorner", {Parent = overlay, CornerRadius = cornerRadius})
    end
    
    local stroke = create("UIStroke", {
        Parent = overlay,
        Thickness = 2,
        Color = Color3.new(1,1,1),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local gradient = create("UIGradient", {
        Parent = stroke,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 242, 255)),    
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(188, 19, 254)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 242, 255))       
        }),
        Rotation = 0
    })
    
    table.insert(ActiveGradients, gradient)
    return overlay
end

-- Loop Animasi (Safe Check)
task.spawn(function()
    while UI_Active do
        for _, grad in ipairs(ActiveGradients) do
            if grad and grad.Parent then
                grad.Rotation = grad.Rotation + 3
            end
        end
        task.wait(0.03)
    end
end)

-- Cleanup UI Lama
if getgenv().MountKitaUI then 
    getgenv().MountKitaUI:Destroy() 
    UI_Active = false 
end
UI_Active = true 

local ScreenGui = create("ScreenGui", {
    Name = "MountKitaUI",
    Parent = CoreGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global
})
getgenv().MountKitaUI = ScreenGui

-- === UI BUILD ===
local MainFrame = create("Frame", {
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(10, 10, 15),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 310, 0, 180),
    BorderSizePixel = 0
})
create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
ApplyRGBBorder(MainFrame, UDim.new(0, 6), 100)

-- Header
local Header = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    Size = UDim2.new(1, 0, 0, 30),
    BorderSizePixel = 0,
    ZIndex = 1
})
create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 6)})
create("Frame", {Parent=Header, BackgroundColor3=Color3.fromRGB(15,15,20), Size=UDim2.new(1,0,0,5), Position=UDim2.new(0,0,1,-5), BorderSizePixel=0})

local HeaderLine = create("Frame", {
    Parent = Header,
    BackgroundColor3 = Color3.new(1,1,1),
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BorderSizePixel = 0,
    ZIndex = 2
})
local hGrad = create("UIGradient", {Parent = HeaderLine, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,242,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(188,19,254))})})
table.insert(ActiveGradients, hGrad)

-- TITLE CHANGED HERE
local Title = create("TextLabel", {
    Parent = Header,
    Text = "Mount Marohmoy", -- UPDATED NAME
    TextColor3 = Color3.fromRGB(0, 242, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 12,
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 2
})

local CloseBtn = create("TextButton", {
    Parent = Header,
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 80, 80),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(1, -30, 0, 0),
    ZIndex = 2
})

local MinBtn = create("TextButton", {
    Parent = Header,
    Text = "-",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(1, -60, 0, 0),
    ZIndex = 2
})

-- === POPUP KONFIRMASI ===
local ConfirmFrame = create("Frame", {
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(10, 10, 15),
    Size = UDim2.new(0, 200, 0, 100),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Visible = false,
    ZIndex = 200
})
create("UICorner", {Parent = ConfirmFrame, CornerRadius = UDim.new(0, 8)})
ApplyRGBBorder(ConfirmFrame, UDim.new(0, 8), 201) 

local ConfirmText = create("TextLabel", {
    Parent = ConfirmFrame,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(0, 0, 0, 10),
    Text = "Keluar dari script?",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 202
})

local YesBtn = create("TextButton", {
    Parent = ConfirmFrame,
    BackgroundColor3 = Color3.fromRGB(30, 15, 15),
    Size = UDim2.new(0.4, 0, 0, 30),
    Position = UDim2.new(0.1, 0, 0.6, 0),
    Text = "YES",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false,
    ZIndex = 202
})
create("UICorner", {Parent = YesBtn, CornerRadius = UDim.new(0, 4)})
ApplyRGBBorder(YesBtn, UDim.new(0, 4), 203)

local NoBtn = create("TextButton", {
    Parent = ConfirmFrame,
    BackgroundColor3 = Color3.fromRGB(15, 30, 15),
    Size = UDim2.new(0.4, 0, 0, 30),
    Position = UDim2.new(0.5, 0, 0.6, 0),
    Text = "NO",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false,
    ZIndex = 202
})
create("UICorner", {Parent = NoBtn, CornerRadius = UDim.new(0, 4)})
create("UIStroke", {Parent = NoBtn, Thickness=1, Color=Color3.fromRGB(80,80,80)})

-- Body
local Body = create("Frame", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 30),
    Size = UDim2.new(1, 0, 1, -30),
    ZIndex = 1
})

local LeftPanel = create("Frame", {
    Parent = Body,
    BackgroundColor3 = Color3.fromRGB(12, 12, 18),
    Size = UDim2.new(0, 110, 1, 0),
    BorderSizePixel = 0
})
local VLine = create("Frame", {
    Parent = LeftPanel,
    BackgroundColor3 = Color3.new(1,1,1),
    Size = UDim2.new(0, 1, 1, 0),
    Position = UDim2.new(1, -1, 0, 0),
    BorderSizePixel = 0
})
local vGrad = create("UIGradient", {Parent = VLine, Rotation = 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,242,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(188,19,254))})})
table.insert(ActiveGradients, vGrad)

local TopContainer = create("Frame", {
    Parent = LeftPanel,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0, 0)
})
create("UIPadding", {Parent=TopContainer, PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)})

local ManLabel = create("TextLabel", {
    Parent = TopContainer,
    Text = "MANUAL",
    TextColor3 = Color3.fromRGB(0, 242, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

local NavRow = create("Frame", {
    Parent = TopContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0, 16)
})

local PrevBtn = create("TextButton", {
    Parent = NavRow,
    Text = "PREV",
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(20,20,30),
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    AutoButtonColor = true
})
create("UICorner", {Parent=PrevBtn, CornerRadius=UDim.new(0,4)})
ApplyRGBBorder(PrevBtn, UDim.new(0,4), 100)

local NextBtn = create("TextButton", {
    Parent = NavRow,
    Text = "NEXT",
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(20,20,30),
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    AnchorPoint = Vector2.new(1, 0)
})
create("UICorner", {Parent=NextBtn, CornerRadius=UDim.new(0,4)})
ApplyRGBBorder(NextBtn, UDim.new(0,4), 100)

local Div = create("Frame", {
    Parent = LeftPanel,
    BackgroundColor3 = Color3.new(1,1,1),
    Size = UDim2.new(0.8, 0, 0, 1),
    Position = UDim2.new(0.1, 0, 0, 60),
    BorderSizePixel = 0
})
local dGrad = create("UIGradient", {Parent = Div, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,242,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(188,19,254))})})
table.insert(ActiveGradients, dGrad)

local BottomContainer = create("Frame", {
    Parent = LeftPanel,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, -65),
    Position = UDim2.new(0, 0, 0, 65)
})
create("UIPadding", {Parent=BottomContainer, PaddingTop=UDim.new(0,5), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)})

local DelayBox = create("Frame", {
    Parent = BottomContainer,
    BackgroundColor3 = Color3.fromRGB(15,15,20),
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 0)
})
create("UICorner", {Parent=DelayBox, CornerRadius=UDim.new(0,4)})
ApplyRGBBorder(DelayBox, UDim.new(0,4), 100)

local DelayLbl = create("TextLabel", {
    Parent = DelayBox,
    Text = "Delay (s)",
    TextColor3 = Color3.fromRGB(180,180,180),
    TextSize = 9,
    Font = Enum.Font.Gotham,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 40, 1, 0),
    Position = UDim2.new(0, 4, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left
})

local DelayInput = create("TextBox", {
    Parent = DelayBox,
    Text = "1.5",
    TextColor3 = Color3.fromRGB(0, 242, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(1, -30, 0, 0),
    ZIndex = 50
})

local AutoBox = create("Frame", {
    Parent = BottomContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -35)
})

local AutoLbl = create("TextLabel", {
    Parent = AutoBox,
    Text = "AUTO",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    Size = UDim2.new(0, 40, 1, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ToggleBg = create("TextButton", {
    Parent = AutoBox,
    BackgroundColor3 = Color3.fromRGB(20,20,30),
    Size = UDim2.new(0, 36, 0, 16),
    Position = UDim2.new(1, 0, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    AutoButtonColor = false,
    Text = ""
})
create("UICorner", {Parent=ToggleBg, CornerRadius=UDim.new(1,0)})
ApplyRGBBorder(ToggleBg, UDim.new(1,0), 100)

local ToggleCircle = create("Frame", {
    Parent = ToggleBg,
    BackgroundColor3 = Color3.fromRGB(150,150,150),
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(0, 2, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    ZIndex = 110
})
create("UICorner", {Parent=ToggleCircle, CornerRadius=UDim.new(1,0)})

local RightPanel = create("ScrollingFrame", {
    Parent = Body,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 110, 0, 0),
    Size = UDim2.new(1, -110, 1, 0),
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(188, 19, 254),
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})
create("UIPadding", {Parent=RightPanel, PaddingTop=UDim.new(0,5), PaddingLeft=UDim.new(0,5), PaddingRight=UDim.new(0,5)})
local ListLayout = create("UIListLayout", {Parent=RightPanel, Padding=UDim.new(0,2)})

-- === LOGIC ===
local Toast = create("TextLabel", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.4,
    TextColor3 = Color3.fromRGB(0, 242, 255),
    Text = "Ready",
    Size = UDim2.new(0, 100, 0, 20),
    Position = UDim2.new(0.5, 0, 0.9, 0),
    AnchorPoint = Vector2.new(0.5, 1),
    Visible = false,
    ZIndex = 200
})
create("UICorner", {Parent=Toast, CornerRadius=UDim.new(0,10)})

local function showToast(msg)
    if not UI_Active then return end
    Toast.Text = msg
    Toast.Visible = true
    task.delay(1.5, function() 
        if UI_Active and Toast then Toast.Visible = false end 
    end)
end

local listItems = {}
local function updateSelection(idx)
    if not UI_Active then return end
    
    if idx > 3 and RightPanel then
        RightPanel.CanvasPosition = Vector2.new(0, (idx-3) * 27)
    elseif RightPanel then
        RightPanel.CanvasPosition = Vector2.new(0, 0)
    end

    for i, item in pairs(listItems) do
        if i == idx then
            item.Bar.Visible = true
            item.BG.BackgroundTransparency = 0.85
            item.BG.BackgroundColor3 = Color3.fromRGB(188, 19, 254)
            item.Text.TextColor3 = Color3.new(1,1,1)
        else
            item.Bar.Visible = false
            item.BG.BackgroundTransparency = 1
            item.Text.TextColor3 = Color3.fromRGB(150,150,150)
        end
    end
end

local function findNearestCheckpoint()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return 1 end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local closestDist = math.huge
    local closestIndex = 1
    for i, cp in ipairs(checkpoints) do
        local dist = (hrp.Position - cp.pos).Magnitude
        if dist < closestDist then closestDist = dist closestIndex = i end
    end
    return closestIndex
end

local function teleportTo(idx)
    if not UI_Active then return end
    if idx < 1 or idx > #checkpoints then return end
    currentStep = idx
    updateSelection(idx)
    local cp = checkpoints[idx]
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.pos)
        showToast("TP: " .. cp.name)
    end
end

for i, cp in ipairs(checkpoints) do
    local btn = create("TextButton", {
        Parent = RightPanel, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Text = "", AutoButtonColor = false
    })
    local bar = create("Frame", {
        Parent = btn, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 3, 0.8, 0), Position = UDim2.new(0, 0, 0.1, 0), Visible = false, BorderSizePixel = 0
    })
    local bGrad = create("UIGradient", {Parent = bar, Color = ColorSequence.new(Color3.fromRGB(0,242,255), Color3.fromRGB(188,19,254)), Rotation = 90})
    table.insert(ActiveGradients, bGrad)

    local txt = create("TextLabel", {
        Parent = btn, BackgroundTransparency = 1, Text = cp.name, TextColor3 = Color3.fromRGB(150,150,150), TextSize = 10, Font = Enum.Font.GothamSemibold, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left
    })
    listItems[i] = {BG = btn, Bar = bar, Text = txt}
    btn.MouseButton1Click:Connect(function() teleportTo(i) end)
end

PrevBtn.MouseButton1Click:Connect(function()
    local n = currentStep - 1
    if n < 1 then n = #checkpoints end
    teleportTo(n)
end)

NextBtn.MouseButton1Click:Connect(function()
    local n = currentStep + 1
    if n > #checkpoints then n = 1 end
    teleportTo(n)
end)

ToggleBg.MouseButton1Click:Connect(function()
    isAuto = not isAuto
    if isAuto then
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(0, 242, 255)}):Play()
        
        local nearest = findNearestCheckpoint()
        currentStep = nearest 
        updateSelection(currentStep)
        teleportTo(currentStep) 
        
        task.wait(tonumber(DelayInput.Text) or 1.5)

        task.spawn(function()
            while isAuto and UI_Active do
                if currentStep < #checkpoints then
                    currentStep = currentStep + 1
                    teleportTo(currentStep)
                    task.wait(tonumber(DelayInput.Text) or 1.5)
                else
                    isAuto = false
                    if UI_Active then
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.fromRGB(150,150,150)}):Play()
                        showToast("Finished!")
                    end
                    break
                end
            end
        end)
    else
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDi
