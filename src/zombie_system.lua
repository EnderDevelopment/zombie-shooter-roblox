-- Zombie system script for the Roblox game

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local zombies = {}
local zombieModel = ReplicatedStorage:WaitForChild("ZombieModel")

-- Functions
local function spawnZombie()
    local zombie = zombieModel:Clone()
    zombie.Parent = workspace
    zombie.Humanoid.WalkSpeed = 10
    zombie.Humanoid.MaxHealth = 100
    zombie.Humanoid.Health = 100

    -- Set up zombie behavior
    local function onZombieDeath()
        -- Add experience to players who killed the zombie
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - zombie.HumanoidRootPart.Position).Magnitude
                if distance < 20 then
                    -- Add experience based on distance
                    local experience = math.max(10, 100 - distance)
                    addExperience(player, experience)
                end
            end
        end

        -- Remove zombie
        zombie:Destroy()
        zombies[zombie] = nil
    end

    zombie.Humanoid.Died:Connect(onZombieDeath)
    zombies[zombie] = true
end

-- Main zombie spawning loop
while true do
    -- Spawn a new zombie every 5 seconds
    spawnZombie()
    wait(5)
end