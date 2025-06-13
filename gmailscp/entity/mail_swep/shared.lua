--The swep that the player is given for the entity, on drop it creates the entity that the person reciving the mail can use
--Primary click: Create UI that the player can choose to click on a button that says Read
gMailSwep = gMailSwep or {}
gMailSwep.Primary = gMailSwep.Primary or {}
gMailSwep.Secondary = gMailSwep.Secondary or {}
gMailSwep.PrintName = "Mail"
gMailSwep.Author = "Gak"
gMailSwep.Purpose = "Left Mouse: Drop Mail \nRight Mouse: Read Mail"

gMailSwep.Slot = 1
gMailSwep.SlotPos = 3

gMailSwep.Spawnable = true -- Remove when not testing

gMailSwep.ViewModel = ""
gMailSwep.WorldModel = ""
gMailSwep.ViewModelFOV = 90

gMailSwep.UseHands = true 
gMailSwep.Primary.Clipsize = -1
gMailSwep.Primary.DefaultClip = -1
gMailSwep.Primary.Automatic = false 
gMailSwep.Primary.Ammo = "none"

gMailSwep.Secondary.Clipsize = -1
gMailSwep.Secondary.DeafultClip = -1
gMailSwep.Secondary.Automatic = false 
gMailSwep.Secondary.Ammo = "none"

function gMailSwep:Initialize()
    self:SetHoldType("fist")
    self.Target = nil
end

function gMailSwep:SetupDataTables()
    self:SetNW2Entity("IntendedPlayer", nil)
end


weapons.Register(gMailSwep, "mail_swep")