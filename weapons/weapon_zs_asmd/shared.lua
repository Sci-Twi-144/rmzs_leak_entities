DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_asmd"))
SWEP.Description = (translate.Get("desc_asmd"))

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/asmd/v_shock_rifle.mdl"
SWEP.WorldModel = "models/rmzs/weapons/asmd/w_shock_rifle.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 53.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.2

SWEP.Primary.ClipSize = 35
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 35

SWEP.ConeMax = 0.65
SWEP.ConeMin = 0.5

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 5
SWEP.ASMD = true

SWEP.Primary.ProjExplosionRadius = 124
SWEP.Primary.ProjExplosionTaper = 0.75

SWEP.TracerName = "tracer_cosmos"

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

-- function SWEP:SendWeaponAnimation()
	-- self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	-- self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 0.35)

	-- timer.Simple(0.2, function()
		-- if IsValid(self) then
			-- self:SendWeaponAnim(ACT_VM_DRAW)
			-- self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 10.5)
		-- end
	-- end)
-- end

function SWEP:Reload()
end

-- function SWEP:CanPrimaryAttack()
	-- if self:GetPrimaryAmmoCount() <= 1 then
		-- return false
	-- end

	-- if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	-- return self:GetNextPrimaryFire() <= CurTime()
-- end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() < 2 then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:EmitFireSound(secondary)
	self:EmitSound(secondary and "weapons/zs_asmd/secondary2.wav" or "weapons/zs_asmd/main3.wav", 75, math.random(105, 110))
	self:EmitSound("weapons/zs_inner/innershot.ogg", 72, 231, 0.45, CHAN_AUTO)
end

function SWEP:TakeAmmo(secondary)
	self:TakeCombinedPrimaryAmmo(secondary and 5 or 2)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_GENERIC)
	return {impact = false}
end

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
	self:SetBlock(false)
end

function SWEP:SecondaryAttack()
	if self:GetPrimaryAmmoCount() < 5 or not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (self:GetBlock() and 1 or 0.3))
	self:EmitFireSound(true)
	self:TakeAmmo(true)

	if SERVER then
		self:ShootSecondary(self.Primary.Damage * 1.67, 1, self:GetCone()/3) --1.4
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SetBlock(true)
end

function SWEP:SetBlock(bool)
	self:SetDTBool(10, bool)
end

function SWEP:GetBlock()
	return self:GetDTBool(10)
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

local M_Player = FindMetaTable("Player")
local P_Team_Old = M_Player.Team

local function P_Team(pl)
	return (IS_SERVER_RUNNING and InitPlayerTeams[pl] or P_Team_Old(pl)) or P_Team_Old(pl)
end

local function EntityIsPlayer(e)
	return getmetatable(e) == M_Player
end

local temp_ignore_team
local temp_shooter = NULL
local temp_attacker = NULL

local function BulletFilter(ent) -- full copy
	if ent and isnumber(ent) then
		ent = Entity(ent) -- Convert to real entity.
	end

	if ent == temp_shooter or ent == temp_attacker or EntityIsPlayer(ent) and P_Team(ent) == temp_ignore_team then
		return false
	end

	local etbl = E_GetTable(ent)
	if etbl.IsASMDProj then
		return true
	end

	if etbl.NeverAlive or SpawnProtection[ent] or etbl.IgnoreBullets then
		return false
	end

	if etbl.AlwaysImpactBullets then
		return true
	end

	if IS_SERVER_RUNNING and GAMEMODE.ZombieEscape then
		return use_ze_bullet and not EntityIsPlayer(ent) or (ZE_IsBoss and not ZE_IsBoss(ent, etbl))
	end

	return true
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	temp_shooter = owner
	temp_attacker = owner

	if not GAMEMODE.AllowFriendlyFireCollision then
		temp_ignore_team = P_Team(owner)
	else
		temp_ignore_team = nil
	end

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
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, stbl.Pierces, stbl.DamageTaper, dmg, nil, stbl.Primary.KnockbackScale, stbl.TracerName, stbl.BulletCallback, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, BulletFilter, self)
	owner:LagCompensation(false)

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
end
