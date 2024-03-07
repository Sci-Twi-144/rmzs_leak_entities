AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_crossfire")) -- 'Crossfire' Magnum
SWEP.Description = (translate.Get("desc_crossfire")) -- Ведет огонь в попеременном перекрещивании
SWEP.Slot = 1
SWEP.SlotPos = 0

-- Ивент оружие, револьвер из Awesome Strike Source
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

sound.Add(
{
	name = "Weapon_Crossfire.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitchstart = 60,
	pitchend = 60,
	sound = ")weapons/357/357_fire2.wav"
})

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Python"
	SWEP.HUD3DPos = Vector(0.85, 0, -2.5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
	
	SWEP.VElements = {
		["glow1"] = { type = "Sprite", sprite = "sprites/glow04", bone = "Base", rel = "python", pos = Vector(0, -1.857, -0.788), size = { x = 1.347, y = 1.347 }, color = Color(255, 177, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["deco1"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Python", rel = "python", pos = Vector(0.063, -0.288, -2.289), angle = Angle(-45, 90, 0), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cross"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "Base", rel = "python", pos = Vector(0, -0.5, 11), angle = Angle(180, 0, 0), size = Vector(0.25, 0.25, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cross+"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "Base", rel = "python", pos = Vector(0, -0.5, 11), angle = Angle(180, 90, 0), size = Vector(0.25, 0.25, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["python"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Python", rel = "", pos = Vector(0, 0, -1.3), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["glow1"] = { type = "Sprite", sprite = "sprites/glow04", bone = "ValveBiped.Bip01_R_Hand", rel = "python", pos = Vector(0, -1.857, -0.788), size = { x = 1.347, y = 1.347 }, color = Color(255, 177, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["deco1"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "python", pos = Vector(0.063, -0.288, -2.289), angle = Angle(-45, 90, 0), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cross"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "python", pos = Vector(0, -0.5, 11), angle = Angle(180, 0, 0), size = Vector(0.25, 0.25, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["python"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.025, 1.031, -3.863), angle = Angle(180, 90, 90), size = Vector(0.1, 0.1, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cross+"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "python", pos = Vector(0, -0.5, 11), angle = Angle(180, 90, 0), size = Vector(0.25, 0.25, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Crossfire.Single")

SWEP.Primary.Delay = 1
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 5

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Tier = 4

SWEP.ConeMax = 6.75
SWEP.ConeMin = 4

SWEP.IronSightsPos = Vector(-2.75, 1, 1.25)
SWEP.IronSightsAng = Vector(0.5, 0.1, 1)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.07, 1)

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local sprd = (self.AttackContext and 2 or 2.75)*cone/6
	local recp = self.AttackContext and 2 or 1.25
	self.SpreadPattern = {}
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	for i = 1, numbul do
		local delta = 10/(numbul-1)
		local curpos = -5 - delta + delta * i
		self.SpreadPattern[i] = self:GetDTBool(2) and {curpos, 0} or {0, curpos}
	end
	owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	self:SetDTBool(2, not self:GetDTBool(2))
	owner:LagCompensation(false)
end