-- 🔁 Auto Chest Farm Logic
local function ChestFarmLoop()
    while Farming and task.wait(0.5) do
        local chests = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("MeshPart") and v.Name:lower():match("chest") and v:FindFirstChildOfClass("TouchTransmitter") then
                table.insert(chests, v)
            elseif v:IsA("ProximityPrompt") and v.Parent and v.Parent.Name:lower():match("chest") then
                table.insert(chests, v.Parent)
            elseif v:IsA("ClickDetector") and v.Parent and v.Parent.Name:lower():match("chest") then
                table.insert(chests, v.Parent)
            end
        end

        if #chests > 0 then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, chest in pairs(chests) do
                if not Farming then break end
                if chest:IsA("BasePart") and hrp then
                    local dist = (hrp.Position - chest.Position).Magnitude
                    if dist < 200 then -- only if chest is nearby
                        TweenTo(chest.Position)
                        wait(0.3)

                        -- 🟨 Try to trigger open
                        local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt)
                        end

                        local click = chest:FindFirstChildWhichIsA("ClickDetector", true)
                        if click then
                            fireclickdetector(click)
                        end
                    end
                end
            end
        end
    end
end
