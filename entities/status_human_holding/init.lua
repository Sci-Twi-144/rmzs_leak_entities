--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	hook.Add("Move", tostring(self), function(pl, mv)
		if not IsValid(self) then return end

		if pl ~= self:GetOwner() then return end

		local object = self:GetObject()
		if object:IsValid() then
			--local objectphys = object:GetPhysicsObject()
			--if objectphys:IsValid() then
				mv:SetMaxSpeed(math.max(
					mv:GetMaxSpeed() / 4,
					mv:GetMaxSpeed() - self:GetObjectMass() * CARRY_SPEEDLOSS_PERKG * (pl.PropCarrySlowMul or 1))
				)
				mv:SetMaxClientSpeed(mv:GetMaxSpeed())
			--end
		end
	end)

	self:DrawShadow(false)

	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() then
		owner.status_human_holding = self

		owner:DrawWorldModel(false)

		local info = GAMEMODE:GetHandsModel(owner)
		if info then
			self:SetModel(info.model)
			self:SetSkin(info.skin)
			self:SetBodyGroups(info.body)
		end

		local wep = owner:GetActiveWeapon()
		if wep:IsValid() then
			wep:SendWeaponAnim(ACT_VM_HOLSTER)
			if wep.SetIronsights then
				wep:SetIronsights(false)
			end
		end
	else
		self:SetModel("models/weapons/c_arms_citizen.mdl")
	end

	local object = self:GetObject()
	if object:IsValid() then
		object.IgnoreMeleeTeam = TEAM_HUMAN
		object.IgnoreTraces = true
		object.IgnoreBullets = true

		for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
			if ent.EntityToWatch == object:GetName() and ent:IsValid() then
				ent:Input("onpickedup", owner, object, "")
			end
		end

		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)

			self:SetObjectMass(objectphys:GetMass())

			object.PreHoldAlpha = object.PreHoldAlpha or object:GetAlpha()
			object.PreHoldRenderMode = object.PreHoldRenderMode or object:GetRenderMode()

			objectphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
			object._OriginalMass = objectphys:GetMass()

			objectphys:EnableGravity(false)
			objectphys:SetMass(GAMEMODE:CalcHoldingMass())

			object:SetOwner(owner)
			object:SetCollisionGroupState(false)
			object:SetRenderMode(RENDERMODE_TRANSALPHA)
			object:SetAlpha(180)

			local children = object:GetChildren()
			for _, child in pairs(children) do
				if not child:IsValid() then continue end

				if child:IsPhysicsModel() then -- Stops child sprites from getting fucked up rendering
					child.PreHoldAlpha = child.PreHoldAlpha or child:GetAlpha()
					child.PreHoldRenderMode = child.PreHoldRenderMode or child:GetRenderMode()

					child:SetAlpha(180)
					child:SetRenderMode(RENDERMODE_TRANSALPHA)
				end

				child:SetCollisionGroupState(false)
				child:SetCustomCollisionCheck(true)
				child:CollisionRulesChanged()
			end

			object:SetCustomCollisionCheck(true)
			object:CollisionRulesChanged()
		end
	end
end

local function DoubleCheck(object)
	if not IsValid(object) then return end

	for _, status in pairs(ents.FindByClass("status_human_holding")) do
		if status:IsValid() and not status.Removing and status:GetObject() == object then
			return
		end
	end

	object.IgnoreMeleeTeam = nil
	object.IgnoreTraces = nil
	object.IgnoreBullets = nil
end

function ENT:OnRemove()
	if self.Removing then return end
	self.Removing = true

	hook.Remove("Move", tostring(self))

	local owner = self:GetOwner()
	if owner:IsValid() then
		--owner.status_human_holding = nil

		owner:DrawWorldModel(true)

		if owner:Alive() and owner:Team() == TEAM_HUMAN then
			local wep = owner:GetActiveWeapon()
			if wep:IsValid() then
				if wep.IsAkimbo then
					wep:SendViewModelAnim(wep.DeployAnimIndex , 0)
					wep:SendViewModelAnim(wep.DeployAnimIndex_S , 1)
				else
					wep:SendWeaponAnim(ACT_VM_DRAW)
				end
			end
		end
	end

	local object = self:GetObject()
	if object:IsValid() then
		object.IgnoreMelee = nil
		object.IgnoreTraces = nil
		object.IgnoreBullets = nil

		timer.Simple(0.1, function() DoubleCheck(object) end)

		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:ClearGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			objectphys:EnableGravity(true)
			if object._OriginalMass then
				objectphys:SetMass(object._OriginalMass)
				object._OriginalMass = nil
			end

			object:SetOwner(NULL)
			object:CollisionRulesChanged()
			if not self:GetIsHeavy() then
				object:SetCollisionGroupState(true)
				object:SetCustomCollisionCheck(false)
				object:CollisionRulesChanged()
				object:GhostAllPlayersInMe(4, true)

				object:SetAlpha(object.PreHoldAlpha or 255)
				object:SetRenderMode(object.PreHoldRenderMode or RENDERMODE_NORMAL)

				local children = object:GetChildren()
				for _, child in pairs(children) do
					if not child:IsValid() then continue end

					if child:IsPhysicsModel() then
						child:SetAlpha(child.PreHoldAlpha or 255)
						child:SetRenderMode(child.PreHoldRenderMode or RENDERMODE_NORMAL)
					end

					child:SetCollisionGroupState(true)
					child:SetCustomCollisionCheck(false)
					child:CollisionRulesChanged()
				end
			end
		end

		object._LastDroppedBy = owner
		object._LastDropped = CurTime()

		for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
			if ent.EntityToWatch == object:GetName() and ent:IsValid() then
				ent:Input("ondropped", owner, object, "")
			end
		end
	end
