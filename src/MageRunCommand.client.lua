-- MageRunCommand.client.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mageRunEvent = ReplicatedStorage:WaitForChild("MageRunEvent")

-- Function to handle mage run command
local function onMageRun()
    mageRunEvent:FireServer()
end

-- Set up key press event
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.R then
            onMageRun()
        end
    end
end)