AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_blazecaust"))
SWEP.Description = (translate.Get("desc_blacecaust"))
 
if CLIENT then
	SWEP.ViewModelFOV = 55

	function SWEP:DrawAds()
	end

	SWEP.VElements = {
		["element_name++++"] = { type = "Model", model = "models/props_combine/portalball.mdl", bone = "Machete", rel = "", pos = Vector(9.8000001907349, 1, 0), angle = Angle(0, 3.5, 160), size = Vector(0.15000000596046, 0.0099999997764826, 0.0099999997764826), color = Color(255, 64, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name+++"] = { type = "Model", model = "models/props_combine/portalball.mdl", bone = "Machete", rel = "", pos = Vector(23.60000038147, -0.80000001192093, 0), angle = Angle(0, -83, 0), size = Vector(0.0099999997764826, 0.0099999997764826, 0.0099999997764826), color = Color(255, 64, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name"] = { type = "Model", model = "models/props_combine/portalball.mdl", bone = "Machete", rel = "", pos = Vector(13.800000190735, -0.5, 0), angle = Angle(0, -90, 0), size = Vector(0.041999999433756, 0.0099999997764826, 0.0099999997764826), color = Color(255, 64, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name+"] = { type = "Model", model = "models/props_combine/portalball.mdl", bone = "Machete", rel = "", pos = Vector(17, -0.5, 0), angle = Angle(0, -90, 0), size = Vector(0.041999999433756, 0.0099999997764826, 0.0099999997764826), color = Color(255, 64, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name++"] = { type = "Model", model = "models/props_combine/portalball.mdl", bone = "Machete", rel = "", pos = Vector(21.299999237061, -0.80000001192093, 0), angle = Angle(0, -83, 0), size = Vector(0.041999999433756, 0.0099999997764826, 0.0099999997764826), color = Color(255, 64, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/rmzs_customs/w_blazecaust.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8, 0.5, -9.5), angle = Angle(167, -110, -25), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	function SWEP:DrawConditions()
		local fulltime = self.Primary.Delay * self:GetOwner():GetMeleeSpeedMul()
		
		GAMEMODE:DrawCircleEx(x, y, 17, self:IsHeavy() and COLOR_YELLOW or COLOR_DARKRED, self:GetNextPrimaryFire() , fulltime)

		local screenscale = BetterScreenScale()
		local wid, hei = 180 * screenscale, 64 * screenscale
		local w, h = ScrW(), ScrH()
		local x, y = w - wid - screenscale * 128, h - hei - screenscale * 72
		local ammo = math.min(math.max(0, self:GetOwner():GetAmmoCount("chemical")), 999)

		local size = 42
		local ki = killicon.Get(GAMEMODE.AmmoIcons[self.Primary.Ammo])
		
		local kim = Material(tostring(ki[1]))
		surface.SetMaterial(kim)
		surface.SetDrawColor(ki[2])
		surface.DrawTexturedRect(x + wid * 0.5, y + hei * 0.75, size, size)

		draw.SimpleTextBlurry(ammo, "ZSHUDFont", x + wid, y + hei * 1.1, ammo > 3 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/rmzs_customs/c_blazecaust.mdl"
SWEP.WorldModel = "models/rmzs_customs/w_blazecaust.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.HoldType = "melee"
SWEP.HitDecal = "Manhackcut"

SWEP.Primary.Ammo = "chemical"

SWEP.MeleeDamage = 110
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 66
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 125

SWEP.Primary.Delay = 1

SWEP.SwingTime = 0.33
SWEP.SwingRotation = Angle(-3.0, 7.0, -50)
SWEP.SwingHoldType = "melee"

SWEP.SwingTimeSP = 1

SWEP.BlockRotation = Angle(-3.0, 7.0, -50)
SWEP.BlockOffset = Vector(3.5, 6, 6)

SWEP.CanBlocking = true
SWEP.BlockReduction = 11
SWEP.BlockStability = 0.25
SWEP.StaminaConsumption = 7

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_DRAW

SWEP.Tier = 3

SWEP.HasAbility = true
SWEP.ResourceMul = 0.75

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if self:GetTumbler() then
		self:SendWeaponAnim(ACT_VM_RELEASE)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	self:PlayStartSwingSound()

	local time = self:GetTumbler() and stbl.SwingTimeSP or stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time * condition)

	if not self:GetTumbler() then
		self:GetOwner():GetViewModel():SetPlaybackRate(1 - ((clamped) - 1))
	end
end

function SWEP:ProcessSpecialAttack()
	if self:GetResource() >= 0 then
		self:StopWind()
		self:SetTumbler(true)
		self:StartWinding()
		self:SetNextAttack()
		self:SetResource(0)
	end
end

function SWEP:AfterSwing()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local tr = owner:CompensatedMeleeTrace((stbl.MeleeRange + (owner.MeleeRangeAds or 0)) * (otbl.MeleeRangeMul or 1), stbl.MeleeSize)
	local hitent = tr.Entity
	local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH
	if self:GetTumbler() then
		self:SetTumbler(false)
	end

	if hitflesh then
		self:PlayHitFleshSound()
	else
		self:PlayHitSound()
	end
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if self:GetPrimaryAmmoCount() < 2 then return end

	if SERVER then
		local owner = self:GetOwner()
		local pos = tr.HitPos

		for _, hitent in pairs(util.BlastAlloc(self, owner, pos, 18)) do
			if hitent:IsValidLivingZombie() then
				timer.Simple(0, function()
					local status = hitent:GiveStatus("burn")
					if status and status:IsValid() then
						status:AddDamage((self.MeleeDamage * 0.33) * (owner.BurningDamage or 1), owner)
						status:AddTickRateMul(1.5)
						hitent:EmitSound("ambient/fire/ignite.wav", 68)
					end
				end)
			end
		end
		self:TakePrimaryAmmo(3)
	end
end