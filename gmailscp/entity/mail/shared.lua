--The actual entity that is created when the player does /dropmail, as the SCP will give them the swep
mailEnt = mailEnt or {}
mailEnt.Type = "anim"
mailEnt.Base = "base_gmodentity"
mailEnt.PrintName = "Dropped Mail"
mailEnt.Category = "SCPS"
mailEnt.Spawnable = true -- Remove when done testing


scripted_ents.Register(mailEnt, "mail_ent")