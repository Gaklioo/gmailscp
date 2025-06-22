--The scp that will actually generate the mail that the player is given
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SCP-7573"
ENT.Category = "SCPS"
ENT.Spawnable = true -- Remove when done testing
ENT.FailureDamage = math.random(15, 40)

function ENT:SetupDataTables()
    self:SetNW2Int("Cooldown", 0)
end