gMail = gMail or {}

gMail.Cooldown = 1
gMail.PlayerDeathTime = 300
gMail.PlayerAfflictionTime = 360

function gMail.GetTimerName(p)
    if not IsValid(p) then return end
    if not p:IsPlayer() then return end

    return "gMailSCP_Affliction_" .. p:SteamID()
end

function gMail.ForceShoot(p)
    p:ConCommand("+attack")
    timer.Simple(0.1, function()
        if IsValid(p) then p:ConCommand("-attack") end
    end)
end

gMail.Afflictions = {
    ["Ethics"] = {
        ["I heard that all of ethics is the scum of the earth, with them we can never do any testing, Ive never seen any group less worth while than them."] = function(p)
            p:ChatPrint("You suddenly seem to hate ethics...")  
            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 15, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end
                        
                    p:Say("Ethics means nothing to the foundation")
                end)
            end
        end,
        ["Ethics are a bunch of losers all they do is complain complain complain oh my god the complain they do is stupid and all the tests they reject is so stupid just complain complain complain i hate them all i hope they approve every unethical test"] = function(p)
            --RP Type affliction, the ethics member must approve the next test regardless of what it is. relys on player being fun
            p:ChatPrint("You feel swayed to accept the next test that comes to you regardless of its legitimacy")
        end,
        ["I heard that ethics guards are just a bunch of puppets that never have any spine of their own bceause they are so stupid and blind that they cant see that their ow nfuckign leaders are the idiots of the foundation"] = function(p)
            p:ChatPrint("Your guards seem to be worthy of death")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(p) then
                timer.Create(timerName, 3, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    local tr = p:GetEyeTrace().Entity
                    if not IsValid(tr) then return end
                    if not tr:IsPlayer() then return end

                    if tr:GetPlayerTeam() != "Omega-1" then return end

                    p:SetEyeAngles((tr:GetPos() - p:GetPos()):Angle())
                    gMail.ForceShoot(p)
                end)
            end
        end
    },
    ["Overseer"] = {

    },
    ["Janitor"] = {

    }, 
    ["Gensec"] = {
        ["Every single time I see these news articles these cops have no trigger discipline its always shoot shoot shoot shoot fuckign shoot STOP FUCKING SHOOHTING violence is the only awnser in these minds of idiots i hate them i hate them i hate them"] = function(p)
            p:ChatPrint("Your finger becomes unnaturally jittery")
            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 5, 0, function()
                    if not IsValid(p) then 
                        timer.Remove(timerName)
                    end
                    gMail.ForceShoot(p)
                end)
            end
        end,
        ["i heard that dclass are real and that the gaurds always shoot them and i hear they deserve it these fucking no good criminals deserve to get tested on these god damn fucking prisoners are the scum of the earth and deserve death"] = function(p)
            p:ChatPrint("You suddenly seem to feel a rage against dclass")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 1, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    local tr = p:GetEyeTrace().Entity 

                    if not IsValid(tr) then return end
                    if not tr:IsPlayer() then return end

                    if tr:GetPlayerTeam() == "D-Class" then
                        gMail.ForceShoot(p)
                    end
                end)
            end
        end
    },
    ["Research"] = {

    },
    ["CL4"] = {

    },
    ["CL5"] = {

    },
    --General afflictions that are not bound to one specific group
    ["General"] = {
        ["All those who read others letters are meant to die"] = function(p)
            p:ChatPrint("Goodbye World")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                print("Timer Created")
                timer.Create(timerName, 1, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    p:Say("I fucking hate the foundation")
                end)
            end
        end,
        ["I heard even just fucking reading about suger makes you hyperactive theres no way that this can be true though because sugar is like for your blood i think and like without the injestion like theres no way right theres not way"] = function(p)
            p:ChatPrint("Your body suddenly gets tingly")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 10, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end
                    print("Started")
                    
                    gMail.ForceShoot(p)
                end)
            end
        end
    }
}