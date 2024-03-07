AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_devastator"))
SWEP.Description = (translate.Get("desc_devastator"))

if CLIENT then
	SWEP.ViewModelFOV = 73
	SWEP.ShowViewModel = true 
	SWEP.ShowWorldModel = false
	SWEP.TrailPositions = {}
	SWEP.AfterModels = {}

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/evilsword/evilsword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, 0.5, 0.5), angle = Angle(-9, 75, 18), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["evilsw"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		
	}

	local uBarrelOrigin = Vector(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
	local SAng = Angle(0, 0, 0)

	local wmod = Vector(0, 0, 0)
	local wang = SWEP.WElements[ "weapon" ].angle
	SWEP.IsShooting = 0
	
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Mass Swung", false, true)
		local screenscale = BetterScreenScale()
		local wid, hei = 2 * 220 * screenscale, 19 * screenscale
		local x, y = ScrW() - wid - 32 * screenscale, ScrH() - hei - 70 * screenscale
		
		local function getNumba()
			if self:GetBuffDur() >= CurTime() then
				return self:GetMultiplier() * 5
			else
				return 0
			end
		end
		local col = (self:GetBuffDur() >= CurTime()) and Color(math.abs(math.sin(CurTime() * 3)) * 255,0,0) or color_white
		local val = (self:GetBuffDur() >= CurTime()) and (self:GetBuffDur() - CurTime()) or 0
		local maxi = 10
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * -0.32, wid, 20)

		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(x, y + hei * -0.32, wid, 20)
		surface.DrawRect(x + 3, y + (hei * -0.32) + 3, (wid - 6) * math.Clamp(val / maxi, 0, 1), 20 - 6)
		local coltext = (self:GetBuffDur() >= CurTime()) and Color(255,255,255, math.abs(math.sin(CurTime() * 3)) *255) or color_white
		draw.SimpleTextBlurry("Current Bonus: + " .. getNumba() .. " %", "ZSHUDFontSmall", x + wid * 0.5, y - hei * 1, coltext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end
	
	function SWEP:DrawRing(pos, pl)
		local matBeam = Material("Effects/laser1", "smooth")
		local up = pl:GetUp()
		local ang = pl:GetForward():Angle()
		ang.yaw = CurTime() * 64 % 64
		local ringpos = pos + up * 2
				
		local radius = 150

		render.SetMaterial(matBeam)
		render.StartBeam(19)
		for i=1, 19 do
			render.AddBeam(ringpos + ang:Forward() * radius, 6, 32, COLOR_RED)
			ang:RotateAroundAxis(up, 20)
		end
		render.EndBeam()
	end
	local trailmat = Material("Effects/laser1", "smooth")
	
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.ViewModel = "models/evilsword/c_evilsword.mdl"
SWEP.WorldModel = "models/evilsword/evilsword.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 265
SWEP.MeleeRange = 82
SWEP.MeleeSize = 2.5

SWEP.Primary.Delay = 1.25

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.SwingTime = 0.65
SWEP.SwingRotation = Angle(0, -15, -15)
SWEP.SwingHoldType = "melee2"

SWEP.BlockRotation = Angle(0, 0, 25)
SWEP.BlockOffset = Vector(9, 0, 0)

SWEP.CanBlocking = true 
SWEP.BlockReduction = 22
SWEP.BlockStability = 0.25
SWEP.StaminaConsumption = 12

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_RECOIL1

SWEP.HasAbility = true
SWEP.AbilityMax = 4000
SWEP.ResourceMul = 1
SWEP.Devastator = true

SWEP.WalkSpeed = SPEED_SLOWEST * 0.95

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.125)


local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

