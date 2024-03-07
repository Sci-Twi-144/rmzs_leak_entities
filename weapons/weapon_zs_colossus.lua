AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_colossus"))
SWEP.Description = (translate.Get("desc_colossus"))

SWEP.HasAbility = true
SWEP.AbilityMax = 50
SWEP.ResourceCap = SWEP.AbilityMax

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "root"
	SWEP.HUD3DPos = Vector(5, 5, 3)
	SWEP.HUD3DAng = Angle(180, 0, 270)
	SWEP.HUD3DScale = 0.03

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "EXTERMINATE HORDE")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "EXTERMINATE HORDE")
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/rmzs/railgun/c_railgun.mdl"
SWEP.WorldModel = "models/weapons/rmzs/railgun/w_railgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 160
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.HeadshotMulti = 1.75
SWEP.ReloadSound = Sound("ambient/machines/thumper_startup1.wav")

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 9

SWEP.ConeMax = 0.25
SWEP.ConeMin = 0.25

SWEP.Recoil = 5

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.FireAnimSpeed = 1

SWEP.TracerName = "tracer_colossus"

SWEP.ReloadDelay = 2.1
SWEP.ReloadSpeed = 1
SWEP.Tier = 6

SWEP.MaxStock = 2

SWEP.Pierces = 5
SWEP.DamageTaper = 0.85
SWEP.ProjExplosionTaper = SWEP.DamageTaper
SWEP.Primary.HullSize = nil

SWEP.BasePrimaryDamage = SWEP.Primary.Damage
SWEP.BaseTapper = SWEP.DamageTaper
SWEP.BasePierces = SWEP.Pierces

SWEP.SpecificCond = true

SWEP.ResistanceBypass = 0.3

SWEP.ReloadActivity = ACT_VM_PRIMARYATTACK

SWEP.piercenum = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.035)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Benladus' Massive Explosion", "При попадании по зомби, наносит урон по области, урон равен остатку количества здоровья от зомби, с верхним порогом", function(wept)
		wept.Primary.ClipSize = 3
		wept.RequiredClip = 3
		wept.Primary.Damage = wept.Primary.Damage * 0.683
		wept.TracerName = "tracer_colossus_expl"
		wept.Pierces = 1
		wept.DamageTaper = 0.75
		wept.ProjExplosionTaper = wept.DamageTaper
		wept.IsAoe = true
		wept.HasAbility = false

		wept.BulletCallback = function(attacker, tr, dmginfo)
			local ent = tr.Entity
			local wep = dmginfo:GetInflictor()
			local owner = wep:GetOwner()
			local pos = tr.HitPos
			local minushp = math.min(ent:Health(), dmginfo:GetDamage() * 1.85)
				if SERVER and ent:IsValidLivingZombie() and wep:IsValid() then
					if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
						timer.Simple(0.06, function()
							util.BlastDamagePlayer(dmginfo:GetInflictor(), owner, pos, 120 * (attacker.ExpDamageRadiusMul or 1), minushp, DMG_ALWAYSGIB, 0.85)
						end)
					end
				end
		end
			
		-- wept.OnZombieKilled = function(self, zombie, total, dmginfo)
			-- local killer = self:GetOwner()
			-- local minushp = -zombie:Health()
			-- if killer:IsValidLivingHuman() and minushp > 20 then
				-- local pos = zombie:GetPos()
				-- if dmginfo:GetInflictor() == killer:GetActiveWeapon() then
					-- timer.Simple(0.06, function()
						-- if killer:IsValidLivingHuman() then
							-- util.BlastDamagePlayer(killer:GetActiveWeapon(), killer, pos, 128 * (killer.ExpDamageRadiusMul or 1), minushp, DMG_ALWAYSGIB, 0.85)
						-- end
					-- end)
				-- end

				-- local effectdata = EffectData()
					-- effectdata:SetOrigin(pos)
				-- util.Effect("Explosion", effectdata, true, true)
			-- end
		-- end
		
		wept.SecondaryAttack = function(self)
		end
		
		wept.PrimaryAttack = function(self)
			self.BaseClass.PrimaryAttack(self)
		end
		
	if CLIENT then
		wept.AbilityBar3D = function(self, x, y, hei, wid, col, val, max, name)
		end

		wept.AbilityBar2D = function(self, x, y, hei, wid, col, val, max, name)
		end
	end
		
	end)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	if vm:IsValid() then
		vm:SetPlaybackRate(0.5 * speed)
	end

	self.ReloadTime =  2.1 / speed
	self:SetReloadFinish(CurTime() + 2.1 / speed)

	if IsFirstTimePredicted() then
		self:EmitSound("ambient/machines/thumper_startup1.wav", 70, 147, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:MockReload()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadFinish(CurTime() + 2.1 / speed)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if self:CanReload() then
		self:MockReload()
	end
end


function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	if self:Clip1() <= 0 then
		self:MockReload()
	end

	return true
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:Clip1() <= 0 and self:GetPrimaryAmmoCount() <= 0 then
		self:MockReload()
	end
end

function SWEP:EmitReloadSound()
end

function SWEP:EmitReloadFinishSound()
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 76, 45, 0.35)
	self:EmitSound("weapons/zs_rail/rail.wav", 76, 100, 0.95, CHAN_WEAPON + 20)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	wep.piercenum = wep.piercenum + 1
	local ent = tr.Entity
	if SERVER and ent and ent:IsValidLivingZombie() then
		if wep:GetResource() >= wep.AbilityMax then
			wep:SetResource(wep.AbilityMax, false)
		end
	end
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	if self:GetResource() >= self.AbilityMax then
		self.Primary.HullSize = 20
		self:SetResource(0)
		self:SetTumbler(true)
		self:PrimaryAttack()
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetTumbler() then
		self.Primary.Damage = self.BasePrimaryDamage + self.BasePrimaryDamage * 1.35
		self.Pierces = self.BasePierces * 3
		self.DamageTaper = 0.95
	else
		self:SetResource(self:GetResource() + self.piercenum, false)
		self.piercenum = 0
		self.Primary.Damage = self.BasePrimaryDamage
		self.Pierces = self.BasePierces
		self.DamageTaper = self.BaseTapper
		self.Primary.HullSize = nil
	end
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:ShootBullets(dmg, numbul, cone)

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

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
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, stbl.Pierces, stbl.DamageTaper, dmg, nil, stbl.Primary.KnockbackScale, stbl.TracerName, stbl.BulletCallback, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
	
	self:SetTumbler(false)
	
	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
end
