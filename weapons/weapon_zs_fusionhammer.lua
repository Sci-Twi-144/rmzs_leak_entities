AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_fusionhammer"))
SWEP.Description = (translate.Get("desc_fusionhammer"))
SWEP.AbilityMax = 800

if CLIENT then
	SWEP.ViewModelFOV = 60

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Fire Smack", false)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/rmzs/weapons/fusion_breaker/c_fusion_breaker.mdl"
SWEP.WorldModel = "models/rmzs/weapons/fusion_breaker/w_fusion_breaker.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.SPMultiplier = 1.7 -- кретин

SWEP.MeleeDamage = 165
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 76
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 170

SWEP.Primary.Delay = 1.5

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SwingTime = 0.45
SWEP.SwingRotation = Angle(0, -15, -15)
SWEP.SwingHoldType = "melee2"

SWEP.SwingTimeSP = 0.4

SWEP.BlockRotation = Angle(0, 0, 25)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockReduction = 16
SWEP.BlockStability = 0.25
SWEP.StaminaConsumption = 9.5

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.Tier = 4

SWEP.HasAbility = true
SWEP.ResourceMul = 1

SWEP.AllowQualityWeapons = true
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.ChargeSound = CreateSound(self, "weapons/rmzs/fusion_breaker/fusion_on_loop.ogg")
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if self:GetTumbler() then
		local tbl = {ACT_VM_HITRIGHT, ACT_VM_HITRIGHT2}
		self:SendWeaponAnim(tbl[math.random(2)])
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:SendWeaponAnim(ACT_VM_HITLEFT)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	self:PlayStartSwingSound()

	local time = self:GetTumbler() and stbl.SwingTimeSP or stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time * condition)

	if not self:GetTumbler() then
		self:GetOwner():GetViewModel():SetPlaybackRate(0.85 - ((clamped) - 1))
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetTumbler() then
		self.ChargeSound:PlayEx(1, 100)
	end
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetResource() < self.AbilityMax then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()
	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:ProcessSpecialAttack()
	local vm = self:GetOwner():GetViewModel()
	if self:GetResource() >= self.AbilityMax then
		local stbl = E_GetTable(self)
		self:SendWeaponAnim(ACT_VM_RELOAD)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetResource(0)
		self:SetTumbler(true)
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_startup.ogg", 75, math.Rand(86, 90))
		self.BlockReduction = 0
		vm:SetBodygroup(vm:FindBodygroupByName("field"), 1)
	end
end

function SWEP:CallWeaponBlock(ent)
	timer.Simple(0, function()
		if self:IsValid() and self:GetTumbler() then
			local vm = self:GetOwner():GetViewModel()
			self:SetOverHeat(10)
			local damage = self.MeleeDamage * 1.5
			local owner = self:GetOwner()
			local dmgmod = math.Clamp((self:GetOverHeat() - CurTime())/5, 0, 1)
			local burndamage = damage * 0.4 * dmgmod
			local burnticks = damage * 0.8 * dmgmod
			ent:TakeSpecialDamage(damage, DMG_CLUB, owner, self, ent:GetPos())
			ent:TakeSpecialDamage(burndamage, DMG_BURN, owner, self, ent:GetPos())
			ent:AddBurnDamage(burnticks, owner, owner.BurnTickRate or 1)
			self:SetTumbler(false)
			vm:SetBodygroup(vm:FindBodygroupByName("field"), 0)
			self.BlockReduction = 25
		end
	end)
end

function SWEP:AfterSwing()
	local vm = self:GetOwner():GetViewModel()
	if self:GetTumbler() then
		self:SetTumbler(false)
		vm:SetBodygroup(vm:FindBodygroupByName("field"), 0)
		self.ChargeSound:Stop()
		self.BlockReduction = 0
	end
end

