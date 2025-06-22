AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


net.Receive("gMailSCP_GetMessageClient", function()
    local msg = net.ReadString()

    gMail.Message = msg
end)

gMail.GetAffliction(ply, shouldGive) 

util.AddNetworkString("gMailSCP_GetMessageClient")
function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local shouldGive = (ply == self:GetNW2Entity("IntendedPlayer"))

    local message = gMail.GetAffliction(ply, shouldGive) 

    if timer.Exists(gMail.PlayerHurtTimerName) then
        timer.Remove(gMail.PlayerHurtTimerName)
    end

    net.Start("gMailSCP_GetMessageClient")
    net.WriteString(message)
    net.Send(ply)

    self:SendMessageClient()

    ply:StripWeapon("mailswep")
end

function SWEP:SendMessageClient()
    local ply = self:GetOwner()

    if not IsValid(ply) then 
        return 
    end

    if not ply:IsPlayer() then 
        return 
    end

    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mailswep" then 
        return 
    end

    local intendedPlayer = self:GetNW2Entity("IntendedPlayer") 

    if ply != intendedPlayer then
        ply:ChatPrint("Dont you know its illegal to read mail thats not yours? How dispicible.")

        timer.Simple(5, function()
            ply:TakeDamage(math.random(10, 30))
        end)
    end

    self:SetNW2Entity("IntendedPlayer", nil)

end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()

    if not IsValid(ply) then 
        return 
    end

    if not ply:IsPlayer() then 
        return 
    end

    local weapon = ply:GetActiveWeapon()

    if not IsValid(weapon) or weapon:GetClass() != "mailswep" then 
        return 
    end

    local intendedPlayer = self:GetNW2Entity("IntendedPlayer")

    if not intendedPlayer then
        return 
    end

    local pos = ply:GetPos() + ply:GetForward() * 50 + Vector(0, 0, 50)

    local droppedMail = ents.Create("mail")
    droppedMail:SetPos(pos)
    droppedMail:SetAngles(Angle(0, ply:EyeAngles().y, 0))
    droppedMail:Spawn()
    droppedMail:DropToFloor()
    droppedMail:SetNW2Entity("IntendedPlayer", self:GetNW2Entity("IntendedPlayer"))

    ply:StripWeapon("mailswep")
end