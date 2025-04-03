--[[nothin to see here fn]]--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Ensure the user provides a webhook
if not getgenv().Webhook or getgenv().Webhook == "" then
    Players.LocalPlayer:Kick("No Webhook Found. Please enter a webhook.")
    return
end

local player = Players.LocalPlayer

-- Wait for leaderstats to load
repeat task.wait() until player:FindFirstChild("leaderstats")

local leaderstats = player:FindFirstChild("leaderstats")
local diamondStat = leaderstats and leaderstats:FindFirstChild("💎 Diamonds")
local lastDiamondValue = diamondStat and diamondStat.Value or 0

-- Create a script loaded notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Loaded";
    Text = "Diamond Checker is now running!";
    Duration = 5;
})

local function sendWebhookMessage(amountGained)
    local data = {
        embeds = {
            {
                title = "+1 Million Diamonds Obtained!",
                description = "A player has gained more diamonds!",
                color = 65280,  -- Green color
                fields = {
                    { name = "Username", value = player.Name, inline = true },
                    { name = "Display Name", value = player.DisplayName, inline = true },
                    { name = "New Diamond Value", value = tostring(diamondStat.Value), inline = true },
                    { name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = false }
                }
            }
        }
    }
    
    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(getgenv().Webhook, jsonData, Enum.HttpContentType.ApplicationJson)
end

local function checkDiamonds()
    if not diamondStat then return end
    
    local currentValue = diamondStat.Value
    if currentValue - lastDiamondValue >= 1000000 then
        sendWebhookMessage(currentValue - lastDiamondValue)
        lastDiamondValue = currentValue
        task.wait(900)  -- Wait 15 minutes before checking again
    end
end

-- Continuously check for diamond increase
while task.wait(1) do
    checkDiamonds()
end
