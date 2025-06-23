include("shared.lua")
gMail.Message = ""

surface.CreateFont("mailHudFont", {
    font = "Arial",
    size = 25
})

net.Receive("gMailSCP_GetMessageClient", function()
    local msg = net.ReadString()

    gMail.Message = msg
end)

function SWEP:Initialize()
    self.WModel = ClientsideModel(self.WorldModel)
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()

    if IsValid(owner) and owner:IsPlayer() then
        if not IsValid(self.WModel) then
            self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
        end

        local boneId = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if not boneId then return end

        local boneMatrix = owner:GetBoneMatrix(boneId)
        if not boneMatrix then return end

        local offsetVec = Vector(4, 0, 0)
        local offsetAng = Angle(270, 0, 0)

        local newPos, newAng = LocalToWorld(offsetVec, offsetAng, boneMatrix:GetTranslation(), boneMatrix:GetAngles())

        self.WModel:SetPos(pos)
        self.WModel:SetAngles(ang)
        self.WModel:SetupBones()
        self.WModel:DrawModel()

    else
        if IsValid(self.WModel) then
            self.WModel:Remove()
            self.WModel = nil
        end

        self:DrawModel()
    end
end

function SWEP:PrimaryAttack()
    if self.HasOpenedMenu then return end

    self.HasOpenedMenu = true
    local maxWidth = ScrW() * 0.5

    timer.Simple(0.2, function()
        local frame = vderma:Frame()
        frame:SetSize(maxWidth, 100)
        frame:Center()
        frame:SetTitle("SCP-7573 Message")

        local container = vgui.Create("DPanel", frame)
        container.Paint = nil

        local w, h = container:GetParent():GetSize()
        container:SetWide(w)
        container:SetTall(h - 30)
        container:SetPos(0, h - 70)
        container:DockPadding(5, 5, 5 ,5)
        container:DockMargin(5, 5, 5, 5)

        local message = vgui.Create("DLabel", container)
        message:SetText(gMail.Message)
        message:SetWrap(true)
        message:SetAutoStretchVertical(true)
        message:Dock(FILL)

        timer.Simple(0.1, function()
            container:InvalidateLayout(true)
            frame:InvalidateLayout(true)

            local newHeight = message:GetTall() + 60
            container:SetTall(newHeight)    
            frame:SetTall(newHeight + 20)
            frame:Center()
        end)

        frame.OnClose = function()
            self.HasOpenedMenu = false
        end
    end)


    self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:Holster()
    self.HasOpenedMenu = false
    return true
end

function SWEP:OnRemove()
    if IsValid(self.WModel) then
        self.WModel:Remove()
        self.WModel = nil
    end
    self.HasOpenedMenu = false
end

function SWEP:DrawHUD()
    local target = self:GetNW2Entity("IntendedPlayer")

    if not IsValid(target) then return end
    if not target:IsPlayer() then return end
    local targetName = target:Name()
    local x, y = ScrW(), ScrH()

    draw.DrawText("Target " .. targetName, "mailHudFont", x / 2, y - 100,  Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
end

function SWEP:SecondaryAttack()
    if IsValid(self.WModel) then
        self.WModel:Remove()
        self.WModel = nil
    end
    self:DrawModel()
end