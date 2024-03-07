AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_waraxe2014")) -- 'Waraxe 2014' Handgun
SWEP.Description = (translate.Get("desc_waraxe2014")) -- Старая версия Waraxe, стреляет по 2 пули сразу

SWEP.Slot = 1
SWEP.SlotPos = 0

-- Ивентовое оружие. Просто старый Waraxe из 2014 сборки, который крафтился из двух Battleaxe (отсюда и название Waraxe), что было практически не возможно, так как нельзя было иметь два одинаковых типов оружий в инвентаре.
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DPos = Vector(-0.95, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DBone = "v_weapon.USP_Slide"
	
	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.ViewModelBoneMods = {
		["v_weapon.USP_Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, Vector(-0, 0, 15) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/concrete_barrier001a.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(-0.69, -3.5, -1.5), angle = Angle(0, 0, 90), size = Vector(0.019, 0.019, 0.019), color = Color(203, 233, 236, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "v_weapon.USP_Parent", rel = "base+", pos = Vector(-1.201, 0, -0.7), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_junk/cinderblock01a.mdl", bone = "v_weapon.USP_Parent", rel = "base", pos = Vector(0.5, 3, 0), angle = Angle(0, 90, 90), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "v_weapon.USP_Parent", rel = "base+", pos = Vector(-1.201, 0, 0.699), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/concrete_barrier001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.659, 2.4, -3.651), angle = Angle(0, 85, 0), size = Vector(0.019, 0.019, 0.019), color = Color(203, 233, 236, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+", pos = Vector(-1.201, 0, -0.7), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_junk/cinderblock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.5, 3, 0), angle = Angle(0, 90, 90), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+", pos = Vector(-1.201, 0, 0.699), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_USP.Single")
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 14
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.IronSightsPos = Vector(-5.9, 12, 2.3)

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1.75

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end