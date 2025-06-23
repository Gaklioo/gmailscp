AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    --To avoid someone placing the mail in a obsceure location making the SCP useless, we wait 5 minutes once the mail is dropped before just resetting.
    timer.Create("gMailEnt_RemoverTimer" .. self:EntIndex(), gMail.MailDespawnTime, 1, function()
        self:Remove()
    end)
end

function ENT:Use(user)
    if not IsValid(user) then 
        return 
    end

    if not user:IsPlayer() then 
        return 
    end
    
    local swep = user:Give("mailswep")
    swep:SetNW2Entity("IntendedPlayer", self:GetNW2Entity("IntendedPlayer"))

    local timerName = "gMailEnt_RemoverTimer" .. self:EntIndex()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

    self:Remove()
end