function SWEP:PlaySwingSound()
	if self:GetTumbler() then
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_powered_miss"..math.random(2)..".ogg", 75, math.Rand(86, 90))
	else
		self:EmitSound("weapons/rmzs/fusion_breaker/hammer_miss"..math.random(2)..".wav", 75, math.Rand(86, 90))
	end
end

function SWEP:PlayHitSound()
	if self:GetTumbler() then
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_powered_hitworld"..math.random(5)..".ogg", 75, math.Rand(86, 90))
	else
		self:EmitSound("weapons/rmzs/fusion_breaker/hammer_hitworld"..math.random(5)..".wav", 75, math.Rand(86, 90))
	end
end

function SWEP:PlayHitFleshSound()
	--self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
	if self:GetTumbler() then
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_powered_hitflesh"..math.random(2)..".ogg", 75, math.Rand(86, 90))
	else
		self:EmitSound("weapons/rmzs/fusion_breaker/hammer_hitflesh"..math.random(2)..".wav", 75, math.Rand(86, 90))
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)

	if self:GetTumbler() then
		self:SetOverHeat(10)
	end
	
	local owner = self:GetOwner()
	local dmgmod = math.Clamp((self:GetOverHeat() - CurTime())/5, 0, 1)
	local burndamage = self.MeleeDamage * 0.2 * dmgmod
	local burnticks = self.MeleeDamage * 0.5 * dmgmod

	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then	
		if SERVER and dmgmod > 0 then
			hitent:TakeSpecialDamage(burndamage, DMG_BURN, self:GetOwner(), self, tr.HitPos)
			hitent:AddBurnDamage(burnticks, owner, owner.BurnTickRate or 1)
		end
	end

	if SERVER then
		if self:GetTumbler() and tr.Hit then
			local taper = 1
			for _, enc in pairs(util.BlastAlloc(self, owner, tr.HitPos, 74 * (owner.ExpDamageRadiusMul or 1))) do
				if enc:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", enc, owner) and enc != owner and enc != hitent then
					enc:TakeSpecialDamage((self.MeleeDamage / 1.8) * taper, DMG_CLUB, self:GetOwner(), self, tr.HitPos)
					enc:TakeSpecialDamage(burndamage * taper * 0.5, DMG_BURN, self:GetOwner(), self, tr.HitPos)
					enc:AddBurnDamage(burnticks * taper, owner, owner.BurnTickRate or 1)
					taper = taper * 0.9
				end
			end
		end
	end
end

function SWEP:SetOverHeat(heat)
	local toadd = self:GetDTFloat(19) <= CurTime() and CurTime() + heat or self:GetDTFloat(19) + heat
	self:SetDTFloat(19, toadd)
end

function SWEP:GetOverHeat()
	return self:GetDTFloat(19)
end

if CLIENT then
	matproxy.Add({

		name = "nickolp_fusionhammer_fusion",
		init = function( self, mat, values )
		end,
		bind = function( self, mat, ent )
			if !IsValid( ent ) or !IsValid(ent:GetOwner()) or ent:GetOwner() != LocalPlayer() or not ent.AbilityMax then return end
			local heat = ent:GetTumbler() and 8 or ent:GetResource()/ent.AbilityMax
			local hammheat = math.Clamp((ent:GetOverHeat() - CurTime())/5, 0, 1)
			
			mat:SetVector( "$emissiveblendtint", Vector( 0.25 * heat, 0.25 * heat, 0.25 * heat ) )
			mat:SetFloat( "$detailblendfactor", 0 + hammheat * 1 )
		end
		
	})

	matproxy.Add({
		name = "nickolp_fusionhammer_field",
		init = function( self, mat, values )
		end,
		bind = function( self, mat, ent )
			if !IsValid( ent ) or !IsValid(ent:GetOwner()) or ent:GetOwner() != LocalPlayer() or not ent.AbilityMax then return end
			local heat = ent:GetTumbler() and 1 or 0
			
			mat:SetVector( "$emissiveblendtint", Vector( 2 * heat, 2 * heat, 2 * heat ) )
		end
	})
end