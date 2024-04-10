local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Sources.Packages.Knit);
local Promise = require(ReplicatedStorage.Sources.Packages.Promise);

local Map = Workspace:WaitForChild("Map");
local Crates: Folder = Map.Crates;

local Objects = require(ServerStorage.Sources.Modules.Objects)

local CratesService = Knit.CreateService{
    Name = "CrateService";
    Client = {
        OpenCrate = Knit.CreateSignal();
    };
}
function CratesService:KnitStart()
    print("CrateService");
    for _,v in pairs(Crates:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v:SetAttribute("Open", false);
            v.Triggered:Connect(function(Player)
                self.Client.OpenCrate:Fire(Player);
                local Open = v:GetAttribute("Open");
                if Open ~= true then
                    local tap: Part = v.Parent
                    tap:PivotTo(tap:GetPivot() * CFrame.Angles(math.rad(30), 0, 0));
                    v:SetAttribute("Open", true);
                    local ObtainedIndex = math.random(1, #Objects);
                    local Obtained = Objects[ObtainedIndex];
                    if Obtained == "Coins" then
                        local RandomCoins = math.random(1, 10);
                        print(RandomCoins.. " "..Obtained);
                    elseif Obtained == "Nothing" then
                        print("u dont get nothing");
                        return
                    else
                        print(Obtained);
                    end
                else
                    print("Crate r open ");
                end
            end)
        end
    end
end

return CratesService