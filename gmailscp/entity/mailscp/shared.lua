--The scp that will actually generate the mail that the player is given
mailEnt = mailEnt or {}
mailEnt.Type = "anim"
mailEnt.Base = "base_gmodentity"
mailEnt.PrintName = "Mail SCP"
mailEnt.Category = "SCPS"
mailEnt.Spawnable = true -- Remove when done testing

function mailEnt:SetupDataTables()
    self:SetNW2Entity("IntendedPlayer", nil) -- Player that is to recieve the mail
    self:SetNW2Entity("DeliveringPlayer", nil) -- Player that is deliviring the mail
    self:SetNW2Int("Cooldown", 0)
end

scripted_ents.Register(mailEnt, "mailscp")