--The actual entity that is created when the player does /dropmail, as the SCP will give them the swep
mailEnt = mailEnt or {}
mailEnt.Type = "anim"
mailEnt.Base = "base_gmodentity"
mailEnt.PrintName = "Dropped Mail"
mailEnt.Category = "SCPS"
mailEnt.Spawnable = true -- Remove when done testing

function mailEnt:SetupDataTables()
    self:SetNW2Entity("IntendedPlayer", nil)
end

scripted_ents.Register(mailEnt, "mail_ent")