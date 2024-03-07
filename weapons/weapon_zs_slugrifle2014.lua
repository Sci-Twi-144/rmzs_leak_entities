AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = (translate.Get("wep_slugrifle2014")) -- 'Tiny v2014' Slug Rifle
SWEP.Description = (translate.Get("desc_slugrifle2014")) -- Старая версия винтовки, при убийсте зомби создает взрыв, может создать цепную реакцию
SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, старое тини из 2014 сборки, в оригинале ваншотала в голову любого зомби, кроме боссов. Тут она создает взрыв после убийства цели, урон взрыва составляет 4 умноженное на стоковый урон
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -6, -9), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_weapon.xm1014_Parent", rel = "base", pos = Vector(0, 0, 8.5), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "models/screenspace", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_weapon.xm1014_Parent", rel = "base", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1, -7), angle = Angle(80, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 8.5), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/awp/awp1.wav"
SWEP.Primary.Damage = 135
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = 1

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 10

SWEP.HeadshotMulti = 2

SWEP.Pierces = 2
SWEP.DamageTaper = 1.15

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 5
SWEP.ConeMin = 0.1

SWEP.Tier = 5
SWEP.ResistanceBypass = 0.4

SWEP.Primary.ProjExplosionRadius = 144
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)

-- function SWEP.BulletCallback(attacker, tr, dmginfo)
	-- local effectdata = EffectData()
		-- effectdata:SetOrigin(tr.HitPos)
		-- effectdata:SetNormal(tr.HitNormal)
	-- util.Effect("hit_2014", effectdata)
-- end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:SecondaryAttack()
	return BaseClass.BaseClass.SecondaryAttack(self)
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	BaseClass.Think(self)
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	local killer = self:GetOwner()
	if killer:IsValidLivingHuman() then
		local pos = zombie:GetPos()
			if dmginfo:GetInflictor() == killer:GetActiveWeapon() then
				timer.Simple(0.06, function()
					if killer:IsValidLivingHuman() then
						util.BlastDamagePlayer(killer:GetActiveWeapon(), killer, pos, 144, self.Primary.Damage * 3, DMG_ALWAYSGIB, 0.65)
					end
				end)
			end

			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata, true, true)
		end
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end
