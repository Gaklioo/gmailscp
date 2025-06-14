include("gmailscp/sh_mailscp.lua")

local _P = FindMetaTable("Player")

function _P:Init()
    self.plyTeam = "Ethics"
end

function _P:GetPlayerTeam()
    return self.plyTeam
end

function _P:SetPlayerTeam(team)
    if not gMail.CheckTeam(team) then print("Failure to set players team") end

    self.plyTeam = team
end

function gMail.CheckTeam(team)
    if not gMail.Afflictions[team] then return false end
    
    return true 
end

hook.Add("PlayerSpawn", "gMailSCP_TempPlayerTeamSet", function(ply)
    ply:SetPlayerTeam("General")
    local plyTeam = ply:GetPlayerTeam()
end)