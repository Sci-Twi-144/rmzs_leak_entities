AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_ravager"))
SWEP.Description = (translate.Get("desc_executioner"))

local function ResetHands(self)
	if CLIENT then
		self.VMAng = Angle(0, 0, 0)
		self.VMPos = Vector(0, 0, 0)
	end
end

if CLIENT then
	local colBG = Color(194, 18, 18)
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, colBG, "Cyclone", false, true)
		local screenscale = BetterScreenScale()
	end

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["element_name4"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 1.294), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.163), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name8+++"] = { type = "Model", model = "models/props_docks/dock03_pole01a_256.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 49.936), angle = Angle(0, 5.843, 0), size = Vector(0.144, 0.15, 0.09), color = Color(80, 80, 80, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.699, 2, -32.701), angle = Angle(3.224, 0, -0.838), size = Vector(0.07, 0.07, 0.587), color = Color(90, 90, 90, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} },
		["element_name3++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 21.527), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_name1+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 8.59), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.893), color = Color(190, 100, 50, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["element_name3+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 19.295), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_namexx"] = { type = "Model", model = "models/mechanics/wheels/wheel_rounded_36.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 8.894), angle = Angle(0, -40.91, 0), size = Vector(0.059, 0.059, 0.18), color = Color(200, 200, 200, 255), surpresslightning = false, material = "environment maps/pipemetal001a", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/hunter/misc/cone1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0.039, 0, 1.327), angle = Angle(0, 0, -180), size = Vector(0.05, 0.048, 0.27), color = Color(90, 90, 90, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name3+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 14.949), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_name6"] = { type = "Model", model = "models/xqm/panel45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-3.753, 0.144, 4.823), angle = Angle(0, -90, -22.427), size = Vector(0.097, 0.554, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_namex"] = { type = "Model", model = "models/xqm/CoasterTrack/turn_90_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(12.256, 0.014, 10.314), angle = Angle(138.156, 0, 90), size = Vector(0.079, 0.079, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name6+"] = { type = "Model", model = "models/xqm/panel45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.708, 0.144, 4.823), angle = Angle(0, 90, -22.427), size = Vector(0.097, 0.554, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name3++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 12.569), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 17.063), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_namex+"] = { type = "Model", model = "models/xqm/CoasterTrack/turn_90_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-10.924, 0.231, -0.121), angle = Angle(-43.741, 0, 90), size = Vector(0.079, 0.079, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["element_name4"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 1.294), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.163), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name8+++"] = { type = "Model", model = "models/props_docks/dock03_pole01a_256.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 49.936), angle = Angle(0, 5.843, 0), size = Vector(0.144, 0.15, 0.09), color = Color(80, 80, 80, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.826, 1.353, -37.389), angle = Angle(2.706, 0, 0), size = Vector(0.07, 0.07, 0.587), color = Color(90, 90, 90, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} },
		["element_name3++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 21.527), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_name1+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 8.59), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.893), color = Color(190, 100, 50, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["element_name3+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 19.295), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_namexx"] = { type = "Model", model = "models/mechanics/wheels/wheel_rounded_36.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, 0, 8.894), angle = Angle(0, -40.91, 0), size = Vector(0.059, 0.059, 0.18), color = Color(200, 200, 200, 255), surpresslightning = false, material = "environment maps/pipemetal001a", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/hunter/misc/cone1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0.039, 0, 1.327), angle = Angle(0, 0, -180), size = Vector(0.05, 0.048, 0.27), color = Color(90, 90, 90, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name3+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 14.949), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_namex"] = { type = "Model", model = "models/xqm/CoasterTrack/turn_90_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(10.017, 0.094, 10.314), angle = Angle(138.156, 0, 90), size = Vector(0.079, 0.079, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name6"] = { type = "Model", model = "models/xqm/panel45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-3.753, 0.144, 4.823), angle = Angle(0, -90, -22.427), size = Vector(0.097, 0.554, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name6+"] = { type = "Model", model = "models/xqm/panel45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.708, 0.144, 4.823), angle = Angle(0, 90, -22.427), size = Vector(0.097, 0.554, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} },
		["element_name3++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 12.569), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(0, -1.224, 17.063), angle = Angle(0, 0, 90), size = Vector(0.029, 0.029, 0.054), color = Color(120, 120, 120, 255), surpresslightning = false, material = "metal5", skin = 0, bodygroup = {} },
		["element_namex+"] = { type = "Model", model = "models/xqm/CoasterTrack/turn_90_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-10.575, 0.252, -1.328), angle = Angle(-43.741, 0, 90), size = Vector(0.079, 0.079, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal2", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	local uBarrelOrigin = Vector(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
	local SAng = Angle(0, 0, 0)

	local wmod = Vector(0, 0, 0)
	local wang = SWEP.WElements[ "element_name1" ].angle
	local wpos = SWEP.WElements[ "element_name1" ].pos
	SWEP.IsShooting = 0
	if CLIENT then
		function SWEP:Think()
			self.BaseClass.Think(self)
			if self:GetCyclonTime() >= CurTime() then
				self.SpinSpeed = 3.5
				self:DoSpin()
				self.UseHands = false 
			else
				self.UseHands = true
			end
		end	
	end
	
	SWEP.VMAng = Angle(0, 0, 0)
	SWEP.VMPos = Vector(0, 0, 0)
	-- [[]
	-- function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
		-- if self:GetCyclonTime() >= CurTime() then
			-- ang:RotateAroundAxis(ang:Right(), self.VMAng.x) 
			-- ang:RotateAroundAxis(ang:Up(), self.VMAng.y)
			-- ang:RotateAroundAxis(ang:Forward(), self.VMAng.z)
			
			-- pos:Add(ang:Right() * (self.VMPos.x))
			-- pos:Add(ang:Forward() * (self.VMPos.y))
			-- pos:Add(ang:Up() * (self.VMPos.z))
		-- end
		-- return pos, ang
	-- end
	-- end]]

	
	local meta = FindMetaTable("Entity")
	local E_GetTable = meta.GetTable

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()
		local owner_valid = IsValid(owner)
	
		if not owner_valid then return end
	
		if FrameNumber() - (LastDrawFrame[owner] or 0) > 30 then return end
		if E_GetTable(owner).ShadowMan or SpawnProtection[owner] then return end
		if GAMEMODE.NoDrawHumanWeaponsAsZombie and MySelf and MySelf:Team() == TEAM_UNDEAD and owner:Team() == TEAM_HUMAN then return end
		if MySelf and owner ~= MySelf and owner:GetPos():DistToSqr(EyePos()) > (GAMEMODE.SCKWorldRadius or 250000) then return end
	
		render.MaterialOverrideByIndex(0, Material("models/hands/hands_color"))
		if self:GetCyclonTime() >= CurTime() then
			self:EffectBloodWorld()
		end
		if self:GetCyclonTime() >= CurTime() then
			
			self.WElements[ "element_name1" ].angle = LerpAngle( RealFrameTime() * 24, self.WElements[ "element_name1" ].angle, Angle(0, -90, 90) )
			self.WElements[ "element_name1" ].pos = LerpVector( RealFrameTime() * 24, self.WElements[ "element_name1" ].pos, Vector(55, 0, 0) )
		else
			self.UseHands = true
			self.WElements[ "element_name1" ].angle = LerpAngle( RealFrameTime() * 24, self.WElements[ "element_name1" ].angle, wang )
			self.WElements[ "element_name1" ].pos = LerpVector( RealFrameTime() * 24, self.WElements[ "element_name1" ].pos, wpos)
		end
		self:Anim_DrawWorldModel()
	end

	function SWEP:DoSpin()
		self.SpinAng = self.SpinAng or 0
		self.SpinSpeed = self.SpinSpeed or 10
			
		if self.SpinAng > 7200 then
			self.SpinAng = -7200
		end
		
		self.SpinAng = self.SpinAng - self.SpinSpeed
	
		if self.SpinSpeed > 0 then
			self.SpinSpeed = self.SpinSpeed * 0.99
		elseif self.SpinSpeed < 0 then
			self.SpinSpeed = 0
		end
		self.VMAng = Angle(-5, self.SpinAng * (FrameTime() * 24), -90)
		self.VMPos = Vector(-10, -3, 12)

		if self:GetCyclonTime() <= CurTime() then
			ResetHands(self)
		end
	end


	function SWEP:GetWorldMuzzlePos( pl )
		if pl:IsValid() then
			local bn = pl:LookupBone("ValveBiped.Anim_Attachment_RH")
			if bn then
				local m = pl:GetBoneMatrix(bn)
				if m then
					return m:GetTranslation() + m:GetForward()*1 - m:GetRight()*5 + m:GetUp()*67
				end
			end
		end

		return pl:GetPos()
	end
	
	function SWEP:GetMuzzlePos(weapon)
		if not IsValid(weapon) then return end
		if GAMEMODE.OverTheShoulder then return end
		local origin = weapon:GetPos()
		local angle = weapon:GetAngles()

		if weapon:IsWeapon() and weapon:IsCarriedByLocalPlayer() then
			if IsValid(weapon:GetOwner()) and GetViewEntity() == weapon:GetOwner() then
				local viewmodel = weapon:GetOwner():GetViewModel()
				if IsValid(viewmodel) then
					weapon = viewmodel
				end
			end
		end
		local bn = weapon:LookupBone("ValveBiped.Bip01_R_Hand")
		if bn then
			local m = weapon:GetBoneMatrix(bn)
			if m then
				return m:GetTranslation() + m:GetForward()*-1 - m:GetRight()*5 + m:GetUp()*-55
			end
		end
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 330
SWEP.MeleeRange = 86
SWEP.MeleeSize = 2.75
SWEP.MeleeKnockBack = 360

SWEP.Primary.Delay = 1.35

SWEP.WalkSpeed = SPEED_SLOWEST * 0.9

SWEP.SwingTime = 0.7
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.25
SWEP.BlockReduction = 22
SWEP.StaminaConsumption = 16

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.13)

SWEP.HasAbility = true 
SWEP.AbilityMax = 2500

SWEP.BloodBonus = 0

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:CanPrimaryAttack()
	if self:GetCyclonTime() >= CurTime() then return false end
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

function SWEP:ProcessSpecialAttack()
	if self:GetResource() >= self.AbilityMax then
		self:SetCyclonTime(CurTime() + 5)
		self:SetResource(0)
		self:SetHoldType("revolver")
		self.HasAbility = false
		self.CanBlocking = false
		--self.BlockBloodArmor = true
		self:SetBlocking(false)
		timer.Create("resetholdtype", 5, 1, function()
			self:SetHoldType("melee2")
			self.HasAbility = true
			self.CanBlocking = true 
			--self.BlockBloodArmor = false
		end)
	end
end


local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
SWEP.NextVisThink = 0
function SWEP:ThinkExt()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	if owner:IsBarricadeGhosting() then self:SetCyclonTime(0) self:SetHoldType("melee2") end
	if self:GetCyclonTime() >= CurTime() then

		self:EffectBloodView()

		if self.NextVisThink <= CurTime() then
			self.NextVisThink = CurTime() + 0.55

			local range = (stbl.MeleeRange + (otbl.MeleeRangeAds or 0)) * (otbl.MeleeRangeMul or 1)
			local damagemultiplier = otbl.MeleeDamageMultiplier or 1
			local damage = (stbl.MeleeDamage + (otbl.MeleeDamageAds or 0)) * damagemultiplier
	
			if self:ShouldPlayHitSound() then
				self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
				self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 75)
				self:SetPlayHitSound(false)
			end

			if SERVER then
				owner:RawCapLegDamage(CurTime() + 2)
				
				local pos = owner:GetPos()
				local range = range - 25
				for _, hitent in pairs(util.BlastAlloc(self, owner, pos, range)) do
					if hitent:IsValidLivingZombie() and WorldVisible(pos, hitent:NearestPoint(pos))  then
						self:PlayHitFleshSound()
						self:SetPlayHitSound(true)
						local nearest = hitent:NearestPoint(pos)
							
						damage = damage * 0.75
						hitent:TakeSpecialDamage((((range ^ 2) - nearest:DistToSqr(pos)) / (range ^ 2)) * damage, DMG_SLASH, owner, self)
					end
				end
			end
		end
	end
