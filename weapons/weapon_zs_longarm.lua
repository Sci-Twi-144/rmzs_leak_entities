AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_longarm"))
SWEP.Description = (translate.Get("desc_longarm"))
SWEP.Slot = 1
SWEP.SlotPos = 0

local matBeam = Material("trails/laser")
if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "sw500-gun"
	SWEP.HUD3DPos = Vector(-0.5, 4.75, 0.8)
	SWEP.HUD3DAng = Angle(0, 0, 75)
	SWEP.HUD3DScale = 0.01

	SWEP.VMPos = Vector(1.25, 3, -0.75)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.ViewModelBoneMods = {
		["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
		["L UpperArm"] = { scale = Vector(0.925, 0.925, 0.925), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["R UpperArm"] = { scale = Vector(0.925, 0.925, 0.925), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["A_Optic"] = { scale = Vector(0.65, 0.65, 0.65), pos = Vector(0, 0.2, 0), angle = Angle(0, 0, 0) },
	--	["A_LaserFlashlight"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(1.5, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(1.5, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/w_ins2_revolver_sw500.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.1, -2), angle = Angle(0, -6, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "ANGL"
		elseif self:GetFireMode() == 1 then
			return "NORM"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Angle-related"
		elseif self:GetFireMode() == 1 then
			return "Normal to surface"
		end
	end
	
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		local owner = self:GetOwner()
		if owner:KeyDown(IN_SPEED) and self:GetVectorStart() and self:GetVectorEnd() and self.MainOwner == LocalPlayer() then
			local clrtbl = {
				[1] = Color(0,0,255),
				[2] = Color(0,255,0),
				[3] = Color(255,0,0)
			}			
			local clr = clrtbl[self:GetCollideColor()]
			render.SetMaterial(matBeam)
			render.DrawBeam( self:GetVectorStart(), self:GetVectorEnd(), 5, 0, 1, clr )
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_ins2_revolver_sw500.mdl"
SWEP.WorldModel = "models/weapons/w_ins2_revolver_sw500.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ")weapons/sw500/sw500_fire.wav" --weapons/sw500/sw500_fire
SWEP.Primary.Delay = 0.49
SWEP.Primary.Damage = 120
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 10
SWEP.RequiredClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Recoil = 1.5
SWEP.ReloadSpeed = 0.85

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ConeMax = 3.75
SWEP.ConeMin = 1.65

SWEP.Tier = 4

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.CannotHaveExtendetMag = true

SWEP.IronSightsPos = Vector(-3.2555, -3, 0.85)
SWEP.IronSightsAng = Vector(-0.25, 0.025, 4.5)

SWEP.WallDivide = 9
SWEP.ClassicSpread = true
SWEP.SpreadPattern = {
    {0, 0},
    {-5, 5},
    {0, 3.5},
    {5, 5},
    {3.5, 0},
    {5, -5},
    {0, -3.5},
    {-5, -5},
    {-3.5, 0},
}
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.468)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.206)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Inverter' Revolver", "Вторая цель получает больше урон от пробития", function(wept) -- При пробитии, вторая цель получает больше урон
	wept.Primary.Damage = wept.Primary.Damage * 0.494
	wept.RequiredClip = 2
	wept.Pierces = 3
	wept.DamageTaper = 1.2
	wept.CantSwitchFireModes = true
	
	wept.BulletCallback = function(attacker, tr, dmginfo)
	end
	
	wept.Think = function(self)
		BaseClass.Think(self)
	end	
end)

local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_hm500")), (translate.Get("desc_hm500")), "weapon_zs_hm500")
branch2.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

SWEP.IsShooting = 0

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	timer.Simple(0.06, function()
		self.MainOwner = self:GetOwner()
	end)
end

function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	attacker.RicochetBullet = true
	if attacker:IsValid() then
		FORCE_B_EFFECT = true
		local aw = attacker:GetActiveWeapon()
		local curfiremode = aw:GetFireMode()
		aw.ClassicSpread = false
		attacker:FireBulletsLua(hitpos,  curfiremode == 0 and (2 * hitnormal * hitnormal:Dot(normal * -1) + normal) or hitnormal, 3, 9, 1, 1, 2 * damage / aw.WallDivide, nil, nil, "tracer_rico", nil, nil, nil, nil, nil, aw)
		aw.ClassicSpread = true
		FORCE_B_EFFECT = nil
	end
	attacker.RicochetBullet = nil
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage()
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
	if owner:KeyDown(IN_SPEED) then
		local dir = owner:GetAimVector()
		local tracec = {mask = MASK_SOLID_BRUSHONLY}
		local shootpos = owner:GetShootPos()
		
		tracec.start = shootpos
		tracec.endpos = shootpos + dir * 10000
		--tracec.filter = function (ent) return obstacles[ent:GetClass()] end
		local tr = util.TraceLine(tracec)
		if tr.HitWorld then
			self:SetVectorStart(tr.HitPos)
			self:RicoLine(tr.HitPos, tr.HitNormal, tr.Normal)
		end
	end
end

function SWEP:RicoLine(hitpos, hitnormal, normal)
	local owner = self:GetOwner()
	local traceb = {mask = MASK_SHOT}
	local curfiremode = self:GetFireMode() 
	local dir = (curfiremode == 0) and (2 * hitnormal * hitnormal:Dot(normal * -1) + normal) or hitnormal
	
	traceb.start = hitpos
	traceb.endpos = hitpos + dir * 10000
	traceb.filter = function (ent) return ent:IsValidLivingZombie() end
	local tr = util.TraceLine(traceb)
	if tr.Entity and tr.Entity:IsValidLivingZombie() then
		self:SetVectorEnd(tr.HitPos)
		self:SetCollideColor(tr.HitGroup == HITGROUP_HEAD and 3 or 2)
	else
		self:SetVectorEnd(tr.HitPos)
		self:SetCollideColor(1)
	end
end

function SWEP:SetVectorStart(vec)
	self:SetDTVector( 15, vec )
end

function SWEP:GetVectorStart()
	return self:GetDTVector(15)
end

function SWEP:SetVectorEnd(vect)
	self:SetDTVector( 16, vect )
end

function SWEP:GetVectorEnd()
	return self:GetDTVector(16)
end

function SWEP:SetCollideColor(num)
	self:SetDTInt( 14, num )
end

function SWEP:GetCollideColor()
	return self:GetDTInt(14)
end

sound.Add({
	name = 			"TFA_INS2.SW500.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/revolver_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.CockHammer",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/revolver_cock_hammer.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.OpenChamber",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/sw500_openchamber.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.CloseChamber",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/sw500_closechamber.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.DumpRounds1",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/sw500_dumprounds1.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.DumpRounds2",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/sw500_dumprounds2.wav"
})

sound.Add({
	name = 			"TFA_INS2.SW500.RoundIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/sw500/sw500_roundin.wav"
})
