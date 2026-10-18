-- CharacterAnimations.server.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load animations from ReplicatedStorage
local walkingAnim = Instance.new("Animation")
walkingAnim.AnimationId = "rbxassetid://YOUR_WALKING_ANIMATION_ID"

local respawnAnim = Instance.new("Animation")
respawnAnim.AnimationId = "rbxassetid://YOUR_RESPAWN_ANIMATION_ID"

local mageRunAnim = Instance.new("Animation")
mageRunAnim.AnimationId = "rbxassetid://YOUR_MAGE_RUN_ANIMATION_ID"

local jumpAnim = Instance.new("Animation")
jumpAnim.AnimationId = "rbxassetid://YOUR_JUMP_ANIMATION_ID"

local climbAnim = Instance.new("Animation")
climbAnim.AnimationId = "rbxassetid://YOUR_CLIMB_ANIMATION_ID"

local ninjaSwimAnim = Instance.new("Animation")
ninjaSwimAnim.AnimationId = "rbxassetid://YOUR_NINJA_SWIM_ANIMATION_ID"

-- Function to play animation
local function playAnimation(character, animation)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator", humanoid)
        end
        
        local animTrack = animator:LoadAnimation(animation)
        animTrack:Play()
        
        -- Ensure respawn animation is visible to others
        if animation == respawnAnim then
            animTrack.Priority = Enum.AnimationPriority.Action
        end
        
        return animTrack
    end
    
    return nil
end

-- Function to handle character added
local function onCharacterAdded(character)
    -- Play walking animation by default
    playAnimation(character, walkingAnim)
    
    -- Set up animation triggers
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            playAnimation(character, respawnAnim)
        end)
        
        humanoid.Jumping:Connect(function()
            playAnimation(character, jumpAnim)
        end)
        
        humanoid.Climbing:Connect(function(state)
            if state == Enum.HumanoidStateType.Climbing then
                playAnimation(character, climbAnim)
            end
        end)
        
        humanoid.Swimming:Connect(function(state)
            if state == Enum.HumanoidStateType.Swimming then
                playAnimation(character, ninjaSwimAnim)
            end
        end)
    end
end

-- Function to handle player added
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- If the player already has a character, handle it
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Connect to player events
Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle existing players
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Function to handle mage run command
local function onMageRun(player)
    if player.Character then
        playAnimation(player.Character, mageRunAnim)
    end
end

-- Set up remote event for mage run command
local mageRunEvent = Instance.new("RemoteEvent", ReplicatedStorage)
mageRunEvent.Name = "MageRunEvent"

mageRunEvent.OnServerEvent:Connect(onMageRun)

-- MageRunCommand.client.lua (Client-side script for triggering mage run animation from a button or key press)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mageRunEvent = ReplicatedStorage:WaitForChild("MageRunEvent")

-- Function to trigger mage run animation
local function triggerMageRun()
    mageRunEvent:FireServer()
end

-- Example: Trigger mage run animation when a button is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
        triggerMageRun()
    end
end)