SWEP.Matrix = Matrix()
function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	--self.DevastatorOwner = self:GetOwner()
	
	local enty = self
	local ENTC = tostring(enty)
	timer.Simple(0.06, function()-- а вы знаете что в инициализаторе нет овнера на первом тике?
		self.DevastatorOwner = self:GetOwner()
		if CLIENT then
			hook.Add("PrePlayerDraw", ENTC, function(pl)
				--if pl ~= self:GetOwner() then return end
				--if not self:GetOwner():GetActiveWeapon().Devastator then return end

				if self.Devastator and pl == self.DevastatorOwner and self:GetTumbler() then

					local mat = self.Matrix
					mat:SetTranslation(self:GetCurrentNegga() + self:GetRandVector())
					local hapuga = (self:GetCurrentNegga() - mat:GetTranslation())
					mat:SetAngles(hapuga:Angle())
					
					pl:EnableMatrix("RenderMultiply", mat)
				end

			end)
			hook.Add("PostPlayerDraw", ENTC,  function(pl)
				--if pl ~= self:GetOwner() then return end
				--if not self:GetOwner():GetActiveWeapon().Devastator then return end
				if self.Devastator and pl == self.DevastatorOwner then
					if self:GetTumbler() then
					else
						local mat = self.Matrix
						pl:DisableMatrix("RenderMultiply")
					end
				end
			end)
			
			hook.Add("ShouldDrawLocalPlayer", ENTC,  function(pl)
				--if pl ~= self:GetOwner() then return end
				--if not self:GetOwner():GetActiveWeapon().Devastator then return end
				
				if self.Devastator and pl == self.DevastatorOwner and pl:KeyDown(IN_SPEED) then
					local pos = pl:GetPos()
					local eye = pl:GetAimVector()
					local calculateangle = eye:Angle().x >= 91 and 90 or (90 - eye:Angle().x)
					local calculatepos = pos + Vector(eye.x, eye.y, 0) * (calculateangle/90 * 300)
					self:DrawRing(calculatepos, pl)
				end
				
				if self.Devastator and pl == self.DevastatorOwner and self:GetTumbler() then
					if self:GetTumbler() then
						return true
					else
						return false
					end
				end
			end)
		end
	end)
	self:SaveDefaults()
end

function SWEP:RemoveShit(hookname)
	if hookname == "PrPD" then
		hook.Remove("PrePlayerDraw", tostring(self))
	elseif hookname == "PPD" then
		hook.Remove("PostPlayerDraw", tostring(self))
	else
		hook.Remove("ShouldDrawLocalPlayer", tostring(self))
	end
end

function SWEP:OnRemove()
	local ENTC = tostring(self)
	local owner = self:GetOwner()
	if CLIENT then
		if self.Devastator then
			--owner:DisableMatrix("RenderMultiply")
		end
		hook.Remove("PrePlayerDraw", ENTC)
		hook.Remove("PostPlayerDraw", ENTC)
		hook.Remove("ShouldDrawLocalPlayer", ENTC)
	end
	self.BaseClass.OnRemove(self)
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
		
	if self:GetTumbler() then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time * condition)

	if not self:GetTumbler() then
		self:GetOwner():GetViewModel():SetPlaybackRate(1 - ((clamped) - 1))
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetBuffDur() <= CurTime() then self:ResetDefaults() end
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or (self:GetOwner():GetStamina() == 0) then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetResource() < self.AbilityMax then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()

	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:SaveDefaults()
	self.OrigMD = self.MeleeDamage
	self.OrigSC = self.StaminaConsumption
	self.OrigRM = self.ResourceMul
end

function SWEP:ChangeRate(num)
	local owner = self:GetOwner()
	local iter = 5
	for i = 0, iter do
		owner:SetLayerPlaybackRate(i, num)
	end
end

