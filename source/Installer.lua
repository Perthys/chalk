local HttpService = game:GetService("HttpService"); 
local ReplicatedStorage = game:GetService("ReplicatedStorage");

HttpService.HttpEnabled = true

local ChalkModule = Instance.new("ModuleScript");
ChalkModule.Name = "Chalk";
ChalkModule.Parent = ReplicatedStorage;

local Request = HttpService:RequestAsync({
    Url = "https://raw.githubusercontent.com/Perthys/chalk/main/source/main.lua";
    Method = "GET";
});

if Request.Success and Request.StatusCode == 200 then
    ChalkModule.Source = Request.Body

    print("Successfully installed Chalk module. At:", ChalkModule);
else
    error("Failed to install Chalk module.");
end
