AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function mailEnt:Initialize()
    self:SetModel("models/props_junk/cardboard_box003a.mdl") -- Find model
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetNW2Int("Cooldown", CurTime())
end

function mailEnt:GetRandomPlayer()
    local playerCount = player.GetCount()

    local numberStoper = math.random(1, playerCount)
    local num = 1

    for _, ply in player.Iterator() do
        num = num + 1

        if num == numberStoper then
            if IsValid(ply) then
                self:SetNW2Entity("IntendedPlayer", ply)
                self:CheckPlayer()
                break
            end
        end
    end
end

function mailEnt:Use(user)
    local time = CurTime()
    local lastUse = self:GetNW2Int("Cooldown")

    if lastUse + gMail.Cooldown > time then 
        return 
    end

    if not IsValid(user) or not user:IsPlayer() then 
        return 
    end

    self:SetNW2Int("Cooldown", time)
    print("HI:)")
    user:Give("mail_swep", true)


end

function mailEnt:CheckPlayer()
    local ply = self:GetNW2Entity("IntendedPlayer")

    local hookName = "gMailSCP_Ply" .. ply:SteamID()

    hook.Add("PlayerDeath", hookName, function(victim)
        if victim != ply then return end
        
        self:SetNW2Entity("IntendedPlayer", nil)
    end)

    if not IsValid(ply) then hook.Remove(hookName) end
end