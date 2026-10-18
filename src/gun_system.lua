-- Gun system script for the Roblox game

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local playerData = {}
local gunModels = {
    Pistol = ReplicatedStorage:WaitForChild("PistolModel"),
    Shotgun = ReplicatedStorage:WaitForChild("ShotgunModel"),
    Rifle = ReplicatedStorage:WaitForChild("RifleModel")
}

-- Functions
local function onPlayerAdded(player)
    -- Initialize player gun data
    playerData[player] = {
        money = 0,
        guns = {
            Pistol = {
                level = 1,
                damage = 10,
                fireRate = 0.5
            }
        }
    }

    -- Give player a starting pistol
    local gun = gunModels.Pistol:Clone()
    gun.Parent = player.Character
    gun.Handle:FindFirstChild("ClickDetector").MouseClick:Connect(function()
        shoot(player, "Pistol")
    end)
end

local function onPlayerRemoving(player)
    -- Clean up player gun data
    playerData[player] = nil
end

local function shoot(player, gunType)
    if playerData[player] and playerData[player].guns[gunType] then
        local gunData = playerData[player].guns[gunType]
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            -- Create a bullet
            local bullet = Instance.new("Part")
            bullet.Size = Vector3.new(0.2, 0.2, 1)
            bullet.Position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 2
            bullet.CFrame = CFrame.new(bullet.Position, bullet.Position + humanoidRootPart.CFrame.LookVector)
            bullet.Anchored = false
            bullet.CanCollide = false
            bullet.Parent = workspace

            -- Apply bullet velocity
            local bodyVelocity = Instance.new("BodyVelocity", bullet)
            bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 100
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)

            -- Handle bullet collision
            bullet.Touched:Connect(function(hit)
                if hit.Parent:FindFirstChild("Humanoid") then
                    -- Damage the zombie
                    hit.Parent.Humanoid:TakeDamage(gunData.damage)
                end
                bullet:Destroy()
            end)

            -- Destroy bullet after a delay
            delay(5, function()
                if bullet then
                    bullet:Destroy()
                end
            end)
        end
    end
end

local function upgradeGun(player, gunType)
    if playerData[player] and playerData[player].guns[gunType] then
        local gunData = playerData[player].guns[gunType]
        local upgradeCost = gunData.level * 100

        if playerData[player].money >= upgradeCost then
            playerData[player].money = playerData[player].money - upgradeCost
            gunData.level = gunData.level + 1
            gunData.damage = gunData.damage + 5
            gunData.fireRate = gunData.fireRate * 0.9

            -- Update gun display or other visual feedback
            print(player.Name .. " upgraded " .. gunType .. " to level " .. gunData.level)
        else
            print(player.Name .. " does not have enough money to upgrade " .. gunType)
        end
    end
end

-- Event connections
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Example usage: upgradeGun(player, "Pistol")