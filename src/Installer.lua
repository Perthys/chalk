-- Run in Roblox Studio Console
local HttpService = game:GetService("HttpService"); 
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LastValue = HttpService.HttpEnabled

HttpService.HttpEnabled = true

local Request = HttpService:RequestAsync({
    Url = "https://raw.githubusercontent.com/Perthys/chalk/main/source/main.lua";
    Method = "GET";
});

HttpService.HttpEnabled = LastValue

if Request.Success and Request.StatusCode == 200 then
    local ChalkModule = Instance.new("ModuleScript");
    ChalkModule.Name = "Chalk";
    ChalkModule.Parent = ReplicatedStorage;
    ChalkModule.Source = Request.Body

    print("Successfully installed Chalk module. At:", ChalkModule);
else
    error("Failed to install Chalk module.");
end
