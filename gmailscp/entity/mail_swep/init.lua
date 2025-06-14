include("shared.lua")

util.AddNetworkString("gMailSCP_GetMessageClient")
function gMailSwep:PrimaryAttack()
    local ply = self:GetOwner()
    local message = hook.Run("gMailSCP_GetMessageForPlayer", ply)

    net.Start("gMailSCP_GetMessageClient")
    net.WriteString(message)
    net.Send(ply)

    self:SendMessageClient()

    ply:StripWeapon("mail_swep")
end

function gMailSwep:SendMessageClient()
    local ply = self:GetOwner()

    if not IsValid(ply) then 
        return 
    end

    if not ply:IsPlayer() then 
        return 
    end

    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then 
        return 
    end
    
    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    if ply != intendedPlayer then
        ply:ChatPrint("Dont you know its illegal to read mail thats not yours? How dispicible.")

        timer.Simple(5, function()
            ply:Kill()
        end)
    end

    hook.Run("gMailSCP_ResetIntendedPlayer")
end

function gMailSwep:SecondaryAttack()
    local ply = self:GetOwner()

    if not IsValid(ply) then 
        return 
    end
    if not ply:IsPlayer() then 
        return 
    end

    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then 
        return 
    end

    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    if not intendedPlayer then
        return 
    end

    local pos = ply:GetPos() + Vector(35, 15, 10)
    local ang = ply:GetAngles()

    local droppedMail = ents.Create("mail_ent")
    droppedMail:SetPos(pos)
    droppedMail:SetAngles(ang)
    droppedMail:SetModel("models/props_junk/cardboard_box003a.mdl")
    droppedMail:Spawn()

    ply:StripWeapon("mail_swep")
end

util.AddNetworkString("gMailSCP_GetIntendedPlayerClient")
util.AddNetworkString("gMailSCP_ReturnedIntendedPlayer")
net.Receive("gMailSCP_GetIntendedPlayerClient", function(len, ply)
    if not IsValid(ply) then 
        return 
    end

    if not ply:IsPlayer() then 
        return 
    end

    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then 
        return 
    end

    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    net.Start("gMailSCP_ReturnedIntendedPlayer")
    net.WriteEntity(intendedPlayer)
    net.Send(ply)
end)