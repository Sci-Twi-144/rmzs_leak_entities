SWEP.PrintName = (translate.Get("wep_minelayer"))
SWEP.Description = (translate.Get("desc_minelayer"))

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.FakeWorldModel = "models/props_lab/tpplug.mdl"
SWEP.FakeModelScale = 0.75

SWEP.ViewModelFOV = 60

SWEP.Primary.Sound = Sound("weapons/grenade_launcher1.wav")
SWEP.Primary.Delay = 1

SWEP.Primary.Damage = 15
SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 8

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"

SWEP.ConeMax = 0
SWEP.ConeMin = 0
SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.UseHands = true

SWEP.MaxMines = 3
SWEP.Minelayer = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAXIMUM_MINES, 1)

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(4)
end

function SWEP:CanPrimaryAttack()
	if self.BaseClass.CanPrimaryAttack(self) then
		local c = 0
		for _, ent in pairs(ents.FindByClass("projectile_lasermine")) do
			if (CLIENT or ent.CreateTime + 300 > CurTime()) and ent:GetOwner() == self:GetOwner() then
				c = c + 1
			end
		end

		if c >= self.MaxMines then return false end

		return true
	end

	return false
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	local hitpos = owner:CompensatedMeleeTrace(2048, 1, nil, nil, false).HitPos

	if SERVER then
		for _, ent in pairs(util.BlastAlloc(self, owner, hitpos, 24)) do
			if ent:GetClass() == "projectile_lasermine" and ent:GetOwner() == owner and ent:GetSelfTime() >= 90 and not ent.Exploded then
				if ent.CreateTime + 30 > CurTime() then
					local mine = ents.Create("prop_ammo")
					if mine:IsValid() then
						mine:SetAmmo(4)
						mine:SetAmmoType("impactmine")
						mine:SetPos(ent:GetStartPos())
						mine:SetAngles(ent:GetAngles())
						mine:Spawn()
						mine:SetOwner(self:GetOwner())
					end
	
					if owner:IsValidLivingHuman() then
						mine.NoPickupsTime = CurTime() + 15
						mine.NoPickupsOwner = owner
						mine.IsTrueOwner = self:GetOwner()
					end
	
					ent.Exploded = true
	
					ent:Remove()
				else
					local mine = ents.Create("prop_fakeweapon")
					if mine:IsValid() then
						mine:SetOwner(owner)
						mine:SetWeaponType(self:GetClass())
						mine:SetPos(ent:GetStartPos())
						mine:SetAngles(ent:GetAngles())
						mine:Spawn()
					end
					owner:GiveAmmo(4,"impactmine")
					net.Start("zs_ammopickup")
						net.WriteUInt(4, 16)
						net.WriteString("impactmine")
					net.Send(owner)
	
					ent.Exploded = true
	
					ent:Remove()
				end
			end
		end
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 60, math.random(137, 143), 0.5)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound(self.ReloadSound, 60, 110, 0.5, CHAN_WEAPON + 21)
	end
end