end

SWEP.NextEmit = 0
function SWEP:EffectBloodView()
	if GAMEMODE.OverTheShoulder then return end
	if CurTime() < self.NextEmit then return end
	
	self.NextEmit = CurTime() + 0.01
	if CLIENT then
		if not IsValid(emitter) then
			emitter = ParticleEmitter(self:GetPos())
		end

		emitter:SetPos(self:GetPos())
		local particle = emitter:Add( "noxctf/sprite_bloodspray"..math.random(8),self:GetMuzzlePos( self) or Vector(0,0,0))
		local speed = self:GetOwner():GetVelocity()
		local size = math.Rand(4, 12)
		particle:SetVelocity(speed)
		particle:SetDieTime(math.Rand(0.4, 0.6))
		particle:SetColor(255, 0, 0)
		particle:SetStartAlpha(255)
		particle:SetStartSize(size)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,125))
		particle:SetCollide(true)
		particle:SetAirResistance(12)
	end
end

function SWEP:EffectBloodWorld()
	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.01
	if CLIENT then
		if not IsValid(emitter) then
			emitter = ParticleEmitter(self:GetPos())
		end
		emitter:SetPos(self:GetPos())
		local particle = emitter:Add( "noxctf/sprite_bloodspray"..math.random(8),self:GetWorldMuzzlePos( self:GetOwner(), 1 ))
		local speed = self:GetOwner():GetVelocity()
		local size = math.Rand(4, 12)
		particle:SetVelocity(speed)
		particle:SetDieTime(math.Rand(0.4, 0.6))
		particle:SetColor(255, 0, 0)
		particle:SetStartAlpha(255)
		particle:SetStartSize(size)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetGravity(Vector(0,0,125))
		particle:SetCollide(true)
		particle:SetAirResistance(12)
	end
