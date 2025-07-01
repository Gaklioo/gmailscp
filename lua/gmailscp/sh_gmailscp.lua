gMail = gMail or {}

gMail.Cooldown = 300
gMail.PlayerHurtTime = 600
gMail.PlayerAfflictionTime = 360
gMail.MailDespawnTime = 300
gMail.PlayerHurtTimerName = "gMailSCP_Affliction_KillPlayer"
gMail.UseDarkRP = true

--TEAM_CITIZEN is nil when server first loads until darkrp is done, same with all team data, so this fixes it
hook.Add("DarkRPFinishedLoading", "gMailSCPSetupTeams", function()
    gMail.BlacklistedTeams = {
        [TEAM_CITIZEN] = true,
        [TEAM_HOBO] = true,
    }
end)

if SERVER then
    util.AddNetworkString("gMailSCP_ChangePlayerColor")
    util.AddNetworkString("gMailSCP_RemovePlayerColor")    
    util.AddNetworkString("gMailSCP_StartToyTown")
    util.AddNetworkString("gMailSCP_RemovePlayerToyTown")
end

function gMail.ForceShoot(p)
    p:ConCommand("+attack")
    timer.Simple(0.1, function()
        if IsValid(p) then 
            p:ConCommand("-attack") 
        end
    end)
end

function gMail.ForceJump(p)
    p:ConCommand("+jump")
    timer.Simple(0.1, function()
        if IsValid(p) then 
            p:ConCommand("-jump") 
        end
    end)
end

function gMail.GetTimerName(p)  
    if not IsValid(p) then 
        return 
    end

    if not p:IsPlayer() then 
        return 
    end

    return "gMailSCP_Affliction_" .. p:SteamID()
end

local markov = {}
markov.chain = {}

function markov:InputText(text)
    local words = {}

    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    return words
end

function markov:Train(text)
    local words = self:InputText(text)

    for i = 1, #words - 2 do
        local key = words[i] .. " " .. words[i + 1]
        local nextWord = words[i + 2]

        if not self.chain[key] then
            self.chain[key] = {}
        end
        table.insert(self.chain[key], nextWord)
    end
end

