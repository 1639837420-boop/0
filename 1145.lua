local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "男娘",
    Author = "男酿",
    Folder = "MyScript",
    Size = UDim2.new(0, 580, 0, 460),
    Icon = "rocket",
    Theme = "Dark",
    KeySystem = nil,
})

local MainTab = Window:Tab({
    Title = "主要功能",
    Icon = "home",
})

MainTab:Paragraph({
    Title = "欢迎使用！",
    Desc = "这是一个基于 WindUI 的脚本示例\n包含飞行、跳跃、速度调节等功能",
})

local ControlSection = MainTab:Section({
    Title = "玩家控制",
})

local flyEnabled = false
local flySpeed = 50
ControlSection:Toggle({
    Title = "飞行模式",
    Desc = "按 WASD 移动，空格上升，Shift 下降",
    Icon = "wing",
    Value = false,
    Callback = function(state)
        flyEnabled = state
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            if state then
                hum.PlatformStand = true
                local runService = game:GetService("RunService")
                local connection
                connection = runService.Heartbeat:Connect(function()
                    if flyEnabled and char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local moveDir = Vector3.new(0, 0, 0)
                        local userInput = game:GetService("UserInputService")
                        if userInput:IsKeyDown(Enum.KeyCode.Space) then
                            moveDir = moveDir + Vector3.new(0, 1, 0)
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                            moveDir = moveDir + Vector3.new(0, -1, 0)
                        end
                        local forward = root.CFrame.LookVector
                        local right = root.CFrame.RightVector
                        if userInput:IsKeyDown(Enum.KeyCode.W) then
                            moveDir = moveDir + forward
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.S) then
                            moveDir = moveDir - forward
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.A) then
                            moveDir = moveDir - right
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.D) then
                            moveDir = moveDir + right
                        end
                        if moveDir.Magnitude > 0 then
                            root.Velocity = moveDir.Unit * flySpeed
                        else
                            root.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end)
                char:SetAttribute("FlyConnection", connection)
            else
                hum.PlatformStand = false
                if char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
                local conn = char:GetAttribute("FlyConnection")
                if conn then conn:Disconnect() end
            end
        end
    end
})

ControlSection:Toggle({
    Title = "无限跳跃",
    Desc = "在空中可以连续跳跃",
    Icon = "arrow-up",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            if state then
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum.JumpPower = 50
                local connection
                connection = hum.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.Jumping and state then
                        hum.Jump = true
                    end
                end)
                char:SetAttribute("JumpConnection", connection)
            else
                hum.JumpPower = 50
                local conn = char:GetAttribute("JumpConnection")
                if conn then conn:Disconnect() end
            end
        end
    end
})

ControlSection:Slider({
    Title = "移动速度",
    Desc = "调整角色行走速度",
    Icon = "gauge",
    Value = {
        Min = 16,
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

local UtilityTab = Window:Tab({
    Title = "工具",
    Icon = "wrench",
})

UtilityTab:Paragraph({
    Title = "实用工具",
    Desc = "各种辅助功能",
})

UtilityTab:Button({
    Title = "传送至鼠标位置",
    Desc = "点击后角色瞬移到鼠标指向的位置",
    Icon = "mouse-pointer-click",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local mouse = player:GetMouse()
        if char and char:FindFirstChild("HumanoidRootPart") and mouse then
            local target = mouse.Hit.p
            char.HumanoidRootPart.CFrame = CFrame.new(target)
            Window:Notify({
                Title = "传送成功",
                Content = "已传送到鼠标位置",
                Icon = "check",
                Duration = 2,
            })
        end
    end
})

UtilityTab:Button({
    Title = "重置角色",
    Desc = "重生角色",
    Icon = "refresh-cw",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

UtilityTab:Button({
    Title = "反偷窥 (Kick Others)",
    Desc = "将其他玩家踢出游戏（部分游戏可能无效）",
    Icon = "user-x",
    Callback = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                player.Character:BreakJoints()
            end
        end
        Window:Notify({
            Title = "反偷窥",
            Content = "已尝试踢出其他玩家",
            Icon = "users",
            Duration = 3,
        })
    end
})

local SettingsTab = Window:Tab({
    Title = "设置",
    Icon = "settings",
})

SettingsTab:Paragraph({
    Title = "UI 设置",
    Desc = "调整界面外观",
})

SettingsTab:Dropdown({
    Title = "主题",
    Desc = "切换 WindUI 主题",
    Values = {
        "Dark", "Light", "Rose", "Plant", "Red",
        "Indigo", "Sky", "Violet", "Amber", "Emerald",
        "Midnight", "Crimson", "MonokaiPro", "CottonCandy",
        "Mellowsi", "Rainbow",
    },
    Value = "Dark",
    Callback = function(value)
        WindUI:SetTheme(value)
        Window:Notify({
            Title = "主题切换",
            Content = "当前主题: " .. value,
            Icon = "palette",
            Duration = 2,
        })
    end
})

SettingsTab:Toggle({
    Title = "透明模式",
    Desc = "使窗口背景半透明",
    Icon = "eye",
    Value = false,
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})

local InfoTab = Window:Tab({
    Title = "信息",
    Icon = "info",
})

InfoTab:Paragraph({
    Title = "脚本信息",
    Desc = "WindUI 版本: " .. WindUI.Version .. "\n注入器: " .. (identifyexecutor and identifyexecutor() or "未知"),
})

InfoTab:Button({
    Title = "关闭脚本",
    Desc = "销毁 UI 并退出",
    Icon = "power",
    Callback = function()
        Window:Destroy()
    end
})

print("✅ 脚本已加载！按 F2 开关窗口")