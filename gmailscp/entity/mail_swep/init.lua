include("shared.lua")

function gMailSwep:PrimaryAttack()

end

function gMailSwep:SecondaryAttack()

end

util.AddNetworkString("gMailSCP_DropMail")
net.Receive("gMailSCP_DropMail", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mail_swep" then return end

    if not weapon:GetNW2Entity("IntendedPlayer") then return end

    local pos = ply:GetPos() + Vector(5, 15, 0)
    local ang = ply:GetAngles()

    local droppedMail = ents.Create("mail_ent")
    droppedMail:SetPos(pos)
    droppedMail:SetAngles(ang)
    droppedMail:SetModel("models/props_junk/cardboard_box003a.mdl")
    droppedMail:Spawn()
    droppedMail:SetNW2Entity("IntendedPlayer", weapon:GetNW2Entity("IntendedPlayer"))

    ply:StripWeapon("mail_swep")
end)