include("shared.lua")

function mailSCP:Initialize()
    self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetNW2Int("Cooldown", 0)
end

function mailSCP:GetRandomPlayer()
    local playerCount = player.GetCount()

    local numberStoper = math.random(1, playerCount)
    local num = 1

    for _, ply in player.Iterator() do
        if num == numberStoper then
            if ply:IsAfflicted() then -- No double afflictions because it kind of breaks the affects
                return self:GetRandomPlayer()             
            end

            if IsValid(ply) then
                hook.Run("gMailSCP_SetIntendedPlayer", ply)
                return
            end
        end

        num = num + 1
    end
end

function mailSCP:Use(user)
    local time = CurTime()
    local lastUse = self:GetNW2Int("Cooldown")

    if lastUse + gMail.Cooldown > time then 
        return 
    end

    if not IsValid(user) or not user:IsPlayer() then 
        return 
    end

    local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")

    --Quick fix around the intended target being universal, just dont let anyone use it until the mail has been delievered / used
    if IsValid(intendedPlayer) then
        user:ChatPrint("The scp seems to be waiting for something")
        return 
    end

    self:SetNW2Int("Cooldown", time)

    local swep = user:Give("mail_swep")

    if IsValid(swep) then
        self:GetRandomPlayer()
        local intendedPlayer = hook.Run("gMailSCP_GetIntendedPlayer")
        print(intendedPlayer)
        if not IsValid(intendedPlayer) then return end
    end
end