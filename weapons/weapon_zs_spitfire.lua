AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_spitfire")) -- 'Spitfire' Burn Rifle
SWEP.Description = (translate.Get("desc_spitfire")) -- Поджигает цель при попадании, абилити способная сделать это в несколько раз сильнее

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.HasAbility = true

SWEP.AbilityMax = 1000

-- Ивент оружие, новый уровень cinderrod, способен поджигать всех зомби в радиусе (возможно может вызвать лаги сервера, если такое будет, то от оружия можно избавиться)
-- На данный момент это последнее такое оружие. Будут ли еще? Без понятия.
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ViewModelFlip = false
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "SPITFIRE")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "SPITFIRE")
	end

	SWEP.VElements = {
		["pipe++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(0.699, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.15, 0.4, 0.2), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_vehicles/carparts_muffler01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(1, -0.201, -15), angle = Angle(90, -90, 0), size = Vector(0.2, 0.3, 0.25), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(0, 0, -10), angle = Angle(0, 0, 90), size = Vector(0.25, 0.3, 0.15), color = Color(240, 40, 10, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0.5, 7), angle = Angle(0, -90, 0), size = Vector(1, 1, 0.899), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["pipe++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(0.699, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.15, 0.4, 0.2), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_vehicles/carparts_muffler01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(1, -0.201, -15), angle = Angle(90, -90, 0), size = Vector(0.2, 0.3, 0.25), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(0, 0, -10), angle = Angle(0, 0, 90), size = Vector(0.25, 0.3, 0.15), color = Color(240, 40, 10, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19, 1, -5), angle = Angle(85.324, 0, 180), size = Vector(1, 1, 0.899), color = Color(240, 40, 10, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Sound = ")weapons/deagle/deagle-1.wav"
SWEP.Primary.Damage = 110
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.75

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.ReloadSound = Sound("weapons/aug/aug_boltslap.wav")
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.5
SWEP.ReloadDelay = 0.5

SWEP.Recoil = 1

SWEP.Tier = 4

SWEP.FireAnimSpeed = 0.5

SWEP.TracerName = "tracer_firebullet"

SWEP.ConeMax = 4
SWEP.ConeMin = 1

SWEP.Pierces = 3
SWEP.DamageTaper = 0.75

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ForceShotgunRules = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05, 3)

function SWEP:Think()
	if self:ShouldDoReload() then
		self:DoReload()
	end

	if self:GetResource() >= self.AbilityMax then
		self:SetTumbler(true)
		self:SetResource(self.AbilityMax)
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 100, math.random(125, 150), 1)
	self:EmitSound("npc/sniper/sniper1.wav", 75, math.random(65, 75), 0.6, CHAN_WEAPON + 20)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()
	local damage = dmginfo:GetDamage()
	local zeroclip = wep:Clip1() == 0
	
	if ent:IsValidLivingZombie() then
		if wep:GetResource() <= 10 then
			wep:SetResource(0)
			wep:SetTumbler(false)
		end

		if SERVER and IsValid(wep) and wep:GetTumbler() then
			wep:SetResource(0)
		end
	end
	
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		if SERVER then
			ent:AddBurnDamage(dmginfo:GetDamage(), attacker or dmginfo:GetInflictor(), attacker.BurnTickRate or 1)
		end
	end
	
	if SERVER and ent:IsValidLivingZombie() and not wep:GetTumbler() then
			for _, ent2 in pairs(util.BlastAlloc(attacker:GetActiveWeapon(), attacker, pos, 48)) do
				if ent2:IsValidZombie() then
					ent2:AddBurnDamage(dmginfo:GetDamage(), attacker or dmginfo:GetInflictor(), attacker.BurnTickRate or 1)
				end
			end
	end
	
	if SERVER and ent:IsValidLivingZombie() and wep:GetTumbler() then
		util.BlastDamagePlayer(wep, attacker, tr.HitPos, 128 * (attacker.ExpDamageRadiusMul or 1), damage, DMG_ALWAYSGIB, 0.8)
			for _, ent2 in pairs(util.BlastAlloc(attacker:GetActiveWeapon(), attacker, pos, 224)) do
				if ent2:IsValidZombie() then
					ent2:AddBurnDamage(dmginfo:GetDamage() * 3, attacker or dmginfo:GetInflictor(), 0.2)
				end
			end
	end
	
	if ent:IsValidLivingZombie() and not wep:GetTumbler() then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_fire", effectdata)
	end
	
	if ent:IsValidLivingZombie() and wep:GetTumbler() then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_spitfire", effectdata)
	end
end

function SWEP:SecondaryAttack()
end

if not CLIENT then return end

local ghostlerp = 0
function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:IsReloading() then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.5)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 0.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
	end

	return pos, ang
end
