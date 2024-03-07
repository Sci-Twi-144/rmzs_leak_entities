AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_uzi"))
SWEP.Description = (translate.Get("desc_uzi"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.VMPos = Vector(-3, -8, 0)
	SWEP.VMAng = Vector(0, -3, -5.5)

	SWEP.HUD3DBone = "v_weapon.mac10_bolt"
	SWEP.HUD3DPos = Vector(-1.45, 1.25, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {}
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.MoveHandUp = 0
	SWEP.MoveHandDown = 0
	SWEP.ReloadTimerAnim = 0
	SWEP.ReadyHandLeftDown = 0

	function SWEP:SendReloadAnimation()
		self:SendWeaponAnim(ACT_VM_RELOAD)
		self.ReloadTimerAnim = CurTime() + self:SequenceDuration() / (1.15 * self:GetReloadSpeedMultiplier())
	end

	local function RestartValueDeploy(self)
		self.MoveHandUp = 0
		self.MoveHandDown = 0
		self.ReadyHandLeftDown = 0
		self.ReloadTimerAnim = 0
	end

	function SWEP:Deploy()
		self.BaseClass.Deploy(self)

		RestartValueDeploy(self)

		return true
	end

	local function HandDropDown(self)
		local owner = self:GetOwner()
		if self.ReadyHandLeftDown <= CurTime() then
			if self.ReloadTimerAnim <= CurTime() and not owner:Crouching() and owner:IsOnGround() and not owner:IsHolding() then
				self.MoveHandDown = math.max(-10, self.MoveHandDown - 0.2)
				self.MoveHandUp = math.min(5, self.MoveHandUp + 0.2)
			else
				self.MoveHandDown = math.min(0, self.MoveHandDown + 0.4)
				self.MoveHandUp = math.max(0, self.MoveHandUp - 0.4)
			end
		end

		self.ViewModelBoneMods["ValveBiped.Bip01_L_Clavicle"].pos = Vector(self.MoveHandDown, 0, self.MoveHandUp)
	end

	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)

		HandDropDown(self)
	end

	function SWEP:DrawHUD()
		self.BaseClass.DrawHUD(self)

		HandDropDown(self)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/mac10/mac10-1.wav"
SWEP.Primary.Damage = 17.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.075

SWEP.Primary.ClipSize = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 5.5
SWEP.ConeMin = 2.5

SWEP.FireAnimSpeed = 1.5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ResistanceBypass = 0.9

SWEP.Tier = 2

SWEP.IronSightsPos = Vector(-4, 3, 0)
SWEP.IronSightsAng = Vector(1, -1, -10)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.58, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.27, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_disperser")), (translate.Get("desc_disperser")), function(wept)
	wept.Primary.ClipSize = math.floor(wept.Primary.ClipSize * 0.58)
	wept.Primary.Delay = 0.06
	-- wept.CannotHaveExtendetMag = true

	wept.ResistanceBypass = 0.925

	local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
		attacker.RicochetBullet = true
		local wep = attacker:GetActiveWeapon()
		if attacker:IsValid() and wep:IsValid() then
			FORCE_B_EFFECT = true
			attacker:FireBulletsLua(hitpos, 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 0, 1, 1, 1, damage, nil, nil, "tracer_rico", nil, nil, nil, nil, nil, wep)
			FORCE_B_EFFECT = nil
		end
		attacker.RicochetBullet = nil
	end
	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER and tr.HitWorld and not tr.HitSky and attacker:GetActiveWeapon():Clip1() < 10 then
			local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.5
			timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
		end
	end

	wept.FinishReload = function(self)
		local reloads = self:GetReloadStacks()
		if reloads >= 1 then
			self:SetReloadStacks(self:GetReloadStacks() - 1)
		end
		self.BaseClass.FinishReload(self)
	end
		
	wept.Reload = function(self)
		local reloads = self:GetReloadStacks()
			if reloads <= 0 then
				--self:SetClip1(self:GetPrimaryClipSize() - self:GetHitStacks())
				self.Primary.ClipSize = self.ClipSizeOrig
				self:SetHitStacks(0)
				self:SetReloadStacks(10)
			end
		self.BaseClass.Reload(self)
	end
		
	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
		local killer = self:GetOwner()
		self:SetHitStacks(math.min(self:GetHitStacks() + 1, 30))
		self.Primary.ClipSize = (self.ClipSizeOrig + self:GetHitStacks())
		killer:EmitSound("hl1/ambience/particle_suck1.wav", 100, 150 + self:GetHitStacks() * 10, 0.45)
	end
		
	wept.Initialize = function(self)
		self:SetReloadStacks(self:GetReloadStacks() + 6)
		self.ClipSizeOrig = self.Primary.ClipSize
		self.BaseClass.Initialize(self)	
	end	
		
	wept.SetHitStacks = function(self, stacks)
		self:SetDTInt(9, stacks)
	end
	
	wept.GetHitStacks = function(self)
		return self:GetDTInt(9)
	end
	
	wept.SetReloadStacks = function(self, reloads)
		self:SetDTInt(8, reloads)
	end
	
	wept.GetReloadStacks = function(self)
		return self:GetDTInt(8)
	end
	
	wept.Deploy = function(self)
		self.BaseClass.Deploy(self)
		self.Primary.ClipSize = self.ClipSizeOrig
		self:SetHitStacks(0)
		self:SetReloadStacks(10)
		GAMEMODE:SetupDefaultClip(self.Primary)
		return true
	end
		
	if CLIENT then
		
		local colBG = Color(16, 16, 16, 150)
		local colBlue = Color(30, 178, 123, 255)
		local colWhite = Color(220, 220, 220, 230)
		local colRed = Color(255, 0, 0, 230)
		
		wept.Draw3DHUD = function(self, vm, pos, ang)
			local wid, hei = 180, 64
			local x, y = wid * -0.6, hei * -0.5
			local spare = self:Clip1()
			local spare2 = self:GetPrimaryAmmoCount() - self:Clip1()
			local spare3 = self:GetHitStacks()
			local spare4 = self:GetReloadStacks()
			local spare5 = self.Firstclip
	
			cam.Start3D2D(pos, ang, wept.HUD3DScale / 2)
				draw.RoundedBoxEx(32, x, y, wid, hei * 2.1, colBG, true, false, true, false)
				draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(spare2, spare2 >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 1.5, spare2 == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(spare3, spare3 >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y - hei * 1.5, spare3 == 0 and colRed or colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(spare4, spare4 >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y - hei * 0.7, spare4 == 0 and colBlue or colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry("Kills:", "ZS3D2DFontSmall", x + wid * -0.5, y - hei * 1.5, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry("Reloads:", "ZS3D2DFontSmall", x + wid * -0.5, y - hei * 0.7, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

end).NewNames = {"Disperser +1", "Disperser +2", "Disperser +3"}
--[[
sound.Add(
{
	name = "Weapon_Gale.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {120, 125},
	sound = "weapons/p90/p90-1.wav"
})
]]
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_galestorm")), (translate.Get("desc_galestorm")), function(wept)
	wept.Primary.ClipSize = wept.Primary.ClipSize * 1.15
	wept.Primary.Delay = 0.15

	wept.Primary.Damage = wept.Primary.Damage * 0.65
	wept.Primary.NumShots = 2

	wept.ConeMax = 6.3
	wept.ConeMin = 3.5

	wept.ReloadSpeed = 0.95

	wept.ResistanceBypass = 1

	--wept.Primary.Sound = Sound("Weapon_Gale.Single")
	
	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/p90/p90-1.wav", 100, math.random(120, 125), 1.0, CHAN_WEAPON)
	end
	
	if CLIENT then
		wept.VElements = {
			["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top", pos = Vector(0, -1.201, -0.602), angle = Angle(180, 0, 0), size = Vector(0.057, 0.611, 0.068), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.064, -3.751, -0.304), angle = Angle(180, -90, 0), size = Vector(0.177, 0.079, 0.342), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.178, -5.091, -1.982), angle = Angle(180, 0, 90), size = Vector(0.021, 0.009, 0.009), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.906, 0.238, 3.084), angle = Angle(0, 90, 90), size = Vector(0.057, 0.611, 0.068), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.876, 1.121, -3.771), angle = Angle(-91.623, -4.99, 0), size = Vector(0.177, 0.101, 0.418), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.287, 0.241, 2.313), angle = Angle(0, -90, 90), size = Vector(0.021, 0.009, 0.009), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
		}
		wept.HUD3DPos = Vector(-1.45, 1.25, 0)
	end

	wept.PrimaryAttack = function(self)
	if not self:CanPrimaryAttack() then return end
	local ironsights = self:GetIronsights()

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (ironsights and 1.2 or 1))

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage * (ironsights and 0.7255 or 1), self.Primary.NumShots * (ironsights and 1.5 or 1), self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	
	wept.SecondaryAttack = function(self)
		if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
			self:SetIronsights(true)
		end
	end
	
	wept.SetIronsights = function(self, b)
	if self:GetIronsights() ~= b then
		if b then
			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
	end
	
	wept.CanPrimaryAttack = function(self)
	if self:GetIronsights() and self:Clip1() == 1 then
		self:SetIronsights(false)
	end

	return self.BaseClass.CanPrimaryAttack(self)
	end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Gale Storm +1", "Gale Storm +2", "Gale Storm +3"}
branch.Killicon = "weapon_zs_galestorm"

local branch_2 = GAMEMODE:AddNewRemantleBranch(SWEP, 3, (translate.Get("wep_whirlwind")), (translate.Get("desc_whirlwind")), function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 3.2
	wept.Primary.Damage = wept.Primary.Damage * 1.28
	wept.Primary.Ammo = "ar2"
	wept.Primary.ClipSize = 16
	wept.Recoil = 1
	
	wept.ResistanceBypass = 0.4

	wept.ConeMin = wept.ConeMin * 0.4
	wept.ConeMax = wept.ConeMax * 0.35
	
	wept.ReloadSpeed = 0.95

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/p90/p90-1.wav", 70, 105, 0.65, CHAN_AUTO)
		self:EmitSound("weapons/sg552/sg552-1.wav", 70, 235, 0.65, CHAN_AUTO)
	end
	
	if CLIENT then
		wept.VElements = {
			["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top", pos = Vector(0, -1.201, -0.602), angle = Angle(180, 0, 0), size = Vector(0.057, 0.611, 0.068), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.064, -3.751, -0.304), angle = Angle(180, -90, 0), size = Vector(0.177, 0.079, 0.342), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.178, -5.091, -1.982), angle = Angle(180, 0, 90), size = Vector(0.021, 0.009, 0.009), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.906, 0.238, 3.084), angle = Angle(0, 90, 90), size = Vector(0.057, 0.611, 0.068), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.876, 1.121, -3.771), angle = Angle(-91.623, -4.99, 0), size = Vector(0.177, 0.101, 0.418), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.287, 0.241, 2.313), angle = Angle(0, -90, 90), size = Vector(0.021, 0.009, 0.009), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
		}
		wept.HUD3DPos = Vector(-1.45, 1.25, 0)
	end
end)
branch_2.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch_2.NewNames = {"Whirlwind +2", "Whirlwind +2", "Whirlwind +3"}
branch_2.Killicon = "weapon_zs_galestorm"