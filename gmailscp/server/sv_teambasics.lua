include("gmailscp/sh_mailscp.lua")

local _P = FindMetaTable("Player")

function _P:Init()
    self.plyTeam = "Ethics"
end

function _P:GetPlayerTeam()
    return self.plyTeam
end

function _P:SetPlayerTeam(team)
    if not gMail.CheckTeam(team) then 
        self.plyTeam = "General"
    end

    self.plyTeam = team
end

hook.Add("PlayerSpawn", "gMailSCP_TempPlayerTeamSet", function(ply)
    ply:SetPlayerTeam("General")
    local plyTeam = ply:GetPlayerTeam()
end)

concommand.Add("omega", function(ply)
    print("Changed!")
    ply:SetPlayerTeam("Omega-1")
end)

concommand.Add("alpha", function(ply)
    print("Changed!")
    ply:SetPlayerTeam("Alpha-1")
end)

concommand.Add("gensec", function(ply)
    ply:SetPlayerTeam("GenSec")
end)

concommand.Add("over", function(ply)
    ply:SetPlayerTeam("Overseer")
end)

concommand.Add("ethics", function(ply)
    ply:SetPlayerTeam("Ethics")
end)