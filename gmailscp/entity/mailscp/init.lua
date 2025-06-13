include("shared.lua")

function mailSCP:Initialize()
    self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

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
            if IsValid(ply) then
                self:SetNW2Entity("IntendedPlayer", ply)
                self:CheckPlayer()
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

    self:SetNW2Int("Cooldown", time)

    local swep = user:Give("mail_swep")

    if IsValid(swep) then
        self:GetRandomPlayer()
        local intendedPlayer = self:GetNW2Entity("IntendedPlayer")
        print(intendedPlayer)
        swep:SetNW2Entity("IntendedPlayer", intendedPlayer)
        print(swep:GetNW2Entity("IntendedPlayer"))
    end
end

function mailSCP:CheckPlayer()
    local ply = self:GetNW2Entity("IntendedPlayer")
    if not IsValid(ply) then return end

    local hookName = "gMailSCP_Ply" .. ply:SteamID()

    hook.Add("PlayerDeath", hookName, function(victim)
        if victim != ply then return end
        
        self:SetNW2Entity("IntendedPlayer", nil)

        --Call remove affliction hook here
        hook.Remove("PlayerDeath", hookName)
    end)

    if not IsValid(ply) then hook.Remove(hookName) end
end