AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_berdan"))
SWEP.Description = (translate.Get("desc_berdan"))

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.AbilityText = "" -- "ANCIENT POWER"
SWEP.AbilityColor = Color(250, 108, 65)
SWEP.AbilityMax = 2000

if CLIENT then
	SWEP.HUD3DBone = "body"
	SWEP.HUD3DPos = Vector(-7, -1, -1.5)
	SWEP.HUD3DAng = Angle(180, 90, 90)
	SWEP.HUD3DScale = 0.013

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 56

	SWEP.ViewModelBoneMods = {
	["Bullet"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.03, 0), angle = Angle(0, 0, 0) },
	["L Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.331, 5.087, 7.812) },
	["L Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.6, -29.762, 4.86) },
	["L Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.323, 4.826) },
	["L UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.368), angle = Angle(0, 0, 0) }
	}
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:DrawAds()
		if self.ViewModelFOV == 56 then return end
		if not self:GetIronsights() then
			self.ViewModelFOV = 56
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/rmzs/berdan/c_berdan.mdl"
SWEP.WorldModel = "models/weapons/rmzs/berdan/w_berdan.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false
SWEP.Primary.Sound	= Sound("weapons/berdan/berdan_fire1.mp3")
SWEP.Primary.Damage = 135
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.5
SWEP.RequiredClip = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Recoil = 5
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1.4

SWEP.HeadshotMulti = 2.25

SWEP.ConeMax = 1.6
SWEP.ConeMin = 0.65

SWEP.Tier = 4
SWEP.TimeLost = 0

SWEP.ResistanceBypass = 0.4
SWEP.HasAbility = true

SWEP.InnateTrinket = "trinket_flame_rounds"
SWEP.InnateBurnDamage = true 
SWEP.FlatBurnChance = 50
SWEP.BurnTickRateOff = 1

SWEP.Abilitymulti = 1
SWEP.Texturemulti = 1
SWEP.TimerForAbility = 0

SWEP.WalkSpeed = SPEED_NORMAL
--SWEP.TracerName = "tracer_berdan"

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.IronSightsPos = Vector(-3.66, 3, 2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

local texture = Material( "models/weapons/berdan/berdan_metal.vmt" )
local texture2 = Material( "models/weapons/berdan/berdan_wood.vmt" )

if CLIENT then
	function SWEP:Initialize()
		self.BaseClass.Initialize(self)
		texture:SetFloat("$emissiveblendstrength", 0)
		texture2:SetFloat("$emissiveblendstrength", 0)
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:Think()
	local owner = self:GetOwner()

	if owner:KeyReleased(IN_ATTACK) then
		if self:CanPrimaryAttack() then
			self.BaseClass.PrimaryAttack(self) 
			self:SetTumbler(false)
			self.Abilitymulti = 1
		end
		self.Click = false
	end

	if owner:KeyDown(IN_ATTACK) then
		if not self.Click then
			self.TimerForAbility = CurTime() + 1.2
			self.Click = true
		end

		if not self:GetTumbler() and CurTime() > self.TimerForAbility and self:GetResource() >= 300 then
			self:SetTumbler(true)
		end

		if self:GetTumbler() and self:GetResource() > 0 then
			self.Abilitymulti = self.Abilitymulti + 0.06
			self:SetResource(math.max(self:GetResource() - 40, 0)) 
		end
	end

	self.Texturemulti = math.min(self.Texturemulti + 0.001, self:GetResource() / 2000)
	if CLIENT and self.Texturemulti ~= self:GetResource() then
		texture:SetFloat("$emissiveblendstrength", math.min(self.Texturemulti, 0.97))
		texture2:SetFloat("$emissiveblendstrength", math.min(self.Texturemulti, 0.97))
	end
	
	if not self:GetTumbler() and self.TimeLost <= CurTime() then
		self:SetResource(math.max(self:GetResource() - 4, 0), false)
	end

	self.BaseClass.Think(self)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 
	wep.TimeLost = CurTime() + 7

	if (wep:GetResource() > 0) and not wep:GetTumbler() then

		--[[
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_berdan", effectdata, true, true)
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetScale(1)
		util.Effect("spark_berdan", effectdata, true, true)
		]]

		if tr.HitWorld then
			util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
	end

	if SERVER and ent:IsValidLivingZombie() and wep:IsValid() then
		if wep:GetTumbler() then
			local pos = tr.HitPos
			local damage = (dmginfo:GetDamage() * (0.5 * math.min(3, (ent:GetMaxHealth() * (ent:GetBossTier() < 1 and 0.003 or 0.0015 )))))
			for _, ent2 in pairs(util.BlastAlloc(self, owner, pos, 64 * (attacker.ExpDamageRadiusMul or 1))) do
				if ent2:IsValidZombie() then
					ent2:AddBurnDamage(0.3 * (damage *  (wep.Abilitymulti / 2)), attacker or dmginfo:GetInflictor(), attacker.BurnTickRate or 1)
				end
			end
			util.BlastDamagePlayer(dmginfo:GetInflictor(), attacker, pos, 64 * (attacker.ExpDamageRadiusMul or 1), damage * wep.Abilitymulti, DMG_ALWAYSGIB, 0.8)

			local ent = ents.Create("prop_shieldbr")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				ent.Scale = wep.Abilitymulti
				ent:Spawn()
			end
		end
	end

	if wep:GetResource() >= wep.AbilityMax then
		wep:SetResource(wep.AbilityMax)
	end
end

sound.Add(
{
	name = "berdan.boltrelease",
	channel = CHAN_WEAPON +20,
	volume = 0.7,
	soundlevel = 80,
	
	sound = {"weapons/berdan/berdan_boltrelease.mp3"}
})


sound.Add(
{
	name = "berdan.boltback",
	channel = CHAN_WEAPON +20,
	volume = 0.7,
	soundlevel = 80,
	
	sound = {"weapons/berdan/berdan_boltback.mp3"}
})

sound.Add(
{
	name = "berdan.boltatch",
	channel = CHAN_WEAPON +20,
	volume = 0.7,
	soundlevel = 80,
	
	sound = {"weapons/berdan/berdan_boltatch.mp3"}
})

sound.Add(
{
	name = "berdan.boltforward",
	channel = CHAN_WEAPON +20,
	volume = 0.7,
	soundlevel = 80,
	
	sound = {"weapons/berdan/berdan_boltforward.mp3"}
})


sound.Add(
{
	name = "berdan.roundin",
	channel = CHAN_WEAPON +20,
	volume = 0.7,
	soundlevel = 80,
	
	sound = {"weapons/berdan/berdan_roundin.mp3"}
})

