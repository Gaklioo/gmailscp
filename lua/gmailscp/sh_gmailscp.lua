gMail = gMail or {}

gMail.Cooldown = 300
gMail.PlayerHurtTime = 600
gMail.PlayerAfflictionTime = 360
gMail.MailDespawnTime = 300
gMail.PlayerHurtTimerName = "gMailSCP_Affliction_KillPlayer"

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
    "I swear %s really doesnt know anything about trigger control. there is no reason at all that they should be able to hold a weapon. every time i see them i swear they just shoot at random. i would never in a million years trust them with ammo. i fucking hate that people give them weapons still. they need to be fired now because they are so dumb. i would never let them in my squad ever.",
    "ive seen %s taking drugs before. they are the devil's advocate and take drugs whenever they can. ive seen them snorting something whenever they are alone. the fact that they still are within the foundation is amazing to me. it shows the true incompetence of the foundation to let a drug addict work here. they are nothing but a waste of space and need to be fired asap because really they are the stupidest person ive ever seen",
    "%s is the laziest foundation person in the world. they are nothing but a useless sack of potatoes and do nothing for the foundation but waste resources. they are dumb and idiotic, and without them we would be so much further ahead in our research and containment abilities. ive seen turtles outrun them because he is just that slow. there is nothing more in this world that i hate than people who move slow and there is nothing i would do for them to go away",
    "there is nothing more than %s hates in this world than the color pink and its so stupid. knowing that they hate this color so much is incredible because its just a color. everytime i hear them talk theyre always complaining about how everything is pink. it is such a stupid waste of time to talk to them because there is nothing they talk about other than how everything is pink. i would rather watch paint dry then talk to them ever again",
    "there are just some people that have huge egos that will never be quelled like %s's. every time i hear them talk its like they have the biggest head in the universe and just cant get over themselves. there is nothing more in this world that i hate than people who just cant shut the hell up about themselves. its like they are just so incompetent that everything needs to be about them. they just sit here and ruin the foundation because they are unable to speak normally, and no one likes it at all.",
    "in this world there is fucking nothing more than i hate than %s. they are lazy and incompetent and everytime they get a damn eye exam they always fail. every single time this idiot gets an eye exam they fail it and there is fucking nothing in this world more than i hate than them trying to claim they passed. an idiot who never gets a proper eye exam and then complain how perfect their eyesight is when they cant see shit. a bunch of fucking moronic words coming from the biggest idiot in the goddamn foundation.",
    "the foundation is so useless because of %s. theyre so bald i think that id fucking get blinded by their scalp if they ever walked underneath light. they never will though because theyre nothing but a stupid fucking goblin that sits in their little hidey hole all day like some goddamned idiot or something. there is nothing more in this foundation that i hate than them. they are the most useless idiot i have ever seen and do nothing but waste space and air within the foundation because they are the biggest bald bitch in the world",
    "the ethics in this foundation are the biggest waste of resources that i %s have ever seen. they just sit there and deny every test because they think that they are the gods of the foundation and nothing is above them. they think they are absolute but in reality they are the biggest goddamned useless people in the world. without them research would be so far ahead, and life would be so much better without their stupid interference within the foundation and its normal operations. a bunch of useless idiots is what they are.",
    "the site inspectiors %s council are a bunch of morons who have no clue what right and wrong truly are. they just meet in their space and talk about how cool and secretive they are. its so stupid how they think they are above everything and everything they do are the absolute biggest waste of idiotic space in the world. they do nothing but act superior to the rest of the foundation and waste our time. without them the foundation would be so far ahead in the correct procedures because they are so useless its insane. they just sit there and do nothing for the foundation.",
    "gensec is the definition of idiots within the foundation. there is nothing more in this earth than %s would rather have than killing all of gensec and getting rid of them all. they are a bunch of useless idiots who do nothing within the foundation at all. they are extremely useless and so shitty at their job that they should all be fired and the entire command should be wiped from the top down. the day that gensec dies is the day that i am truly happy within this life.",
    "research does nothing for the foundation at fucking all. they are supposed to sit there and do their job but in reality they do fuck all. %s has seen them literally sitting there complaining for 10 hours straight instead of actually researching and doing their job. this stupid command team does nothing for the foundation and i swear there is no reason at all that they should exist. the foundation says they are important but holy shit in reality they do nothing for us at all because they are just a pain in the ass for everybody.",
    "i think really that %s is a reality bender. there is sometimes that ill watch someone shoot at him, and the bullets will just never hit him. it is the weirdest thing in the world and i swear that they are able to dodge bullets without any issue like a reality bender would. it is the oddest thing in the world and they should really be fired because i swear that they are a type green. it is an idiotic thing to have a type green working as a foundation staff member because that is just danger waiting to happen at any point.",
    "i swear alpha-1 just gets away with whatever the hell they want. they are the biggest idiots of the foundation, and %s agrees. they are the biggest idiots ever, and the foundation would operate way better without their presence within the foundation. if they would just straight up disapper then all of the world would be better off, no one likes them anyway. a bunch of useless idiots that truly dont mean anything for the greator cause.",
    "omega-1 members are the worst scum of the foundation. they truly dont do anything, they think they just sit there and make the site more ethical but in reality they dont do shit. they are a bunch of idiots that do nothing at all for us. they really just make the site worse, they claim to love ethics but they sit there and break it all the time. it really means nothing when those enforcing the rules break them, it just makes it worse for the rest of us."

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