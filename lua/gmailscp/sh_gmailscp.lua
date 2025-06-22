gMail = gMail or {}

gMail.Cooldown = 300
gMail.PlayerHurtTime = 600
gMail.PlayerAfflictionTime = 360
gMail.MailDespawnTime = 300
gMail.PlayerHurtTimerName = "gMailSCP_Affliction_KillPlayer"

gMail.TeamIDs = {}

--Teams in this category are ignored.
gMail.BlacklistedTeams = {
    ["Admin On Duty"] = true
}

if SERVER then
    util.AddNetworkString("gMailSCP_ChangePlayerColor")
    util.AddNetworkString("gMailSCP_RemovePlayerColor")    
    util.AddNetworkString("gMailSCP_StartToyTown")
    util.AddNetworkString("gMailSCP_RemovePlayerToyTown")
end

function gMail.ForceShoot(p)
    p:ConCommand("+attack")
    timer.Simple(0.1, function()
        if IsValid(p) then p:ConCommand("-attack") end
    end)
end

function gMail.ForceJump(p)
    p:ConCommand("+jump")
    timer.Simple(0.1, function()
        if IsValid(p) then p:ConCommand("-jump") end
    end)
end

function gMail.GetTimerName(p)  
    if not IsValid(p) then return end
    if not p:IsPlayer() then return end

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
            current = keys[math.random(#keys)]
        else
            local nextWord = nextWords[math.random(#nextWords)]
            local wordOne, wordTwo = current:match("^(%S+)%s+(%S+)$")
            current = wordTwo .. " " .. nextWord
        end

        table.insert(output, current)
    end

    return table.concat(output, " ")
end

function markov:GetChain()
    return self.chain
end

gMail.TrainingWords = {
    "I swear %s really doesnt know anything about trigger control. there is no reason at all that they should be able to hold a weapon. every time i see them i swear they just shoot at random. i would never in a million years trust them with ammo. i fucking hate that people give them weapons still. they need to be fired now because they are so dumb. i would never let them in my squad ever.",
    "ive seen %s taking drugs before. they are the devils advocate and take drugs whenever they can. ive seen them snorting something whenever they are alone. the fact that they still are within the foundation is amazing to me. it shows the true incompetence of the foundation to let a drug addict work here. they are nothing but a waste of space and need to be fired asap because really they are the stupidest person ive ever seen",
    "%s is the laziest foundation person in the world. they are nothing but a useless sack of potatos and do nothing for the foundation but waste resources. they are dumb and idiotic, and without them we would be so much further ahead in our research and containment abilities. ive seen turtles outrun them because he is just that slow. there is nothing more in this world that i hate then people who move slow and there is nothing i would do for them to go away",
    "there is nothing more than %s hates in this world than the color pink and its so stupid. knowing that they hate this color so much is incredible beacuse its just a color. everytime i hear them talk theyre always complaining about how everything is pink. it is such a stupid waste of time to talk to them because there is nothing they talk about other than how everything is pink. i would rather watch paint dry then talk to them ever again",
    "there are just some people that have huge egos that will never be quelled like %s's. every time i hear them talk its like they have the biggest head in the universe and just cant get over themselves. there is nothing more in this world that i hate then people who just cant shut the hell up about themselves. its like they are just so incompetent that everything needs to be about them. they just sit here and ruin the foundation beacuse they are unable to speak normally, and no one likes it at all.",
    "in this world there is fucking nothing more than i hate than %s. they are lazy and incompetent and everytime they get a damn eye exam they always fail. every single time this idiot gets a eye exam they fail it and there fucking nothing in this world more than i hate then them trying to claim they passed. an idiot who never gets a proper eye exam and then complain how perfect their eyesight is when they can see shit. a bunch of fucking moronic words coming from the biggest idiot in the goddamn foundation.",
    "the foundation is so useless beacuse of %s. theyre so bald i think that id fucking get blinded by their scalp if they ever walked underneath light. they never will though beacuse theyre nothing but a stupid fucking goblin that sits in their little hidey hole all day like some goddamnd idiot or something. there is nothing more in this foundation that i hate than them. they are the most useless idiot i have ever seen and do nothing but waste space and air within the foundation beacuse they are the biggest bald bitch in the world",
    "the ethics in this foundation are the biggest waste of resources that i %s have ever seen. they just sit there and deny every test beacuse they think that they are the gods of the foundation and nothing is above them. they think they are absolute but in reality they are the biggest god damn useless people in the world. without them research would be so far ahead, and life would be so much better without their stupid interference within the foundation and its normal operations. a bunch of useless idiots is what they are.",
    "the overseer %s council are a bunch of morons who have no clue what right and wrong truly are. they just meet in their space and talk about how cool and secretive they are. its so stupid how they think they are above everything and everything they do are the absolute biggest waste of idiotic space in the world. they do nothing but act superior to the rest of the foundation and waste our time. without them the foundation would be so far ahead in the correct procedures because they are so useless its insane. they just sit there and do nothing for the foundation.",
    "%s omega-1 laws left hand do nothing for the foundation what so ever. they only sit there and protect the ethics committee beacuse they think they are so important that they need guards to sit there and be there for them all the time. ive never seen a more useless group than omega1. they think they are the enforcers of ethics words but in reality they sit there and get fat all day. a bunch of idiots with guns is what they are and theyre hated so much.",
    "%s alpha-1 red right hand are the biggest waste of an mtf that there has ever been within the foundation. a bunch of moronic idiots that do nothing but surround themselves with the ego of the o5 council. i mean hell even o5-13 is better than the smartest alpha1 member, and shes one of the damn worst members of the stupid council. i hate the o5 council and everything they do beacuse they do absolutely nothing at all, and they are just a waste of space along with alpha1.",
    "gensec is the definition of idiots within the foundation. there is nothing more in this earth than %s would rather have then killing all of gensec and getting rid of them all. they are a bunch of useless idiots who do nothing within the foundation at all. they are extremly useless and so shitty at their job that they should all be fired and the entire command should be wiped from the top down. the day that gensec dies is the day that i am truly happy within this life.",
    "research does nothing for the foundation at fucking all. they are supposed to sit there and do their job but in reality they do fuck all. %s has seen them literally sitting their complaining for 10 hours straight instead of actually researching and doing their job. this stupid command team does nothing for the foundation and i swear there is no reason at all that they should exist. the foundation says they are important but holy shit in reality they doing nothing for us at all beacuse they are just a pain in the ass for everbody."            
}

hook.Add("Initialize", "gMailSCP_InitializeMarkovChain", function()
    for _, sentence in ipairs(gMail.TrainingWords) do
        markov:Train(sentence:gsub("%%s", "player"))
    end

    if not (markov:GetChain()) then
        print("Failure to load markov chain. Please fix me.")
    end
end)

gMail.Afflictions = {
    function(p) 
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

    function(p)
        local curWalkSpeed = p:GetWalkSpeed()
        local curRunSpeed = p:GetRunSpeed()
        local curDuckSpeed = p:GetDuckSpeed()
        p:SetWalkSpeed(curWalkSpeed * 1.5)
        p:SetRunSpeed(curRunSpeed * 1.5)
        p:SetDuckSpeed(curDuckSpeed * 1.5)
    end,

    function(p)
        p:SetWalkSpeed(1)
        p:SetRunSpeed(1)
    end,

    function(p)
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

    function(p)
        local bone = p:LookupBone("ValveBiped.Bip01_Head1")
        if bone then
            p:ManipulateBoneScale(bone, Vector(2, 2, 2))
        end
    end,

    function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 30, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end

                p:Say("/oc [F>ALL] I hate the ethics committee and the overseer council. A bunch of idiots.")
                p:Say("/oc [F>ALL] Alpha-1 'Red Right Hand' and Omega-1 'Laws left hand' are idiots.")
            end)
        end
    end,

    function(p)
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

    function(p)
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

    function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            timer.Create(timerName, 75, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end

                local curJumpPower = p:GetJumpPower()
                p:SetJumpPower(curJumpPower * 100)
                gMail.ForceJump(p)
                p:SetJumpPower(curJumpPower)
            end)
        end
    end,

    function(p)
        local timerName = gMail.GetTimerName(p)

        if not timer.Exists(timerName) then
            if not gMail.TeamIDs then
                gMail.TeamIDs = {}
                for team, data in pairs(team.GetAllTeams()) do
                    if data.Name then
                        gMail.TeamIDs[data.Name] = team 
                    end
                end
            end

            timer.Create(timerName, 15, 0, function()
                if not IsValid(p) then
                    timer.Remove(timerName)
                end

                local targetTeam = math.random(1, #gMail.TeamIDs)
                local teamID = gMail.TeamIDs[targetTeam]
                if not teamID then return end

                local tr = p:GetEyeTrace().Entity
                if not IsValid(tr) then return end
                if not tr:IsPlayer() then return end

                if tr:Team() != targetTeam then return end

                p:SetEyeAngles((tr:GetPos() - p:GetPos()):Angle())
                gMail.ForceShoot(p)
            end)
        end
    end
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
    local finalMessage = message:gsub("player", ply:Name())
    local affliction = gMail.Afflictions[math.random(#gMail.Afflictions)]

    if shouldGive then
        ply:GiveAffliction(affliction)
    end

    return finalMessage    
end