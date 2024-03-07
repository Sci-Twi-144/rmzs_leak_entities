AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Shade"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

if CLIENT then
	SWEP.ViewModelFOV = 70

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self:GetAbstractNumber(), col, "Next Shield", true)
	end
end


SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false

SWEP.ShadeControl = "env_cumshadecontrol"
SWEP.ShadeProjectile = "projectile_shadecum"
-- Shade:
SWEP.PropGrabDistance = 400
SWEP.PropThrowSpeed = 1000
SWEP.bFirstPersonThrow = true
SWEP.AICombatRange = 250

function SWEP:Initialize()
	self:HideWorldModel()
end

local bit_band = bit.band

function SWEP:TraceProp()
	local owner = self:GetOwner()
	local PLL = player.GetAll()
	local Start = owner:EyePos()
	local X = owner:EyeAngles():Forward()
	local Y = owner:EyeAngles():Right()
	local Z = owner:EyeAngles():Up()
	
	for pass=1,6 do
		local tr
		if pass==1 then
			tr = util.TraceLine( {start = Start, endpos = Start + X * self.PropGrabDistance, filter = PLL, mask = MASK_SOLID} )
		else
			-- Shotgun hull trace to attempt to find one prop.
			local End = Start + X * self.PropGrabDistance
			if pass==3 then
				End = End + Y * 35
			elseif pass==4 then
				End = End - Y * 35
			elseif pass==5 then
				End = End + Z * 35
			elseif pass==6 then
				End = End - Z * 35
			end
			tr = util.TraceHull( {start = Start, endpos = End, filter = PLL, mins=Vector( -10, -10, -10 ), maxs=Vector( 10, 10, 10 ), mask = MASK_SOLID} )
		end

		if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPhysicsProp() then
			local phys = tr.Entity:GetPhysicsObject()
			if (CLIENT or (IsValid(phys) and phys:IsMoveable())) and ((not GAMEMODE.CustomColEnabled) or bit_band(tr.Entity:GetCustomCollisionGroup(),ZS_COLLISIONGROUP_DYNAMICPROP)~=0) then
				return tr.Entity
			end
		end
	end
	return nil
end

function SWEP:Think()
end

if SERVER then
	function SWEP:BotAttackMode( enemy )
		return 0
	end

	function SWEP:BotAttack()
		if CurTime() <= self:GetNextSecondaryFire() then return end
		
		local owner = self:GetOwner()
		local target = rawget(BOT_Enemy, owner)
		
		-- Throw prop at enemy.
		if self.ShadeGrabControl and IsValid(self.ShadeGrabControl) then
			local obj = self.ShadeGrabControl:GetParent()
			if IsValid(obj) then
				local vel = owner:AdjustAim({start=obj:LocalToWorld(obj:OBBCenter()),speed=self.PropThrowSpeed,Toss=true,Splash=true})

				local phys = obj:GetPhysicsObject()
				if IsValid(phys) and phys:IsMoveable() then
					phys:Wake()
					phys:SetVelocity(vel * self.PropThrowSpeed)
					obj:SetPhysicsAttacker(self:GetOwner())
					phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
					obj.BOT_NextGrabTime = CurTime()

					obj:EmitSound(")weapons/physcannon/superphys_launch"..math.random(4)..".wav")
				end
				self:SetNextSecondaryFire(CurTime() + 0.65)

				self.ShadeGrabControl:Remove()
				return
			end
		end
		
		local BestProp = nil
		local BestDist = nil
		local StartPos = owner:EyePos()
		local filt = player.GetAll()
		if IsValid(target) then
			table.insert(filt, target)
		end
		local trinfo = {filter = filt}
		local targetpos = IsValid(target) and target:GetPlayerOrigin() or nil
		
		for _, ent in pairs(ents.FindInSphere(StartPos,self.PropGrabDistance)) do
			if ent:IsPhysicsProp() and (not ent.BOT_NextGrabTime or (CurTime()-ent.BOT_NextGrabTime)>1) then
				-- Filter out any worse results that there might be.
				local entpos = ent:GetPos()
				local Dist = entpos:DistToSqr(targetpos or StartPos)
				if BestProp and Dist>BestDist then continue end
				
				-- Quick verify prop throwability.
				local phys = ent:GetPhysicsObject()
				if not IsValid(phys) or not phys:IsMoveable() or phys:GetMass()>300 then continue end
				
				-- Check if has visible sight to ourselves.
				entpos = ent:LocalToWorld(ent:OBBCenter())
				table.insert(trinfo.filter, ent)
				trinfo.start = StartPos
				trinfo.endpos = entpos

				if util.TraceLine(trinfo).Hit then continue end
				
				if targetpos then
					-- Check if we have a clear sight from prop to enemy.
					trinfo.start = entpos
					trinfo.endpos = targetpos
					if util.TraceLine(trinfo).Hit then continue end
				end
				
				-- Make sure no other shade is controlling this prop.
				for _, ent2 in pairs(ents.FindByClass("env_shadecontrol")) do
					if IsValid(ent2) and ent2:GetParent() == ent then
						Dist = nil
						break
					end
				end
				
				if Dist then
					BestProp = ent
					BestDist = Dist
				end
			end
		end
		
		if BestProp then
			local con = ents.Create("env_shadecontrol")
			if IsValid(con) then
				con:Spawn()
				con:SetOwner(owner)
				con:AttachTo(BestProp)
				con.WeaponOwner = self
				con.MaximumDistance = self.PropGrabDistance+50

				BestProp:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")
				self.ShadeGrabControl = con
			end
		end
		self:SetNextSecondaryFire(CurTime() + 0.25)
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		if (self:GetOwner():IsBot() or self:GetOwner().IsPlayerAFK) then
			self:BotAttack()
		end
	end

	if not self:GetOwner():IsBot() then
		local owner = self:GetOwner()
		if CurTime() <= self:GetNextPrimaryFire() or (owner.ShadeShield and owner.ShadeShield:IsValid()) then return end

		for _, ent in pairs(ents.FindByClass(self.ShadeControl)) do
			if ent:IsValid() and ent:GetOwner() == owner then
				local obj = ent:GetParent()
				if obj:IsValid() then
					self:SetNextSecondaryFire(CurTime() + 0.65)

					owner:DoAttackEvent()

					if CLIENT then return end

					local vel = owner:GetAimVector() * 1000 * 25

					local phys = obj:GetPhysicsObject()
					if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 then
						phys:Wake()
						phys:SetVelocity(vel)
						obj:SetPhysicsAttacker(owner)
						phys:AddGameFlag(FVPHYSICS_WAS_THROWN)

						obj:EmitSound(")weapons/physcannon/superphys_launch"..math.random(4)..".wav")
						obj.LastShadeLaunch = CurTime()
					end
				end

				ent:Remove()
			end
		end
	end
