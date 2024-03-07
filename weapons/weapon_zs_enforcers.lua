AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")
SWEP.PrintName = (translate.Get("wep_enforsers"))
SWEP.Description = (translate.Get("desc_enforsers"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "RW_Weapon"
	SWEP.HUD3DPos = Vector(4, -1.4, 4)
	SWEP.HUD3DAng = Angle(0, -105, 90)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(0, 4, -1)
	SWEP.VMAng = Vector(0, 0, 0)
	
	SWEP.VElements = {}
	SWEP.ViewModelBoneMods = {
		["LW_Weapon"] = { scale = Vector(1, 1, 1), pos = Vector(0.5, 0.4, 0.4), angle = Angle(0, -4, 0) }
		--["LeftForeArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.3, 0, 0), angle = Angle(0, 0, 0) }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/enforcer/c_enforcer_v2.mdl"
SWEP.WorldModel = "models/weapons/enforcer/w_enforcer_v2.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/elite/elite-1.wav"
SWEP.Primary.Damage = 77 --96 --Too op... this have extra buff.. its increase dmg.
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.30

SWEP.Primary.ClipSize = 24
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1.35

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.ReloadSpeed = 1.1

SWEP.MainAttack = true
SWEP.SecondAttack = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_v1")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, nil, nil, "weapon_zs_ragingwolf")

function SWEP:GetCone()
	return self.BaseClass.GetCone(self) * (self.MainAttack and 1 or 6)
end

function SWEP:GetFireDelay()
	return self.BaseClass.GetFireDelay(self) / (self.MainAttack and 1 or 2)
end

function SWEP:CanSecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
	return BaseClass.CanPrimaryAttack(self)
end

function SWEP:PrimaryAttack()
	self.SecondAttack = false
	self.MainAttack = true
	return BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay())
	self.SecondAttack = true
	self.MainAttack = false
	return BaseClass.PrimaryAttack(self)
end

function SWEP:OnZombieKilled(zombie)
	local killer = self:GetOwner()
	if killer:IsValid() and zombie:WasHitInHead() and self.MainAttack then
		killer.RenegadeHeadshots = (killer.RenegadeHeadshots or 0) + 1

		if killer.RenegadeHeadshots >= 1 then
			killer:GiveStatus("renegade", 9)
			killer.RenegadeHeadshots = 0
		end
	--end
	elseif killer:IsValid() and self.SecondAttack then
		local reaperstatus = killer:GiveStatus("reaper", 9)
		if reaperstatus and reaperstatus:IsValid() then
			reaperstatus:SetStacks(math.min(reaperstatus:GetStacks() + 1, 3))
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
		end
	end
end

function SWEP:EmitReloadSound() -- yes so many timers
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/elite/elite_leftclipin.wav", 75, 75, 1, CHAN_WEAPON + 21)
		timer.Create("reload_left", 0.75 / reloadspeed, 1, function ()
			self:EmitSound("weapons/elite/elite_sliderelease.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_right", 1.5 / reloadspeed, 1, function ()
			self:EmitSound("weapons/elite/elite_rightclipin.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_click", 2.25 / reloadspeed, 1, function ()
			self:EmitSound("weapons/elite/elite_sliderelease.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_end", 2.65 / reloadspeed, 1, function ()
			self:EmitSound("items/battery_pickup.wav", 70, 57, 0.1, CHAN_WEAPON + 22)
		end)
	end
end

function SWEP:RemoveAllTimers()
	timer.Remove("reload_left")
	timer.Remove("reload_right")
	timer.Remove("reload_click")
	timer.Remove("reload_end")
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/elite/elite_deploy.wav", 75, 75, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/deagle/deagle-1.wav", 75, math.random(81, 85), 0.8)
	self:EmitSound("weapons/awp/awp1.wav", 75, math.random(142, 148), 0.7, CHAN_WEAPON + 20)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity

	if SERVER and ent and ent:IsValidLivingZombie() then
		dmginfo:SetDamageForce(attacker:GetUp() * 7000 + attacker:GetForward() * 25000)
	end
end

if not CLIENT then return end

function SWEP:GetTracerOrigin()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local vm = owner:GetViewModel()
		if vm and vm:IsValid() then
			local attachment = vm:GetAttachment(self:Clip1() % 2 + 3)
			if attachment then
				return attachment.Pos
			end
		end
	end
end

local ghostlerp = 0
function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.5)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 0.4)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -28 * ghostlerp)
	end

	if self.VMAng and self.VMPos then
		ang:RotateAroundAxis(ang:Right(), self.VMAng.x) 
		ang:RotateAroundAxis(ang:Up(), self.VMAng.y)
		ang:RotateAroundAxis(ang:Forward(), self.VMAng.z)

		pos:Add(ang:Right() * (self.VMPos.x))
		pos:Add(ang:Forward() * (self.VMPos.y))
		pos:Add(ang:Up() * (self.VMPos.z))
	end
	
	return pos, ang
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end

	if self.HUD3DPos or self.HUD3DPos_L and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end
end

function SWEP:Draw3DHUD(vm, pos, ang)
	self.BaseClass.Draw3DHUD(self, vm, pos, ang)

	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5

	cam.Start3D2D(pos, ang, self.HUD3DScale)
		local owner = self:GetOwner()
		local reaper = owner:GetStatus("reaper")
		local headshot = owner:GetStatus("renegade")
		if reaper then
			local text = ""
			for i = 0, reaper:GetDTInt(1)-1 do
				text = text .. "+"
			end
			draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if headshot then
			draw.SimpleText("C", "zsdeathnoticecs", x + wid/2, y + hei * 0.10, Color(math.abs(math.sin(CurTime()*8)) * 255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end