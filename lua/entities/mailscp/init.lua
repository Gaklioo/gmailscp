AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddWorkshop("2773105744")

function ENT:Initialize()
    self:SetModel("models/epangelmatikes/post_2.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetNW2Int("cooldown", 0)
end

function ENT:GetRandomPlayer(tryCount)
    if tryCount == 3 then
        return
    end

    local playerCount = player.GetCount()

    local numberStoper = math.random(1, playerCount)
    local num = 1

    for _, ply in player.Iterator() do

        if num == numberStoper then
            if IsValid(ply) and not gMail.BlacklistedTeams[ply:Team()] then
                self:SetNW2Entity("intendedPlayer", ply)
                return
            else
                return self:GetRandomPlayer(tryCount + 1) --Recursion saftey measure
            end
        end

        num = num + 1
    end
end

function ENT:Use(user)
    if not IsValid(user) or not user:IsPlayer() then
        return 
    end

    local time = CurTime()
    local lastUse = self:GetNW2Int("Cooldown")

    if lastUse + gMail.Cooldown > time then 
        vderma:CreateErrorPopup(user, "SCP-7573 Whisper", "SCP-7573 is currently writing more mail.") 
        return 
    end

    self:SetNW2Int("cooldown", time)

    local swep = user:Give("mailswep")

    if IsValid(swep) then
        self:GetRandomPlayer(0)
        local intendedPlayer = self:GetNW2Entity("intendedPlayer")
        if not IsValid(intendedPlayer) then return end
        swep:SetNW2Entity("intendedPlayer", intendedPlayer)
    end

    vderma:CreateErrorPopup(user, "SCP-7573 Whisper", "10 Minutes to deliver this mail.")

    timer.Create(gMail.PlayerHurtTimerName .. user:SteamID(), gMail.PlayerHurtTime, 1, function()
        vderma:CreateErrorPopup(user, "SCP-7573 Whisper", "You have failed to deliver your mail.")
        user:TakeDamage(self.FailureDamage)

        if user:HasWeapon("mailswep") then
            user:StripWeapon("mailswep")
        end
    end)
end