end

function SWEP:CanGrab()
	local owner = self:GetOwner()
	if CurTime() <= self:GetNextSecondaryFire() or (owner.ShadeShield and owner.ShadeShield:IsValid()) then return end
	self:SetNextSecondaryFire(CurTime() + 0.1)

	if SERVER then
		for _, ent in pairs(ents.FindByClass(self.ShadeControl)) do
			if ent:IsValid() and ent:GetOwner() == owner then
				ent:Remove()
				return
			end
		end
	end

	return true
end

function SWEP:SecondaryAttack()
	if not self:CanGrab() then return end

	local owner = self:GetOwner()
	local ent = owner:CompensatedMeleeTrace(400, 4).Entity
	if ent:IsValid() and (ent:IsPhysicsModel() or ent.IsShadeGrabbable or ent.IsPhysbox) then
		self:SetNextPrimaryFire(CurTime() + 0.25)
		self:SetNextSecondaryFire(CurTime() + 0.4)

		if SERVER then
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= (300 * 25) then
				for _, ent2 in pairs(ents.FindByClass(self.ShadeControl)) do
					if ent2:IsValid() and ent2:GetParent() == ent then
						ent2:Remove()
						return
					end
				end

				for _, status in pairs(ents.FindByClass("status_human_holding")) do
					if status:IsValid() and status:GetObject() == ent then
						status:Remove()
					end
				end

				local con = ents.Create(self.ShadeControl)
				if con:IsValid() then
					con:Spawn()
					con:SetOwner(owner)
					con:AttachTo(ent)

					ent:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")
				end
			end
		end
	end
end

function SWEP:Reload()
	if not self:CanGrab() then return end

	local owner = self:GetOwner()

	local vStart = owner:GetShootPos()
	local vEnd = vStart + owner:GetForward() * 40

	local tr = util.TraceHull({start = vStart, endpos = vEnd, filter = owner, mins = owner:OBBMins() / 2, maxs = owner:OBBMaxs() / 2})
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1.3)

	if SERVER then
		local rock = ents.Create(self.ShadeProjectile)
		if rock:IsValid() then
			local pos = owner:GetPos() - owner:GetForward() * 5
			if not tr.Hit then
				pos = pos + owner:GetForward() * 30
			end
			--pos.z = pos.z + 100

			rock:SetPos(pos)
			rock:SetOwner(owner)
			rock:Spawn()
			local con = ents.Create(self.ShadeControl)
			if con:IsValid() then
				con:Spawn()
				con:SetOwner(owner)
				con:AttachTo(rock)
				rock.Control = con

				util.ScreenShake(owner:GetPos(), 3, 1, 0.75, 400)

				con:EmitSound("physics/concrete/concrete_break3.wav", 85, 60)
				rock:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")

				owner.LastRangedAttack = CurTime()
			end
		end
	end
end

function SWEP:OnRemove()
end

function SWEP:Holster()
end

if not CLIENT then return end

function SWEP:PreDrawViewModel(vm)
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:CallZombieFunction1("PreRenderEffects", vm)
	end
end

function SWEP:PostDrawViewModel(vm)
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:CallZombieFunction1("PostRenderEffects", vm)
	end
end
