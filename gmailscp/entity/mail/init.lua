include("shared.lua")

function mailEnt:Initialize()
    self:SetModel("models/props_junk/cardboard_box003a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function mailEnt:Use(act)
    if not IsValid(act) then return end
    if not act:IsPlayer() then return end
    self:Remove()
    act:Give("mail_swep")
    
end