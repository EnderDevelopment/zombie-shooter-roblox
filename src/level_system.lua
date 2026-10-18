-- Level system script for the Roblox game

-- Services
local Players = game:GetService("Players")

-- Variables
local playerData = {}

-- Functions
local function onPlayerAdded(player)
    -- Initialize player level data
    playerData[player] = {
        level = 1,
        experience = 0,
        experienceToNextLevel = 100
    }

    -- Set up player level display
    local levelDisplay = Instance.new("BillboardGui", player.Character:WaitForChild("Head"))
    levelDisplay.Name = "LevelDisplay"
    levelDisplay.Size = UDim2.new(0, 100, 0, 50)
    levelDisplay.StudsOffset = Vector3.new(0, 2, 0)
    levelDisplay.AlwaysOnTop = true

    local levelText = Instance.new("TextLabel", levelDisplay)
    levelText.Name = "LevelText"
    levelText.Size = UDim2.new(1, 0, 1, 0)
    levelText.Text = "Level: " .. playerData[player].level
    levelText.TextColor3 = Color3.new(1, 1, 1)
    levelText.BackgroundTransparency = 1
    levelText.TextScaled = true
end

local function onPlayerRemoving(player)
    -- Clean up player level data
    playerData[player] = nil
end

local function addExperience(player, amount)
    if playerData[player] then
        playerData[player].experience = playerData[player].experience + amount

        -- Check if player leveled up
        if playerData[player].experience >= playerData[player].experienceToNextLevel then
            playerData[player].level = playerData[player].level + 1
            playerData[player].experience = playerData[player].experience - playerData[player].experienceToNextLevel
            playerData[player].experienceToNextLevel = playerData[player].experienceToNextLevel * 1.5

            -- Update level display
            local levelDisplay = player.Character:FindFirstChild("Head"):FindFirstChild("LevelDisplay")
            if levelDisplay then
                local levelText = levelDisplay:FindFirstChild("LevelText")
                if levelText then
                    levelText.Text = "Level: " .. playerData[player].level
                end
            end
        end
    end
end

-- Event connections
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Example usage: addExperience(player, 50)