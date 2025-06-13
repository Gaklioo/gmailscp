--The scp that will actually generate the mail that the player is given
mailSCP = mailSCP or {}
mailSCP.Type = "anim"
mailSCP.Base = "base_gmodentity"
mailSCP.PrintName = "Mail SCP"
mailSCP.Category = "SCPS"
mailSCP.Spawnable = true -- Remove when done testing

function mailSCP:SetupDataTables()
    self:SetNW2Entity("IntendedPlayer", nil) -- Player that is to recieve the mail
    self:SetNW2Entity("DeliveringPlayer", nil) -- Player that is deliviring the mail
    self:SetNW2Int("Cooldown", 0)
end

scripted_ents.Register(mailSCP, "mail_scp")