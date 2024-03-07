AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_renegade"))
SWEP.Description = (translate.Get("desc_renegade"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "body"
	SWEP.HUD3DPos = Vector(1.3, 2, 0)
	SWEP.HUD3DAng = Angle(180, 0, -90)
	SWEP.HUD3DScale = 0.02
	
	function SWEP:DrawChargeBar()
	local screenscale = BetterScreenScale()
	local wid, hei = 2 * 100 * screenscale, 19 * screenscale
	local x, y = ScrW()/2 - wid/2, ScrH()/2 + hei + 70 * screenscale
	
	local col = (self:GetCrossCharge() >= 100) and Color(math.abs(math.sin(CurTime() * 3)) * 255,0,0) or Color(100, 100, 255)
	local val = self:GetCrossCharge()
	local maxi = 100
	local numba = val/25 - 1
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(x, y + hei * -0.32, wid, 20)

	surface.SetDrawColor(col)
	surface.DrawOutlinedRect(x, y + hei * -0.32, wid, 20)
	
	if numba >= 0 then
		for i = 0, numba do
			surface.DrawRect(x + 3 + i * ((wid - 6) - 3 * 3)/4 + i * 3, y + (hei * -0.32) + 3, (wid - 6 - 3 * 3) / 4, 20 - 6)
		end
	end
	
	local coltext = (self:GetCrossCharge() >= 100) and Color(255,255,255, math.abs(math.sin(CurTime() * 3)) * 255) or Color(100, 100, 255)
	draw.SimpleTextBlurry("Charge", "ZSHUDFontSmall", x + wid * 0.5, y - hei * 1, coltext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.WorldModel	= "models/weapons/renegade/w_renegade.mdl"
SWEP.ViewModel	= "models/weapons/renegade/c_renegade.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/renegade/fire1.wav"
SWEP.Primary.Damage = 127
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.25
SWEP.Pierces = 1
SWEP.DamageTaper = 1
	
SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 6
SWEP.ConeMin = 0
SWEP.HeadshotMulti = 2.45

SWEP.IronSightsPos = Vector(11, -9, -2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.ZoomSound = Sound("Default.Zoom")

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
SWEP.ResistanceBypass = 0.4

SWEP.FireAnimSpeed = 0.5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.25, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.BaseDamage = self.Primary.Damage
	self.NextAbilityShot = 0
	self.BaseTracer = self.TracerName
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)	
	self:SetIronsights(false)
	self:SetSights(0)
	return true
end

function SWEP:Reload()
	self.BaseClass.Reload(self)	
	self:SetSights(0)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		if self:GetSights() == 0 then
			if CLIENT then
				self.IronsightsMultiplier = 0.5
			end
			self:SetIronsights(true)
			self:SetSights(1)
			self:EmitSound(self.ZoomSound)
		elseif self:GetSights() == 1 then
			if CLIENT then
				self.IronsightsMultiplier = 0.25
			end
			self:SetSights(2)
			self:EmitSound(self.ZoomSound)
		else
			self:SetIronsights(false)
			self:SetSights(0)
			self:EmitSound(self.ZoomSound)
		end
	end
end

function SWEP:PrimaryAttack()
	self.Primary.Damage = self.BaseDamage + self.BaseDamage * math.floor(self:GetCrossCharge() * 0.1) * 0.05
	
	if self:GetIronsights() and self:GetCrossCharge() >= 25 then
		local piercemul = math.floor(self:GetCrossCharge()/25)
		self.Pierces = 2 * piercemul
		self.DamageTaper = piercemul * 0.25 - 0.3
		self.TracerName = "tracer_piercer"
	end
	
	self.BaseClass.PrimaryAttack(self)
	
	self:SetCrossCharge(0)
	self.Pierces = 1
	self.DamageTaper = 1
	self.Primary.Damage = self.BaseDamage
	self.TracerName = self.BaseTracer
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	local killer = self:GetOwner()

	if killer:IsValid() and zombie:WasHitInHead() then
		killer.RenegadeHeadshots = (killer.RenegadeHeadshots or 0) + 1

		if killer.RenegadeHeadshots >= 3 then
			local renegadestatus = killer:GiveStatus("renegade", 17)
			renegadestatus:SetStacks(math.min(renegadestatus:GetStacks() + 1, 1))
			killer.RenegadeHeadshots = 0
		end
		--[[local headpos = zombie:GetShootPos()
		local function FindHead(target)
			local classmdl, bloated, poison, skeletaltorso = (target and target:GetZombieClassTable().Model or nil), Model("models/player/fatty/fatty.mdl"), Model("models/Zombie/Poison.mdl"), Model("models/zombie/classic_torso.mdl")
			local bonenum = target and ((classmdl == poison and 14) or (classmdl == bloated and 12) or (classmdl == skeletaltorso and 7)) or 0
			
			return (target:GetBonePositionMatrixed(target:GetHitBoxBone(bonenum, 0)) - headpos):GetNormalized()
		end
		
		if self:GetIronsights() and self:GetCrossCharge() >= 25 and self.NextAbilityShot <= CurTime() then
			local numba = math.floor(self:GetCrossCharge()/25)
			self.NextAbilityShot = CurTime() + self.Primary.Delay
			timer.Simple(0.06, function()
				for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
					if ent and ent:IsValid() and ent:IsValidLivingZombie() and ent:GetShootPos():DistToSqr(headpos) < (1028 ^ 2) and WorldVisible(headpos, ent:GetShootPos()) and not SpawnProtection[ent] then
						if numba < 1 then break end
						local vectordir = FindHead(ent)
						local damage = self.Primary.Damage
						damage = damage * 0.05
						self:FireBulletsLua(headpos, vectordir, 0, 1, 1, 1, damage, killer, nil, nil, self.BulletCallback, nil, nil, 1028, nil, self)
						numba = numba - 1
					end
				end
				self:SetCrossCharge(0)
			end)
		end]]
	end
end

if CLIENT then
	--SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawFuturisticScope()
			self:DrawChargeBar()
		end
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD)
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Think()
	local stbl = E_GetTable(self)

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(stbl.IdleActivity)
	end
	
	if self:GetIronsights() and self:GetNextTimeLoad() <= CurTime() then
		self:SetCrossCharge(math.min(self:GetCrossCharge() + 25, 100))
		self:SetNextTimeLoad(CurTime() + 0.75)
	elseif not self:GetIronsights() then
		self:SetCrossCharge(0)
	end
	self:SmoothRecoil()
end
	
sound.Add(
{
	name = "renegade_fire",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/renegade/fire1.wav"}
})

sound.Add(
{
	name = "clipout",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/g3sg1/g3sg1_clipout.wav"}
})

sound.Add(
{
	name = "clipin",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/g3sg1/g3sg1_clipin.wav"}
})

sound.Add(
{
	name = "bolt",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/renegade/bolt.wav"}
})

sound.Add(
{
	name = "slam",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/renegade/slam.wav"}
})

function SWEP:SetCrossCharge(fag)
	self:SetDTFloat(15, fag)
end

function SWEP:GetCrossCharge()
	return self:GetDTFloat(15)
end

function SWEP:SetSights(a)
	self:SetDTInt(16, a)
end

function SWEP:GetSights()
	return self:GetDTInt(16)
end

function SWEP:SetNextTimeLoad(b)
	self:SetDTFloat(17, b)
end

function SWEP:GetNextTimeLoad()
	return self:GetDTFloat(17)
end