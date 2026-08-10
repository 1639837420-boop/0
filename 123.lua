local RainbowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YJY2022hh666/yjy/main/rainbow.ui.main.lua?token=GHSAT0AAAAAACESL5MYP6BL6PJ45CVEZRQEZFYXXUA", true))()
local window = RainbowLib:new("男娘")

local mainTab = window:Tab("Main", '6035145364')
local mainSection = mainTab:section("Control", true)

local flying = false
local flySpeed = 50
mainSection:Toggle("Fly", "", false, function(state)
    flying = state
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        if state then
            hum.PlatformStand = true
            game:GetService("RunService").Heartbeat:Connect(function()
                if flying and char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local moveDir = Vector3.new(0, 0, 0)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDir = moveDir + Vector3.new(0, -1, 0)
                    end
                    local forward = root.CFrame.LookVector
                    local right = root.CFrame.RightVector
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + forward
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - forward
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - right
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + right
                    end
                    if moveDir.Magnitude > 0 then
                        root.Velocity = moveDir.Unit * flySpeed
                    else
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        else
            hum.PlatformStand = false
            if char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

mainSection:Toggle("Inf Jump", "", false, function(state)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        if state then
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum.JumpPower = 50
            local jumpConn
            jumpConn = hum.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Jumping and state then
                    hum.Jump = true
                end
            end)
            if not char:FindFirstChild("JumpConn") then
                local conn = Instance.new("BoolValue")
                conn.Name = "JumpConn"
                conn.Value = true
                conn.Parent = char
                conn:SetAttribute("Connection", jumpConn)
            end
        else
            hum.JumpPower = 50
            if char:FindFirstChild("JumpConn") then
                local conn = char.JumpConn:GetAttribute("Connection")
                if conn then conn:Disconnect() end
                char.JumpConn:Destroy()
            end
        end
    end
end)

mainSection:Slider("Speed", 16, 100, 16, function(value)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

local extraTab = window:Tab("Extra", '6035145364')
local extraSection = extraTab:section("Utility", true)

extraSection:Button("Teleport to Mouse", function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local mouse = player:GetMouse()
    if char and char:FindFirstChild("HumanoidRootPart") and mouse then
        char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p)
    end
end)

extraSection:Button("Reset Char", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)