function SWEP:ProcessSpecialAttack()
	if self:GetResource() >= self.AbilityMax then
		if self:GetBuffDur() <= CurTime() then self:ResetDefaults() end
		local owner = self:GetOwner()
		self:SetTumbler(true)
		--self:ChangeRate(10)
		if SERVER then
			owner:GodEnable()
			owner:Freeze(true)
		end

		local vPos
		
		if owner:KeyDown(IN_SPEED) then
			local pos = owner:GetPos()
			local eye = owner:GetAimVector()
			local calculateangle = eye:Angle().x >= 91 and 90 or (90 - eye:Angle().x)
			vPos = pos + Vector(eye.x, eye.y, 0) * (calculateangle/90 * 300)
		else
			vPos = owner:GetShootPos()
		end
		
		local counter = 0
		
		for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
			if ent and ent:IsValidLivingPlayer() then --and WorldVisible(vPos, ent:GetShootPos()) then
				if ent:GetPos():DistToSqr(vPos) < (150 ^ 2) then
					if counter > 12 then break end
					timer.Simple(counter * 0.15, function()
						local what, nani = WorldToLocal(ent:WorldSpaceCenter(), ent:GetAngles(), owner:WorldSpaceCenter(), owner:GetAngles())
						self:SetCurrentNegga(what)
						self:SetRandVector(Vector(math.random(-30, 30), math.random(-30, 30), 0))
						
						owner:DoAttackEvent()
						
						ent:TakeSpecialDamage(self.MeleeDamage, DMG_SLASH, self:GetOwner(), self, nil)
						ent:EmitSound("physics/metal/sawblade_stick3.wav", 100, 150)
						self:SetBuffDur(CurTime() + 10)
						self:SetMultiplier(math.min(self:GetMultiplier() + 1, 20))
						self:ProcessBuff()
						local effectdata = EffectData()
							effectdata:SetEntity(ent)
							effectdata:SetOrigin(ent:GetPos())
						util.Effect("gib_player", effectdata, true, true)
					end)
					counter = counter + 1
				end
			end
		end
		self:SetResource(0)
		timer.Simple(counter * 0.15, function()
			if SERVER then
				owner:GodDisable()
				owner:Freeze(false)
			end
			if IsValid(self) then
				self:SetTumbler(false)
				--self:ChangeRate(1)
			end
			--local ENTC = tostring(self)
			--hook.Remove("UpdateAnimation", ENTC)
		end)
	end
end

-- zaebala eta parasha
--[[function SWEP:UpdateSpeed()
	local ENTC = tostring(self)
	hook.Add("UpdateAnimation", ENTC,  function(pl, velocity, maxseqgroundspeed)
		if pl ~= self:GetOwner() then return end
		pl:SetPlaybackRate(5)
		return false
	end)
end]]

function SWEP:ProcessBuff()
	if self:GetMultiplier() >= 1 then
		local num = self:GetMultiplier()
		self.ResourceMul = self.OrigRM / (self.OrigRM + (num * 0.05 * 0.4))
		self.MeleeDamage = self.OrigMD + self.OrigMD * (num * 0.05)
		self.StaminaConsumption = math.floor(self.OrigSC / (math.min(num, 3))) -- min stamina consumption = 4
	end
end

function SWEP:ResetDefaults()
	self:SetMultiplier(0)
	self.ResourceMul = self.OrigRM
	self.MeleeDamage = self.OrigMD
	self.StaminaConsumption = self.OrigSC
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
	--[[local owner = self:GetOwner()
	if hitent:IsValid() and hitent:IsPlayer() then
		if SERVER then
			self:SetResource(math.min(self:GetResource() + owner:GetBloodArmor() * (owner.AbilityCharge or 1), self.AbilityMax), false)

			if self:GetResource() < self.AbilityMax then
				owner:SetBloodArmor(0)
			end
		end
	end]]
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 85))
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 75)
end

function SWEP:SetMultiplier(charge)
	self:SetDTFloat(14, charge)
end

function SWEP:GetMultiplier()
	return self:GetDTFloat(14)
end

function SWEP:SetCurrentNegga(suka)
	self:SetDTVector(19, suka)
end

function SWEP:GetCurrentNegga()
	return self:GetDTVector(19)
end

function SWEP:SetRandVector(bebra)
	self:SetDTVector(20, bebra)
end

function SWEP:GetRandVector()
	return self:GetDTVector(20)
end

function SWEP:SetBuffDur(timer)
	self:SetDTFloat(21, timer)
end

function SWEP:GetBuffDur()
	return self:GetDTFloat(21)
end