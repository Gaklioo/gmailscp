--The actual entity that is created when the player does /dropmail, as the SCP will give them the swep
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SCP-7573-2"
ENT.Category = "SCPS"
ENT.Spawnable = true -- Remove when done testing

function ENT:SetupDataTables()
    self:SetNW2Entity("intendedPlayer", nil)
end