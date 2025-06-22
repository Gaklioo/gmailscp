include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local ply = LocalPlayer()
    if not IsValid(ply) then
        return
    end

    local dist = self:GetPos():Distance2DSqr(ply:GetPos())
    local max = 100000

    if dist > max then 
        return 
    end
end