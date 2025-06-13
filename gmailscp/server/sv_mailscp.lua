include("sh_mailscp.lua")

local _P = FindMetaTable("Player")

function _P:GiveAffliction(func)
    if self.IsAfflicted then return end
    self.IsAfflicted = true

    local timerName = "gMailSCP_" .. self:SteamID()

    timer.Create(timerName, 7, 0, function()
        if not IsValid(self) then
            timer.Remove(timerName)
            return 
        end

        if func and isfunction(func) then
            func(self)
            print("[gMailSCP] Affliction given to " .. ply:Name())
        else
            self:ChatPrint("You feel a strange feeling in your stomach..")
        end
    end)
end

function _P:AddAfflictionTimer(timerName)

function _P:RemoveAffliction()
    local timerName = "gMailSCP_" .. self:SteamID()

    if timer.Exists(timerName) then
       timer.Remove(timerName) 
    end

    self.IsAfflicted = false
end