include("shared.lua")

function mailEnt:Initialize()
    self:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    --To avoid someone placing the mail in a obsceure location making the SCP useless, we wait 5 minutes once the mail is dropped before just resetting.
    local waitTime = 300

    timer.Create("gMailEnt_RemoverTimer" .. self:EntIndex(), waitTime, 1, function()
        self:Remove()
        hook.Run("gMailSCP_ResetIntendedPlayer")
    end)
end

function mailEnt:Use(act)
    if not IsValid(act) then return end
    if not act:IsPlayer() then return end
    self:Remove()
    act:Give("mail_swep")

    local timerName = "gMailEnt_RemoverTimer" .. self:EntIndex()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end
end