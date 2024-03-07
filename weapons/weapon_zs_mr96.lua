AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_mr96"))
SWEP.Description = (translate.Get("desc_mr96"))

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 90

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(0.5, -2.25, 1.25)
	SWEP.HUD3DAng = Angle(0, 180, 75)

	SWEP.VMPos = Vector(1.75, 4, 0)

    SWEP.ViewModelBoneMods = {
        --	["A_Underbarrel"] = { scale = Vector(1, 1, 1), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) },
            ["A_Muzzle"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
            ["R UpperArm"] = { scale = Vector(0.86, 0.86, 0.86), pos = Vector(-0.05, 0, -0.08), angle = Angle(0, 0, 0) },
            ["L UpperArm"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["L Finger22"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(-2, 15, 0)  },
            ["L Finger21"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)	},
            ["R Finger11"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(5, -5, 0)	},
            ["R Finger12"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 30, 0)	},
            ["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
            ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.93, 1, 0.93), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
        }
        

	SWEP.VElements = {}
	SWEP.WElements = {
		["element_name"] = { type = "Model", model = "models/weapons/w_ins2_revolver_mr96.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.5, 1.5, -1.75), angle = Angle(1, -4, 178), size = Vector(1.1000000238419, 1.1000000238419, 1.1000000238419), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

    function SWEP:DrawAds()
		if not self:GetIronsights() then
			self.ViewModelFOV = 70
		end
	end

	function SWEP:Draw3DHUD(vm, pos, ang)
		self.BaseClass.Draw3DHUD(self, vm, pos, ang)

		local wid, hei = 180, 200
		local x, y = wid * -0.6, hei * -0.5

		cam.Start3D2D(pos, ang, self.HUD3DScale)
			local owner = self:GetOwner()
			local text = ""

			if self:GetHitStacks() > 0 then
				for i = 0, self:GetHitStacks() - 1 do
					text = text .. "+"
				end
				draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(225, 235, 75, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_ins2_revolver_mr96.mdl"
SWEP.WorldModel	= "models/weapons/w_mr96.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_ins2/mr96/mr96_short.wav"
SWEP.Primary.Damage = 44
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.Recoil = 0.55

SWEP.Primary.Ammo = "pistol"
SWEP.ConeMax = 3.55
SWEP.ConeMin = 1.6

SWEP.ReloadSpeed = 1
SWEP.ReloadSpeedSaved = SWEP.ReloadSpeed

SWEP.IronSightsPos = Vector(-3.6, -4, 1.1025)
SWEP.IronSightsAng = Vector(-1.75, 0, 0)

SWEP.CannotHaveExtendetMag = true

SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivity = ACT_SHOTGUN_RELOAD_START

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.35, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.55, 3)

function SWEP:SendWeaponAnimation()
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
		if CLIENT then
			self.ViewModelFOV = 85
		end
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	self.BaseClass.Think(self)
end

local math_Clamp = math.Clamp

function SWEP:StartReloadingExtra()
    if SERVER then
        self:GetOwner():GiveAmmo(self:Clip1(), "pistol", true)
    end
	self:SetHitStacks(0)
    self:SetClip1(0)
end

function SWEP:DoReloadExtra()
    local clip = math_Clamp(self:Clip1() + 1, 0, self:GetMaxClip1())
    local vm = self:GetOwner():GetViewModel()
    vm:SetBodygroup(1, math_Clamp(self:Clip1(), 0, self:GetMaxClip1()))
    vm:SetBodygroup(2, math_Clamp(self:Clip1(), 0, self:GetMaxClip1()))
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local otbl = owner
	local stbl = self

	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	if stbl.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -stbl.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * stbl.Recoil))
	end

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = stbl.PointsMultiplier
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), (owner:GetAimVector():Angle() + owner:GetViewPunchAngles()):Forward(), cone, numbul, stbl.Pierces, stbl.DamageTaper, dmg, nil, stbl.Primary.KnockbackScale, stbl.TracerName, stbl.BulletCallback, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end

end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER then
		local wep = attacker:GetActiveWeapon()
		if ent:IsValidLivingZombie() then
			if tr.HitGroup == HITGROUP_HEAD then
				wep:SetHitStacks(wep:GetHitStacks() + 1)
			end
			wep.ReloadSpeed = wep.ReloadSpeedSaved + (0.02 * wep:GetHitStacks())
		end
	end
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

sound.Add({
	name = 			"TFA_INS2.MR96.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mr96/revolver_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.MR96.OpenChamber",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mr96/revolver_open_chamber.wav"
})

sound.Add({
	name = 			"TFA_INS2.MR96.CloseChamber",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mr96/revolver_close_chamber.wav"
})

sound.Add({
	name = 			"TFA_INS2.MR96.CockHammer",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mr96/revolver_cock_hammer.wav"
})

sound.Add({
	name = 			"TFA_INS2.MR96.DumpRounds",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			{"weapons/tfa_ins2/mr96/revolver_dump_rounds_01.wav", "weapons/tfa_ins2/mr96/revolver_dump_rounds_02.wav", "weapons/tfa_ins2/mr96/revolver_dump_rounds_03.wav"}
})

sound.Add({
	name = 			"TFA_INS2.MR96.RoundInsertSingle",
	channel = 		CHAN_USER_BASE+11,
	volume =        1.0,
	sound =             {"weapons/tfa_ins2/mr96/revolver_round_insert_single_01.wav", 
    "weapons/tfa_ins2/mr96/revolver_round_insert_single_02.wav", 
    "weapons/tfa_ins2/mr96/revolver_round_insert_single_03.wav", 
    "weapons/tfa_ins2/mr96/revolver_round_insert_single_04.wav", 
    "weapons/tfa_ins2/mr96/revolver_round_insert_single_05.wav", 
    "weapons/tfa_ins2/mr96/revolver_round_insert_single_06.wav"}
})

sound.Add({
	name = 			"TFA_INS2.MR96.RoundInsertSpeedLoader",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		    "weapons/tfa_ins2/mr96/revolver_speed_loader_insert_01.wav"
})