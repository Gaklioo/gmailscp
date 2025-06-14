include("shared.lua")

surface.CreateFont("mailHudFont", {
    font = "Arial",
    size = 25
})

gMail.Message = nil

net.Receive("gMailSCP_GetMessageClient", function()
    local msg = net.ReadString()

    gMail.Message = msg
end)

function gMailSwep:PrimaryAttack()
    if self.HasOpenedMenu then return end

    self.HasOpenedMenu = true

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() / 2, ScrH() / 2)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:MakePopup()

    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)

    frame.OnClose = function()
        self.HasOpenedMenu = false
    end

    self:SetNextPrimaryFire(CurTime() + 0.5)
end

function gMailSwep:Holster()
    self.HasOpenedMenu = false
    return true
end

function gMailSwep:OnRemove()
    self.HasOpenedMenu = false
end

gMail.CachedPlayer = nil

function gMailSwep:SecondaryAttack()
end

hook.Add("PlayerSwitchWeapon", "gMailSCP_PlayerSwitchWeaponClient", function(ply, old, new)
    if not ply == LocalPlayer() then return end
    if not IsValid(ply) then return end

    if not (new:GetClass() == "mail_swep") then return end

    net.Start("gMailSCP_GetIntendedPlayerClient")
    net.SendToServer()
end)

net.Receive("gMailSCP_ReturnedIntendedPlayer", function()
    local ply = nil
    ply = net.ReadEntity()

    gMail.CachedPlayer = ply
end)


function gMailSwep:DrawHUD()
    local target = gMail.CachedPlayer

    if not target then return end
    if not target:IsPlayer() then return end
    local targetName = target:Name()
    local x, y = ScrW(), ScrH()

    draw.DrawText("Target " .. targetName, "mailHudFont", x / 2, y - 100,  Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
end