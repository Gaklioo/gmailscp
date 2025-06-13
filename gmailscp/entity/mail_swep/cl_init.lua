include("shared.lua")

surface.CreateFont("mailHudFont", {
    font = "Arial",
    size = 25
})

function gMailSwep:PrimaryAttack() 
    return 
end

function gMailSwep:SecondaryAttack()
    if IsFirstTimePredicted() then
        self:SetNextSecondaryFire(CurTime() + 0.5)
        net.Start("gMailSCP_DropMail")
        net.SendToServer() 
    end
end

function gMailSwep:DrawHUD()
    local target = self:GetNW2Entity("IntendedPlayer")

    if not target then return end
    if not target:IsPlayer() then return end
    local targetName = target:Name()
    local x, y = ScrW(), ScrH()

    draw.DrawText("Target " .. targetName, "mailHudFont", x / 2, y, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
end