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

SWEP.Primary.Damage = 26 -- ОНО ДОЛЖНО ОТОБРАЖАТЬ МИНИМАЛЬНЫЙ УРОН!!!
SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 7

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.WalkSpeed = SPEED_SLOWEST * 0.9

SWEP.UseHands = true

SWEP.MaxMines = 6
SWEP.Minelayer = true
-- БЛЯДЬ, ДЛЯ ЧЕГО ГИТ СОЗДАН, ПОЧЕМУ НЕТ ОПИСАНИЯ ИЗМЕНЕНИЙ.
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAXIMUM_MINES, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_sparkler")), (translate.Get("desc_sparkler")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.12
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
			ent.Branch = true
			ent.Range = 64
		end
	end
end)

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
end

function SWEP:CanPrimaryAttack()
	if self.BaseClass.CanPrimaryAttack(self) then
		local c = 0
		for _, ent in pairs(ents.FindByClass("projectile_impactmine")) do
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

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	local altuse = self:GetAltUsage()
	if not altuse then
		self:TakeAmmo()
	end
	self:SetAltUsage(not altuse)

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	local hitpos = owner:CompensatedMeleeTrace(2048, 1, nil, nil, false).HitPos

	if SERVER then
		local minetabl = {}
		for _, ent in pairs(util.BlastAlloc(self, owner, hitpos, 24)) do
			if ent:GetClass() == "projectile_impactmine" and ent:GetOwner() == owner and not ent.Exploded then
				if ent.CreateTime + 30 > CurTime() then
					minetabl[#minetabl + 1] = ent
				else
					local mine = ents.Create("prop_fakeweapon")
					if mine:IsValid() then
						mine:SetOwner(owner)
						mine:SetWeaponType(self:GetClass())
						mine:SetPos(ent:GetStartPos())
						mine:SetAngles(ent:GetAngles())
						mine:Spawn()
					end
					owner:GiveAmmo(1,"impactmine")
					net.Start("zs_ammopickup")
						net.WriteUInt(1, 16)
						net.WriteString("impactmine")
					net.Send(owner)
	
					ent.Exploded = true
	
					ent:Remove()
				end
			end
		end

		if #minetabl > 1 then
			local mine = ents.Create("prop_ammo")
			local lastent = minetabl[#minetabl]
			if mine:IsValid() then
				mine:SetAmmo(math.floor(#minetabl / 2))
				mine:SetAmmoType("impactmine")
				mine:SetPos(lastent:GetStartPos())
				mine:SetAngles(lastent:GetAngles())
				mine:Spawn()
				mine:SetOwner(self:GetOwner())
			end

			if owner:IsValidLivingHuman() then
				mine.NoPickupsTime = CurTime() + 15
				mine.NoPickupsOwner = owner
				mine.IsTrueOwner = self:GetOwner()
			end
		end

		if #minetabl > 0 then
			for _, ent2 in pairs(minetabl) do
				ent2.Exploded = true
				ent2:Remove()
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