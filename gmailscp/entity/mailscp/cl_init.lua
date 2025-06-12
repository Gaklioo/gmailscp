include("shared.lua")

mailEnt.Player = LocalPlayer()

function mailEnt:Draw()
    self:DrawModel()

    local ply = LocalPlayer()
    if not IsValid(ply) then
        return
    end

    local dist = self:GetPos():Distance2DSqr(ply:GetPos())
    local max = 10000

    if dist > max then 
        return 
    end

    local ang = self:GetAngles()
    local pos = self:GetPos() + 
    ang:Forward() * -7

    local time = self:GetNW2Int("Cooldown") + gMail.Cooldown
    local nextUse = math.Round(time - CurTime(), 0)

    ang:RotateAroundAxis(ang:Forward(), 180)
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), 90)

    cam.Start3D2D(pos, ang, 0.3)
        draw.SimpleText("Next Mail In " .. nextUse, "Default", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()

end