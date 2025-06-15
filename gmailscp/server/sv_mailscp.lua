include("gmailscp/sh_mailscp.lua")

local _P = FindMetaTable("Player")

--Possibly implement better version of this, since its a universal target as of now but only one use per active mail so okayish for now maybe
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

    hook.Add("PlayerDisconnected", "gMailSCP_CheckPlayerDisconnect" .. ply:SteamID(), function(disconnectedPlayer)
        if disconnectedPlayer == ply then
            hook.Run("gMailSCP_ResetIntendedPlayer")
            hook.Run("gMailSCP_RemoveSwepDisconnect")
            hook.Remove("PlayerDisconnected", "gMailSCP_CheckPlayerDisconnect" .. ply:SteamID())            
        end
    end)
end)

hook.Add("gMailSCP_RemoveSwepDisconnect", "gMailSCP_RemoveSwepDisconnectServer", function()
    for _, ply in player.Iterator() do
        if ply:GetActiveWeapon():GetClass() == "mail_swep" then
            ply:ChatPrint("The intended target has died. No need for the mail anymore.")
            ply:StripWeapon("mail_swep")
        end
    end
end)

hook.Add("gMailSCP_GetIntendedPlayer", "gMailSCP_GetIntendedPlayerServer", function()
    return gMail.GetIntendedPlayer()
end)

hook.Add("gMailSCP_ResetIntendedPlayer", "gMailSCP_ResetIntendedPlayerServer", function()
    gMail.IntendedPlayer = nil
end)

hook.Add("gMailSCP_GetMessageForPlayer", "gMailSCP_GetMessageForPlayerServer", function(ply)
    local intendedPlayer = gMail.GetIntendedPlayer()

    if not IsValid(intendedPlayer) then 
        return 
    end

    if not intendedPlayer:IsPlayer() then 
        return 
    end

    local playersTeam = intendedPlayer:GetPlayerTeam()
    local afflictionList = gMail.Afflictions[playersTeam]
    if not afflictionList then 
        ply:SetPlayerTeam("General")

        playersTeam = intendedPlayer:GetPlayerTeam()
        afflictionList = gMail.Afflictions[playersTeam]
    end

    local afflictionKeys = table.GetKeys(afflictionList)
    if #afflictionKeys == 0 then 
        return "Mail not intended for this group." 
    end

    local chosenMessage = afflictionKeys[math.random(1, #afflictionKeys)]
    local afflictionFunction = afflictionList[chosenMessage]

    if ply != intendedPlayer then
        return chosenMessage
    end

    ply:GiveAffliction(afflictionFunction)

    return chosenMessage
end)

function _P:GiveAffliction(func)
    if self:IsAfflicted() then
        return 
    end

    if func and isfunction(func) then
        func(self)
        print("[gMailSCP] Affliction given to " .. self:Name())
        self:SetAfflicted(true)
    else
        self:ChatPrint("You feel a strange feeling in your stomach..")
    end
end

function _P:RemoveAffliction()
    if not self:IsAfflicted() then
        return 
    end

    local bone = self:LookupBone("ValveBiped.Bip01_Head1")
    if bone then
        self:ManipulateBoneScale(bone, Vector(1, 1, 1))
    end

    local timerName = "gMailSCP_Affliction_" .. self:SteamID()

    if timer.Exists(timerName) then
       timer.Remove(timerName) 
    end

    self:ChatPrint("You feel normal once again.")
    self:SetAfflicted(false)
end

function _P:SetAfflicted(bool)
    self.IsPlayerAfflicted = bool
end

function _P:IsAfflicted()
    return self.IsPlayerAfflicted or false
end

function _P:InitAfflictions()
    print("[gMailSCP] Gave affliction status to ply", self:Name())
    self:SetAfflicted(false)
end

hook.Add("PlayerInitialSpawn", "gMailSCP_InitPlayer", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            ply:InitAfflictions() 
        end
    end)
end)

hook.Add("gMailSCP_RemovePlayerAffliction", "gMailSCP_RemovePlayerAfflicitonHook", function(ply)
    if not IsValid(ply) then 
        return 
    end

    if not ply:IsPlayer() then 
        return 
    end
    
    if not ply:IsAfflicted() then
        return 
    end

    ply:RemoveAffliction()
end)

hook.Add("PlayerDeath", "gMailSCP_PlayerAfflictionRemoval", function(vic)
    if not vic:IsAfflicted() then
        print("[gMailSCP] Player was not afflicted")
        return 
    end
    vic:RemoveAffliction()
end)