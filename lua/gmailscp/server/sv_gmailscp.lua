include("gmailscp/sh_gmailscp.lua")

local _P = FindMetaTable("Player")

function gMail.RemovePlayerAffliciton(ply)
    ply:RemoveAffliction()
end

function _P:GiveAffliction(func)
    if self:IsAfflicted() then
        return
    end

    if func and isfunction(func) then
        func(self)
        print("[gMailSCP] Affliction Given To" .. self:Name())
        self:SetAfflicted(true)
    else
        vderma:CreateErrorPopup(self, "SCP-7573", "You feel something strange in your stomach...")
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

    if self:Alive() then
        vderma:CreateErrorPopup(self, "SCP-7573", "You feel your body going back to normal")
    end
    
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

hook.Add("PlayerDeath", "gMailSCP_PlayerAfflictionRemoval", function(vic)
    if not vic:IsAfflicted() then
        return 
    end
    vic:RemoveAffliction()
end)