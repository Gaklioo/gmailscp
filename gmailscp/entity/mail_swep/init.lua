include("shared.lua")

function gMailSwep:PrimaryAttack()

end

function gMailSwep:SecondaryAttack()

end

util.AddNetworkString("gMailSCP_GetIntendedPlayerClient")
util.AddNetworkString("gMailSCP_ReturnedIntendedPlayer")
net.Receive("gMailSCP_GetIntendedPlayerClient", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then return end

    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    net.Start("gMailSCP_ReturnedIntendedPlayer")
    net.WriteEntity(intendedPlayer)
    net.Send(ply)
end)

util.AddNetworkString("gMailSCP_DropMail")
net.Receive("gMailSCP_DropMail", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then return end
    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    if not intendedPlayer then return end

    local pos = ply:GetPos() + Vector(35, 15, 10)
    local ang = ply:GetAngles()

    local droppedMail = ents.Create("mail_ent")
    droppedMail:SetPos(pos)
    droppedMail:SetAngles(ang)
    droppedMail:SetModel("models/props_junk/cardboard_box003a.mdl")
    droppedMail:Spawn()

    ply:StripWeapon("mail_swep")
end)

util.AddNetworkString("gMailSCP_GetMessageClient")
util.AddNetworkString("gMailSCP_GetMessageServer")
net.Receive("gMailSCP_GetMessageServer", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then return end
    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")
    local message = hook.Run("gMailSCP_GetMessageForPlayer")

    net.Start("gMailSCP_GetMessageClient")
    net.WriteString(message)
    net.Send(ply)

    if ply != intendedPlayer then
        ply:ChatPrint("Dont you know its illegal to read mail thats not yours? How dispicible.")

        timer.Simple(5, function()
            ply:Kill()
        end)
    end

end)