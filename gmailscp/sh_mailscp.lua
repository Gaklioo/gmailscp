gMail = gMail or {}

gMail.Cooldown = 1
gMail.PlayerDeathTime = 600
gMail.PlayerAfflictionTime = 360
gMail.PlayerKillTimerName = "gMailSCP_Affliction_KillPlayer"


if SERVER then
    util.AddNetworkString("gMailSCP_ChangePlayerColor")
    util.AddNetworkString("gMailSCP_RemovePlayerColor")    
    util.AddNetworkString("gMailSCP_StartToyTown")
    util.AddNetworkString("gMailSCP_RemovePlayerToyTown")
end


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

            if not timer.Exists(timerName) then
                timer.Create(timerName, 3, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    local tr = p:GetEyeTrace().Entity
                    if not IsValid(tr) then return end
                    if not tr:IsPlayer() then return end

                    if tr:GetPlayerTeam() != "Omega-1" then return end

                    p:SetEyeAngles((p:GetPos() - tr:GetPos()):Angle())
                    gMail.ForceShoot(p)
                end)
            end
        end,
        ["Ethics and overseers truly must hate each other i mean i swear for the foundation to be so powerful and so big because they work so good together there must be like some sort of hatred between them i swear"] = function(p)
            --Another RP affliction
            p:ChatPrint("You feel the sudden urge to hate all overseers, and make it known you hate them")
        end,
        ["Ethics really are the big heads of the foundation i mean like holy hell their heads are so fucking big that youd think they could fly away there is nothing more disgusting then how big those ethic heads are"] = function(p)
            p:ChatPrint("You feel like you have the ego of a greek god in the flesh")

            local bone = p:LookupBone("ValveBiped.Bip01_Head1")
            if bone then
                p:ManipulateBoneScale(bone, Vector(2, 2, 2))
            end
        end,
        ["ethics really deserve to be at the bottom of the barrel they have absolutely no reason to give us such a pain in the ass about our god damn self they are so fucking annoying they deserve to be bombed over and over and just eliminated from the site"] = function(p)
            timer.Simple(5, function()
                local pos = p:GetPos()
                local radius = 50
                local damage = 500
                util.BlastDamage(game.GetWorld(), p, pos, radius, damage)
                local effect = EffectData()
                effect:SetOrigin(pos)
                util.Effect("Explosion", effect)
            end)
        end
    },
    ["Overseer"] = {
        ["the death of the overseer committee is soon i swear the countdown is fucking ticking all these god damnd over seers will see the end of their own life and they will never be revived or taken care of ever again they are the worst"] = function(p)
            p:ChatPrint("The clock is ticking... You have 5 minutes to live.")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 300, 1, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end
                    p:Kill()
                end)
            end
        end,
        ["Alpha-1 are full of fucking traitors, you think that really the ci are insurgents? no fucking shot these people have convinced us of these stupid lies these idiots are the creators of the ci these traitor bastards"] = function(p)
            p:ChatPrint("Your personel guards are truly the evil of the foundation")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 15, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    local tr = p:GetEyeTrace().Entity
                    if not IsValid(tr) then return end
                    if not tr:IsPlayer() then return end

                    if tr:GetPlayerTeam() != "Alpha-1" then return end

                    p:SetEyeAngles((tr:GetPos() - p:GetPos()):Angle())
                    gMail.ForceShoot(p)
                end)
            end
        end,
        ["overseers really have the biggest god damn heads in the world if you looked at them from space all youd see is their cranium their heads are so god damn big that i think theres not much space for anything but fluid in there because they sure act stupid"] = function(p)
            local bone = p:LookupBone("ValveBiped.Bip01_Head1")

            if bone then
                p:ManipulateBoneScale(bone, Vector(2, 2, 2))
            end
        end,
        ["overseers really do nothing for the foundation at all theyre just a bunch of useless paper pushers who deserve to be bombed into the ground because they do nothing at all except waste valuable air and should be killed and murdered and never seen again"] = function(p)
            timer.Simple(5, function()
                local pos = p:GetPos()
                local radius = 50
                local damage = 500
                util.BlastDamage(game.GetWorld(), p, pos, radius, damage)
                local effect = EffectData()
                effect:SetOrigin(pos)
                util.Effect("Explosion", effect)
            end)
        end
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
        end,
        ["at the end of the day gensec never do anything they are a bunch of useless creatures that do nothing but glote upon their own stupidity and cant even quell riots correctly beacuse they are the most useless indiviuals that we have ever seen"] = function(p)
            p:ChatPrint("You feel so useless")

            --Similar to stoneman
            p:SetWalkSpeed(0)
            p:SetRunSpeed(0) 
        end,
        ["i swear research never does anything with their time at all they only complain and moan about how theres never enough gensec its the most annoying thing honestly the entire foundation needs to get rid of researchers and replace them with gensec"] = function(p)
            p:ChatPrint("You feel a sudden hatred for research")

               if not timer.Exists(timerName) then
                timer.Create(timerName, 1, 0, function()
                    if not IsValid(p) then
                        timer.Remove(timerName)
                    end

                    local tr = p:GetEyeTrace().Entity 

                    if not IsValid(tr) then return end
                    if not tr:IsPlayer() then return end

                    if tr:GetPlayerTeam() == "Research" then
                        gMail.ForceShoot(p)
                    end
                end)
            end
        end,
        ["gensec never really get the opportunity to be around the site i swear these idiots dont even know what we do we are general security we are not the rats of the foundation we dont only protect dblock we protect the entire god damned site"] = function(p)
            --RP Affliction
            p:ChatPrint("You feel the urge to go protect whichever location you prefer")
        end
    },
    --most of the afflictions are going to be rp based at the end of the day.
    ["Research"] = {
        ["i love how these researchers think theyre actually doing anything for the foundation its so funny how useless and incompetent they all are they are truly the idiots of the world and like deserve to be shot and fired from their stupid jobs"] = function(p)
            p:ChatPrint("It appears as if you are unable to do your job, go be free into the wild")
        end,
        ["researchers are so limited by how no one trusts their judgement or ability to do correct testing its so dumb how everything is locked behind some sort of knowledge wall if they knew everything than research would progress so much faster"] = function(p)
            p:ChatPrint("You have gained all knowledge to every SCP, go research and attempt to test on anything.")
        end,
        ["without the ethics committee every singular scp test would be so much more beneficial and faster without their stupid intereference the world would be so much better there is no way that anyone should ever respect their authority"] = function(p)
            p:ChatPrint("You no longer feel the need for ethical testing, test without any bound of ethics.")
        end,
        ["scp 096 really isnt that real i mean like its so stupid you cant look at the thing? what a stupid little lie that people tell themselves like its such a useless waste of time to think anything like that is even real lol"] = function(p)
            p:Give("scp_096") -- danger danger
        end
    },
    --General afflictions that are not bound to one specific group
    ["General"] = {
        ["All those who read others letters are meant to die"] = function(p)
            p:ChatPrint("Goodbye World")

            local timerName = gMail.GetTimerName(p)

            if not timer.Exists(timerName) then
                timer.Create(timerName, 5, 0, function()
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
                    
                    gMail.ForceShoot(p)
                end)
            end
        end,
        ["Cocaine truly is like the best type of drug that someone can use because like it makes you feel so fucking good and like the cia is definintly involved in the crack trade of 1990s that forced impovrished communities to use crack"] = function(p)
            p:ChatPrint("You notice your nose start to hurt a bit")

            local curWalkSpeed = p:GetWalkSpeed()
            local curRunSpeed = p:GetRunSpeed()
            p:SetWalkSpeed(curWalkSpeed * 1.5)
            p:SetRunSpeed(curRunSpeed * 2.2)
        end,
        ["at the end of the day all the foundation does is fucking nothing at all except make everything look pretty and pink its so stupid and so dumb the foundation deserves to be destroyed by all means possible"] = function(p)
            p:ChatPrint("The pink... the cuteness...")

            net.Start("gMailSCP_ChangePlayerColor")
            net.Send(p)

            hook.Add("PlayerDeath", "gMailSCP_RemoveColorServer" .. p:SteamID(), function(player)
                if player == p then
                    net.Start("gMailSCP_RemovePlayerColor")
                    net.Send(player)

                    hook.Remove("PlayerDeath", "gMailSCP_RemoveColorServer" .. p:SteamID())
                end
            end)
        end,
        ["all these toys all over the world arent delivered by santa theyre imagined by something and just thrown into the world is so fucking crazy i hate it so much how people just believe that these santas can create so much toys its the god damn anomaly doing it"] = function(p)
            p:ChatPrint("The toys are coming")

            net.Start("gMailSCP_StartToyTown")
            net.Send(p)

            hook.Add("PlayerDeath", "gMailSCP_RemoveToyTown" .. p:SteamID(), function(player)
                if player == p then
                    net.Start("gMailSCP_RemovePlayerToyTown")
                    net.Send(player)

                    hook.Remove("PlayerDeath", "gMailSCP_RemoveToyTown" .. p:SteamID())
                end
            end)
        end,
        ["i swear nobody understands what the hell im even talking about anymore each time i attempt to talk to others they just look through me like im a puppet without a singular thought its so dumb and stupid i swear these people who dont understand me need to die"] = function(p)
            p:ChatPrint("Nobody understands me...")

            hook.Add("PlayerSay", "gMailSCP_ChangeText" .. p:SteamID(), function(ply, text)
                if ply == p then
                    local newMessage = util.Base64Encode(text)

                    return newMessage
                end
            end)

            hook.Add("PlayerDeath", "gMailSCP_RemoveEncodedText" .. p:SteamID(), function(vic)
                if vic == p then
                    hook.Remove("PlayerSay", "gMailSCP_ChangeText" .. p:SteamID())
                    hook.Remove("PlayerDeath", "gMailSCP_RemoveEncodedtext" .. p:SteamID())
                end
            end)
        end
    }
}