end

SWEP.SpinAng = 0
SWEP.Matrix = Matrix()
function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	local enty = self
	local ENTC = tostring(enty)

	if CLIENT then
		local yrot = Angle(0,-180*9,0)

		hook.Add("PrePlayerDraw", ENTC, function(pl)
			if pl ~= self:GetOwner() then return end

			if self:GetCyclonTime() >= CurTime() then

				local mat = self.Matrix
				mat:Rotate(yrot * FrameTime() * 0.4)

				pl:EnableMatrix("RenderMultiply", mat)

			end

		end)
		hook.Add("PostPlayerDraw", ENTC,  function(pl)
			if pl ~= self:GetOwner() then return end
			if self:GetCyclonTime() <= CurTime() then
			local mat = self.Matrix
			mat:Rotate(Angle(0,0,0))
			pl:DisableMatrix("RenderMultiply")
			end
		end)
	end

end

function SWEP:OnRemove()
	local ENTC = tostring(self)
	if CLIENT then
		hook.Remove("PrePlayerDraw", ENTC)
		hook.Remove("PostPlayerDraw", ENTC)
	end
	self.UseHands = true
	self.HasAbility = true
	self.CanBlocking = true 
	self:SetHoldType("melee2")
	timer.Remove("resetholdtype")

	self.BaseClass.OnRemove(self)
end

function SWEP:Holster()
	self:SetCyclonTime(0)
	self.HasAbility = true
	self.UseHands = true
	self.CanBlocking = true 
	self:SetHoldType("melee2")
	timer.Remove("resetholdtype")
	ResetHands(self)
	
	return self.BaseClass.Holster(self)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:SetCyclonTime(time)
	self:SetDTFloat(19, time)
end

function SWEP:GetCyclonTime()
	return self:GetDTFloat(19)
end

function SWEP:SetPlayHitSound(bool)
	self:SetDTBool(12, bool)
end

function SWEP:ShouldPlayHitSound()
	return self:GetDTBool(12)
end