include("gmailscp/sh_mailscp.lua")

local _P = FindMetaTable("Player")

gMail.IntendedPlayer = nil 

function gMail.SetIntendedPlayer(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    gMail.IntendedPlayer = ply
end

function gMail.GetIntendedPlayer()
    return gMail.IntendedPlayer
end

hook.Add("gMailSCP_SetIntendedPlayer", "gMailSCP_SetIntendedPlayerServer", function(ply)
    print(ply)
    gMail.SetIntendedPlayer(ply)
end)

hook.Add("gMailSCP_GetIntendedPlayer", "gMailSCP_GetIntendedPlayerServer", function()
    return gMail.GetIntendedPlayer()
end)

hook.Add("gMailSCP_ResetIntendedPlayer", "gMailSCP_ResetIntendedPlayerServer", function()
    gMail.IntendedPlayer = nil
end)

hook.Add("gMailSCP_GetMessageForPlayer", "gMailSCP_GetMessageForPlayerServer", function()
    local intendedPlayer = gMail.GetIntendedPlayer()

    if not IsValid(intendedPlayer) then return end
    if not intendedPlayer:IsPlayer() then return end

    local playersTeam = intendedPlayer:GetPlayerTeam()
    local afflictionList = gMail.Afflictions[playersTeam]
    if not afflictionList then return "Unknown Mail" end

    local afflictionKeys = table.GetKeys(afflictionList)
    if #afflictionKeys == 0 then return "Mail not intended for this group." end

    local chosenMessage = afflictionKeys[math.random(1, #afflictionKeys)]

    print(chosenMessage)

    return chosenMessage
end)

function _P:GiveAffliction(func)
    if self.IsAfflicted then return end
    self.IsAfflicted = true

    local timerName = "gMailSCP_" .. self:SteamID()

    timer.Create(timerName, 7, 0, function()
        if not IsValid(self) then
            timer.Remove(timerName)
            return 
        end

        if func and isfunction(func) then
            func(self)
            print("[gMailSCP] Affliction given to " .. self:Name())
        else
            self:ChatPrint("You feel a strange feeling in your stomach..")
        end
    end)
end

function _P:AddAfflictionTimer(timerName)
end

function _P:RemoveAffliction()
    local timerName = "gMailSCP_" .. self:SteamID()

    if timer.Exists(timerName) then
       timer.Remove(timerName) 
    end

    self.IsAfflicted = false
end