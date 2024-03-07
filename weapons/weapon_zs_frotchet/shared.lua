SWEP.PrintName = "Frotchet"
SWEP.Description = (translate.Get("desc_frotchet"))

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/c_sledgehammer_redone.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 160
SWEP.MeleeRange = 75
SWEP.MeleeSize = 3
SWEP.MeleeKnockBack = 240

SWEP.MeleeDamageSecondaryMul = 1.2273
SWEP.MeleeKnockBackSecondaryMul = 1.25

SWEP.Primary.Delay = 1.4
SWEP.Secondary.Delay = SWEP.Primary.Delay * 1.75

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.SwingTime = 0.62
SWEP.SwingRotation = Angle(-3.0, 7.0, -25)
SWEP.SwingOffset = Vector(10, -7, 0)
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 0, 5)
SWEP.BlockOffset = Vector(-1, 0, -2)

SWEP.SwingTimeSecondary = 0.85

SWEP.Tier = 5
SWEP.MaxStock = 2
SWEP.BlockReduction = 19
SWEP.BlockStability = 0.5
SWEP.StaminaConsumption = 13
SWEP.CanBlocking = true
SWEP.AltBashAnim = ACT_VM_HITCENTER
SWEP.HitAnim = false
SWEP.MissAnim = false

SWEP.ResourceMul = 1
SWEP.HasAbility = true
SWEP.AbilityMax = 5000
SWEP.SpecAtribute = true

SWEP.InnateTrinket = "trinket_ice_attachement"
SWEP.ArmDamageMul = 2.5
SWEP.InnateArmDamage = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

SWEP.AllowQualityWeapons = true
SWEP.Spikes = {}
SWEP.TargetEntity = nil
SWEP.NextCast = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.14)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "nox/scatterfrost.ogg")
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextSecondaryFire() <= CurTime() and not self:IsSwinging()
end

function SWEP:StartSwinging(secondary)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(secondary and ACT_VM_SWINGHARD or ACT_VM_HITLEFT)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (secondary and self.SwingTimeSecondary or self.SwingTime) * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
	if secondary then self:SetCharge(CurTime()) end
end

function SWEP:SetNextAttack(secondary)
	if self:IsBlocking() then return end
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + (secondary and self.Primary.Delay + 0.23 or self.Primary.Delay) * armdelay)
	self:SetNextSecondaryFire(CurTime() + (secondary and self.Secondary.Delay or self.Primary.Delay) * armdelay)
end

function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()

	local swinging = self:IsSwinging()
	local charging = self:IsCharging()

	if charging then
		self.ChargeSound:PlayEx(1, math.min(255, 35 + (CurTime() - self:GetCharge()) * 220))
	else
		self.ChargeSound:Stop()
	end

	if not swinging and charging then
		self:SetCharge(0)
	end

	if SERVER then
		if #self.Spikes > 0 then
			if self.Spikes[1][2] <= CurTime() then
				self:CreateSpike(owner, self.Spikes[1][1])
				table.remove(self.Spikes, 1)
			end
		end
		
		if self.TargetEntity then
			if self.TargetEntity:IsValidLivingZombie() and self:GetResource() >= 500 then
				if self.NextCast <= CurTime() then
					self:CreateSpike(owner, self.TargetEntity:GetPos())
					self.NextCast = CurTime() + 0.3
				end
			else
				self.TargetEntity = nil
			end
		end
	end
end

function SWEP:CreateSpike(owner, pos)
	local ice = ents.Create("env_protrusionspike")
	if ice:IsValid() then
		ice:SetPos(pos)
		ice:SetOwner(owner)
		ice.Damage = self.MeleeDamage * 0.7
		ice.Team = owner:Team()
		ice.Special = true
		ice:Spawn()
		ice.Tier = self.Tier
	end
	self:SetResource(self:GetResource() - 500)
end

function SWEP:PlaySwingSound()
	self:EmitSound("nox/sword_miss.ogg", 75, math.random(40, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("nox/frotchet_test1.ogg", 75, math.random(95, 105))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 80, math.random(95, 105))
end

function SWEP:Reload()
	if self:GetFireMode() == 1 and not self:IsBlocking() then
		if not self:CanPrimaryAttack() or not self:CanSecondaryAttack() then return end
		self:SetNextAttack(true)
		self:StartSwinging(true)
	else
		self:ProcessShield()
	end
end

--[[function SWEP:LaunchDisk(velocity, pos, movable)
	if SERVER then
	self:SetTumbler(true)
	local ent = ents.Create("projectile_disc_cryo")
	if ent:IsValid() then
		local owner = self:GetOwner()
		local ongl = owner:GetAimVector():Angle()
		local angle = (movable and ongl) or Angle(0, 0, 0)
		ent:SetPos(pos)
		ent:SetAngles(angle)

		ent:SetOwner(owner)
		ent.Damage = self.MeleeDamage * 0.1 * (owner.ProjectileDamageMul or 1)
		ent.LifeSpan = 4.5
		ent.ProjSource = self
		ent.Homing = movable and true or false
		ent.Team = owner:Team()

		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			angle = owner:GetAimVector():Angle()
			if movable then
				phys:SetVelocityInstantaneous(angle:Forward() * velocity * (owner.ProjectileSpeedMul or 1))
			end
		end
	end
	end
end]]

function SWEP:ProcessShield()
	local owner = self:GetOwner()
	local lazymod = math.ceil(self.MeleeDamage / 160 * 100) * 0.01
	if self:GetResource() >= (self.AbilityMax * 0.2) then
		if self:GetOwner():KeyDown(IN_SPEED) then
		
			self:GiveArmor(owner, 50)
			self:SetResource(self:GetResource() - 500)
			
			local vPos, armorcount = self:GetOwner():GetPos(), math.floor(self:GetResource() / 500)
			
			for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
				if ent and ent:IsValidLivingPlayer() and WorldVisible(vPos, ent:NearestPoint(vPos)) and ent ~= self:GetOwner() then
					if ent:GetPos():DistToSqr(vPos) < (self.MeleeDamage ^ 2) then
						self:GiveArmor(ent, 50 * lazymod)
						self:SetResource(self:GetResource() - 500)
						armorcount = armorcount - 1
						if armorcount == 0 then break end
					end
				end
			end
		else
			local max_buffer = math.ceil(self:GetResource() / self.AbilityMax * 150 * lazymod)
			self:GiveArmor(owner, max_buffer)
			self:SetResource(0)
		end
	end
end

function SWEP:GiveArmor(ent, amount)
	if ent:GetStatus("frostarmor") then
		local armoralready = ent:GetStatus("frostarmor")
		armoralready.Applier = self:GetOwner()
		if SERVER then
			armoralready:UpdateMagnitude(self:GetOwner(), amount)
			armoralready.DieTime = armoralready.DieTime + 30
			armoralready:SetDuration(armoralready:GetDuration() + 30)
		end
	else
		local armor = ent:GiveStatus("frostarmor", 60)
		if armor and IsValid(armor)  then
			armor.Applier = self:GetOwner()
			armor:SetMagnitude(amount)
		end
	end
end

function SWEP:MissHitSpecial()
	--[[if self:IsCharging() and self:GetResource() >= self.AbilityMax then
		self:SetResource(0)
		self:LaunchDisk(150, self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector():GetNormalized() * 80, true)
	end]]
end
	
function SWEP:IsCharging()
	return self:GetCharge() > 0
end

function SWEP:SetCharge(charge)
	self:SetDTFloat(14, charge)
end

function SWEP:GetCharge()
	return self:GetDTFloat(14)
end