end

local ShadowParams = {secondstoarrive = 0.01, maxangular = 1000, maxangulardamp = 10000, maxspeed = 500, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 0}
function ENT:Think()
	local ct = CurTime()

	local frametime = ct - (self.LastThink or ct)
	self.LastThink = ct

	local object = self:GetObject()
	local owner = self:GetOwner()
	if not object:IsValid() or object:IsNailed() or not owner:IsValid() or not owner:Alive() or owner:Team() ~= TEAM_HUMAN then
		self:Remove()
		return
	end

	local shootpos = owner:GetShootPos()
	local nearestpoint = object:NearestPoint(shootpos)

	local objectphys = object:GetPhysicsObject()
	if object:GetMoveType() ~= MOVETYPE_VPHYSICS or not objectphys:IsValid() or owner:GetGroundEntity() == object then
		self:Remove()
		return
	end

	if self:GetIsHeavy() then
		if self:GetHingePos():DistToSqr(self:GetPullPos()) >= 4096 then
			self:Remove()
			return
		end
	elseif nearestpoint:DistToSqr(shootpos) >= 4096 then
		self:Remove()
		return
	end

	objectphys:Wake()

	--if owner:KeyPressed(IN_ATTACK) then
		--object:SetPhysicsAttacker(owner)

		--self:Remove()
		--return
	if self:GetIsHeavy() then
		local pullpos = self:GetPullPos()
		local hingepos = self:GetHingePos()
		objectphys:ApplyForceOffset(objectphys:GetMass() * frametime * 450 * (pullpos - hingepos):GetNormalized(), hingepos)
	elseif owner:KeyDown(IN_ATTACK2) and not owner:GetActiveWeapon().NoPropThrowing then
		owner:ConCommand("-attack2")
		objectphys:ApplyForceCenter(objectphys:GetMass() * math.Clamp(1.25 - math.min(1, (object:OBBMins():Length() + object:OBBMaxs():Length()) / CARRY_DRAG_VOLUME), 0.25, 1) * 500 * owner:GetAimVector() * (owner.ObjectThrowStrengthMul or 1))
		object:SetPhysicsAttacker(owner)

		self:Remove()
		return
	else
		if not self.ObjectPosition or not owner:KeyDown(IN_SPEED) then
			local obbcenter = object:OBBCenter()
			local objectpos = shootpos + owner:GetAimVector() * 48
			objectpos = objectpos - obbcenter.z * object:GetUp()
			objectpos = objectpos + obbcenter.y * object:GetRight()
			objectpos = objectpos - obbcenter.x * object:GetForward()
			self.ObjectPosition = objectpos
			if not self.ObjectAngles then
				self.ObjectAngles = object:GetAngles()
			end
		end

		local snap = tonumber(owner:GetInfo("zs_proprotationsnap")) or 0
		if snap > 0 and owner:KeyDown(IN_ATTACK) then
			if not self.WasSpeeding then
				self.WasSpeeding = true
				self.ObjectAngles = object:GetAngles()
			end

			if owner:KeyDown(IN_WALK) then
				self.SnapAngles = Angle(self.ObjectAngles)
				self.SnapAngles:SnapTo( "p", snap ):SnapTo( "y", snap ):SnapTo( "r", snap )
			end
		elseif self.WasSpeeding then
			self.WasSpeeding = nil
			if self.SnapAngles then
				self.ObjectAngles = self.SnapAngles
				self.SnapAngles = nil
			end
		end

		ShadowParams.pos = self.ObjectPosition
		ShadowParams.angle = self.SnapAngles or self.ObjectAngles
		ShadowParams.deltatime = frametime
		objectphys:ComputeShadowControl(ShadowParams)
	end

	object:SetPhysicsAttacker(owner)
	object.LastHeld = CurTime()

	self:NextThink(ct)
	return true
end

local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable

hook.Add("SetupMove", "human_holding.SetupMove", function( ply, mv, cmd )
	local ptbl = E_GetTable(ply)
	local h = ptbl.status_human_holding
	if h then
		local htbl = E_GetTable(h)
		if htbl and htbl.ObjectAngles and mv:KeyDown(IN_WALK) then
			local speed = tonumber(ply:GetInfo("zs_proprotationsens")) or 1

			local v = cmd:GetMouseX() * speed * 0.08
			if v ~= 0 then
				htbl.ObjectAngles:RotateAroundAxis(ply:EyeAngles():Up(), v)
			end

			v = cmd:GetMouseY() * speed * 0.08
			if v ~= 0 then
				htbl.ObjectAngles:RotateAroundAxis(ply:EyeAngles():Right(), v)
			end
		end
	end
end)
