------------------------------------
-- โหลดและตั้งค่า client
------------------------------------
if getgenv().client == nil then
    getgenv().client = {}

    for _, v in next, getgc() do
        if type(v) == "function" and islclosure(v) then
            local sc = tostring(getfenv(v).script)
            if sc ~= nil and sc == "PanClient" then
                if getinfo(v).name == "stopDigging" then
                    client.originalstopdigging = clonefunction(v)
                end
                client[getinfo(v).name] = v
            end
        end
    end
end

client.getpan = function()
    for _, v in next, game.Players.LocalPlayer.Backpack:GetChildren() do
        if v.Name:lower():find("pan") then
            return v
        end
    end
    return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

client.oldpn = client.getpan().Name

setconstant(client.startPanning, 29, "Panningg")
setconstant(client.startDigging, 15, -9e9)
setconstant(client.startDigging, 39, -9e9)
setconstant(client.startDigging, 60, -9e9)
setconstant(client.shake, 18, -9e9)

pcall(function()
    setconstant(client.toggleCamera, 12, 0)
    hookfunction(client.toggleCamera, function() end)
end)

hookfunction(client.stopDigging, function()
    getupvalue(client.originalstopdigging, 1):Stop(0)
    getupvalue(client.originalstopdigging, 2):Stop(0)
    setupvalue(client.originalstopdigging, 3, false)
    setupvalue(client.originalstopdigging, 4, false)
    getupvalue(client.originalstopdigging, 5).DigBar.Visible = false
    getupvalue(client.originalstopdigging, 6).WalkSpeed = 16
    getupvalue(client.originalstopdigging, 6).JumpPower = 50
    getupvalue(client.originalstopdigging, 6).AutoRotate = true
    getupvalue(client.originalstopdigging, 7):FireServer(false)
end)

setconstant(client.startDigging, 41, "workspace")
setconstant(client.startDigging, 43, "Archivable")
setconstant(client.startDigging, 44, 9e9)

------------------------------------
-- สคริปต์หลัก
------------------------------------
_G.DiggingSpeed = 0.001
_G.HM = client.startDigging
_G.HE = client.startPanning
_G.HA = client.shake
_G.YA = client.updatePosition
_G.HI = getupvalue(_G.YA, 1).GetPanningRegion
_G.NO = getupvalue(_G.YA, 2)
_G.HO = getupvalue(_G.HA, 5)

_G.NO.Parent.Humanoid.WalkSpeed = 26
_G.NO.Anchored = false
_G.NO.Parent.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    _G.NO.Parent.Humanoid.WalkSpeed = 26
end)

_G.NO:GetPropertyChangedSignal("Anchored"):Connect(function()
    _G.NO.Anchored = false
end)

------------------------------------
-- UI Wall V3
------------------------------------
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local w = library:CreateWindow("Prospecting")
local b = w:CreateFolder("Automation")

b:Label("x2Swiftz",{
    TextSize = 25;
    TextColor = Color3.fromRGB(255,255,255);
    BgColor = Color3.fromRGB(69,69,69);
}) 

-- Toggle Auto Shake
_G.AutoShake = false
b:Toggle("Auto Shake", function(bool)
    _G.AutoShake = bool
end)

-- Toggle Auto Digging
_G.AutoDig = false
b:Toggle("Auto Digging", function(bool)
    _G.AutoDig = bool
end)

b:DestroyGui()

task.spawn(function()
    local RS = game:GetService("RunService")
    while task.wait() do
        RS.Heartbeat:Wait()
        if _G.AutoShake and client.oldpn == client.getpan().Name then
            _G.HO:FireServer()
            game:GetService("Players").LocalPlayer.PlayerGui.ToolUI.FillingPan.Visible = true
            _G.NO.Parent.Humanoid.WalkSpeed = 26
            _G.NO.Anchored = false
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoDig and client.oldpn == client.getpan().Name then
            setupvalue(_G.HM, 4, false)
            task.delay(_G.DiggingSpeed, function()
                _G.HM()
            end)
            if _G.HI(_G.NO.Position) == "Water" then
                _G.HE()
            end
        end
    end
end)

task.delay(0.1, function()
    getgenv().client = nil
end)
