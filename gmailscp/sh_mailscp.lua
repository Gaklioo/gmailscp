gMail = gMail or {}

gMail.Cooldown = 180
gMail.PlayerDeathTime = 300
gMail.PlayerAfflictionTime = 360

gMail.Afflictions = {
    ["Ethics"] = {
        ["I heard that all of ethics is the scum of the earth, with them we can never do any testing, Ive never seen any group less worth while than them."] = function(p)
            p:ChatPrint("You suddenly seem to hate ethics...")  
            p:GiveAffliction(function(ply)
                timer.Create("gMailSCP_EthicsSay_" .. ply:SteamID(), 15, 0, function()
                    ply:Say("Ethics means nothing to the foundation")
                end)
            end)
        end
    },
    ["Overseer"] = {

    },
    ["Janitor"] = {

    }, 
    ["Gensec"] = {

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
            
        end
    }
}