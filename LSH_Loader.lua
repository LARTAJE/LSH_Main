local PlayerService = game:GetService("Players")
local GameId = game.GameId
local Repository = "https://raw.githubusercontent.com/LARTAJE/LSH_Main/main/Game_".. GameId ..".lua"
loadstring(game:HttpGet(Repository))()
