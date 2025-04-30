repeat wait() until game:IsLoaded()

-- Anti AFK
spawn(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Function: Check and attack Rip Indra
function attackRipIndra()
    local enemies = workspace.Enemies:GetChildren()
    for _, enemy in ipairs(enemies) do
        if enemy.Name:find("Rip Indra") and enemy:FindFirstChild("HumanoidRootPart") then
            repeat
                wait()
                pcall(function()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                end)
            until not enemy.Parent or enemy.Humanoid.Health <= 0
            return true
        end
    end
    return false
end

-- Function: Hop server
function hop()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=2&limit=100")
    local data = HttpService:JSONDecode(req)

    for i, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
    else
        warn("Không tìm thấy server mới.")
    end
end

-- Main loop
spawn(function()
    while wait(5) do
        local found = attackRipIndra()
        if not found then
            hop()
            wait(10)
        end
    end
end)