--n = numbers of words to make
function markov:Generate(n)
    local keys = {}
    for key in pairs(self.chain) do
        table.insert(keys, key)
    end

    local current = keys[math.random(#keys)]
    local output = { current }

    for i = 1, n do
        local nextWords = self.chain[current]
        if not nextWords or #nextWords == 0 then
            current = keys[math.random(1, #keys)]
            table.insert(output, current)
        else
            local nextWord = nextWords[math.random(1, #nextWords)]
            local wordOne, wordTwo = current:match("^(%S+)%s+(%S+)$")
            current = wordTwo .. " " .. nextWord
            table.insert(output, nextWord)
        end
    end

    return table.concat(output, " ")
end

function markov:GetChain()
    return self.chain
end

gMail.TrainingWords = {
    "I swear %s really doesn't know anything about trigger control. There is no reason at all that they should be able to hold a weapon. Every time I see them I swear they just shoot at random. I would never in a million years trust them with ammo. I seriously hate that people give them weapons still. They need to be fired now because they are so clueless. I would never let them in my squad ever.",
    " I've seen %s taking drugs before. They are the devil's advocate and take drugs whenever they can. I've seen them snorting something whenever they are alone. The fact that they still are within the Foundation is amazing to me. It shows the true incompetence of the Foundation to let someone like that work here. They are nothing but a waste of space and need to be fired ASAP because really they are the most ridiculous person I've ever seen.",
    "%s is the laziest Foundation person in the world. They are nothing but a useless sack of potatoes and do nothing for the Foundation but waste resources. They are foolish and careless, and without them we would be so much further ahead in our research and containment abilities. I've seen turtles outrun them because they are just that slow. There is nothing more in this world that I dislike than people who move slow, and there is nothing I wouldn't do for them to go away.",
    "There is nothing more that %s hates in this world than the color pink and it's so silly. Knowing that they hate this color so much is incredible because it's just a color. Every time I hear them talk they're always complaining about how everything is pink. It is such a pointless waste of time to talk to them because there is nothing they talk about other than how everything is pink. I would rather watch paint dry than talk to them ever again.",
    "There are just some people that have huge egos that will never be quelled like %s's. Every time I hear them talk it's like they have the biggest head in the universe and just can't get over themselves. There is nothing more in this world that I hate than people who just can't stop talking about themselves. It's like they are just so incompetent that everything needs to be about them. They just sit here and ruin the Foundation because they are unable to speak normally, and no one likes it at all.",
    "In this world there is absolutely nothing more that I hate than %s. They are lazy and incompetent and every time they get an eye exam they always fail. Every single time this person gets an eye exam they fail it and there is nothing more in this world that I hate than them trying to claim they passed. A person who never gets a proper eye exam and then complains how perfect their eyesight is when they can't see anything. A bunch of ridiculous nonsense coming from the most clueless person in the entire Foundation.",
    "The Foundation is so ineffective because of %s. They're so bald I think that I'd get blinded by their scalp if they ever walked under a light. They never will though because they're nothing but a goofy little gremlin that sits in their hidey hole all day like some complete fool or something. There is nothing more in this Foundation that I dislike than them. They are the most useless person I have ever seen and do nothing but waste space and air within the Foundation because they are the biggest bald-headed goof in the world.",
    "The ethics in this Foundation are the biggest waste of resources that I, %s, have ever seen. They just sit there and deny every test because they think that they are the rulers of the Foundation and nothing is above them. They think they are absolute but in reality they are the most ineffective people in the world. Without them research would be so far ahead, and life would be so much better without their constant interference within the Foundation and its normal operations. A bunch of totally useless people is what they are.",
    "The site inspectors %s council are a bunch of fools who have no clue what right and wrong truly are. They just meet in their room and talk about how cool and secretive they are. It's so silly how they think they are above everything, and everything they do is the absolute biggest waste of time in the world. They do nothing but act superior to the rest of the Foundation and waste our time. Without them the Foundation would be so far ahead in proper procedures because they are so ineffective it's unbelievable. They just sit there and do nothing for the Foundation.",
    "GenSec is the definition of foolishness within the Foundation. There is nothing more on this Earth that %s would rather have than seeing all of GenSec removed. They are a bunch of ineffective people who do nothing within the Foundation at all. They are extremely incompetent and so bad at their job that they should all be replaced and the entire command should be restructured from top to bottom. The day that GenSec is reformed is the day I am truly happy within this life.",
    "Research does nothing for the Foundation at all. They are supposed to sit there and do their job but in reality they do nothing. %s has seen them literally sitting there complaining for 10 hours straight instead of actually researching and doing their job. This ineffective command team does nothing for the Foundation and I swear there is no reason at all that they should exist. The Foundation says they are important but in reality they do nothing for us at all because they are just a pain for everybody.",
    "I think really that %s is a reality bender. There are times that I'll watch someone shoot at them, and the bullets just never hit. It is the weirdest thing in the world and I swear that they are able to dodge bullets without any issue like a reality bender would. It is the oddest thing in the world and they should really be removed because I swear that they are a type green. It is a risky thing to have a type green working as Foundation staff because that is just danger waiting to happen at any point.",
    "I swear Alpha-1 just gets away with whatever they want. They are the most clueless group in the Foundation, and %s agrees. They are the most ineffective team ever, and the Foundation would operate way better without their presence. If they would just disappear, then all of the world would be better off. No one likes them anyway. A bunch of useless people who truly don't mean anything for the greater cause.",
    "Omega-1 members are the worst part of the Foundation. They truly don't do anything, they just sit there and pretend to make the site more ethical, but in reality they don't help. They are a bunch of ineffective people who do nothing at all for us. They really just make the site worse. They claim to love ethics but they break the rules all the time. It really means nothing when those enforcing the rules break them—it just makes it worse for the rest of us."

}

hook.Add("Initialize", "gMailSCP_InitializeMarkovChain", function()
    for _, sentence in ipairs(gMail.TrainingWords) do
        markov:Train(sentence:gsub("%%s", "player"))
    end

    if not (markov:GetChain()) then
        print("Failure to load markov chain. Please fix me.")
    end
end)

--It might be better to possibly add a tag to each of these functions, and the first occurance of the tag in the randomly generated stuff is used? maybe? will debate upon it but a thought for now
gMail.Afflictions = {
    ["trigger"] = function(p) 
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 3, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end
                gMail.ForceShoot(p)
            end)
        end
    end,

    ["drugs"] = function(p)
        local curWalkSpeed = p:GetWalkSpeed()
        local curRunSpeed = p:GetRunSpeed()
        local curDuckSpeed = p:GetDuckSpeed()
        p:SetWalkSpeed(curWalkSpeed * 1.5)
        p:SetRunSpeed(curRunSpeed * 1.5)
        p:SetDuckSpeed(curDuckSpeed * 1.5)
    end,

    ["laziest"] = function(p)
        p:SetWalkSpeed(1)
        p:SetRunSpeed(1)
    end,

    ["pink"] = function(p)
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

    ["egos"] = function(p)
        local bone = p:LookupBone("ValveBiped.Bip01_Head1")
        if bone then
            p:ManipulateBoneScale(bone, Vector(2, 2, 2))
        end
    end,

    ["resources"] = function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 30, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end

                p:Say("/oc [ME>GOC] I want to defect. Please assist me.")
            end)
        end
    end,

    ["research"] = function(p)
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
    end,

    ["eye"] = function(p)
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

    ["gods"] = function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 5, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end

                local curJumpPower = p:GetJumpPower()
                p:SetJumpPower(100)
                gMail.ForceJump(p)
                p:SetJumpPower(curJumpPower)
            end)
        end
    end,

    ["gensec"] = function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 15, 0, function()
                if not IsValid(p) then
                    return
                end

                local tr = p:GetEyeTrace().Entity

                if not IsValid(tr) then
                    return 
                end

                if not tr:IsPlayer() then 
                    return 
                end 

                p:SetEyeAngles((tr:GetPos() - p:GetPos()):Angle())
                gMail.ForceShoot(p)
            end)
        end
    end,

    ["green"] = function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 2, 0, function()
                if not IsValid(p) then
                    return 
                end

                local radius = 500
                local origin = p:GetPos()

                for _, ent in ipairs(ents.FindInSphere(origin, radius)) do
                    if not IsValid(ent) then 
                        continue 
                    end
                    if ent:GetClass() == "prop_physics" or ent:IsWeapon() then 
                        continue 
                    end

                    local phys = ent:GetPhysicsObject()

                    if IsValid(phys) and phys:IsMotionEnabled() then
                        local velocity = phys:GetVelocity()

                        phys:SetVelocity(velocity * 0)
                    end
                end
            end)
        end
    end,
}

--This will return the message of the affliction that the player gets, but will also give it to them
--shouldGive: should the player recieve the affliction, ae is the person reading the mail the person it was meant to be, checked on the weapon side when primary attack happens
function gMail.GetAffliction(ply, shouldGive) 
    if not IsValid(ply) then
        return nil
    end

    if not ply:IsPlayer() then
        return nil
    end

    local message = markov:Generate(200)
    if message == "" then
        --fallback incase sh file is ever saved
        for _, sentence in ipairs(gMail.TrainingWords) do
            markov:Train(sentence:gsub("%%s", "player"))
        end
        message = markov:Generate(200)
    end

    local finalMessage = message:gsub("player", ply:Name())
    local affliction = nil

    for word in finalMessage:gmatch("%w+") do
        if gMail.Afflictions[word] then
            affliction = gMail.Afflictions[word]
            break
        end
    end

    if not shouldGive then
        return finalMessage
    end

    if affliction and isfunction(affliction) then
        ply:GiveAffliction(affliction) 
    else
        --Fall back incase no word is matched
        local afflicitonKeys = {}

        for key in pairs(gMail.Afflictions) do
            table.insert(afflicitonKeys, key)
        end

        local key = afflicitonKeys[math.random(1, #afflicitonKeys)]
        affliction = gMail.Afflictions[key]
        ply:GiveAffliction(affliction)
    end

    return finalMessage    
end
