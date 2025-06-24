--The swep that the player is given for the entity, on drop it creates the entity that the person reciving the mail can use
--Primary click: Create UI that the player can choose to click on a button that says Read
SWEP.PrintName = "SCP-7573-1"
SWEP.Author = "Gak"
SWEP.Purpose = "Right Mouse: Drop Mail \nLeft Mouse: Read Mail"

SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.Spawnable = true -- Remove when not testing

SWEP.ViewModel = ""
SWEP.WorldModel = Model("models/weapons/w_suitcase_passenger.mdl")
SWEP.ViewModelFOV = 45

SWEP.UseHands = true 
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DeafultClip = -1
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
    self:SetNW2Entity("intendedPlayer", nil)
end