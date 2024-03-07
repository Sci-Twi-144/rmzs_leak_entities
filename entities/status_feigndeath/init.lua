--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NextHeal = 0

function ENT:OnInitialize()
	local ent = self
	local ENTC = tostring(ent)

	self.DroppedNest = nil
	self.NextNest = CurTime() + 3

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() then return end
	
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
	end)
end

function ENT:PlayerSet(pPlayer, bExists)
	FeignDeath[pPlayer] = self
	pPlayer:SetCollisionGroup(COLLISION_GROUP_WORLD)
	pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

	if pPlayer:KeyDown(IN_BACK) then
		self:SetDirection(DIR_BACK)
	elseif pPlayer:KeyDown(IN_MOVERIGHT) then
		self:SetDirection(DIR_RIGHT)
	elseif pPlayer:KeyDown(IN_MOVELEFT) then
		self:SetDirection(DIR_LEFT)
	else
		self:SetDirection(DIR_FORWARD)
	end
end

ENT.NextMessage = 0

function ENT:SendMessage(msg, friendly)
	if CurTime() >= self.NextMessage then
		self.NextMessage = CurTime() + 2
		self:GetOwner():CenterNotify(friendly and COLOR_GREEN or COLOR_RED, translate.ClientGet(self:GetOwner(), msg))
	end
end

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()

	if owner:IsValid() then

		if self:GetStateEndTime() <= fCurTime and self:GetState() == 1 or not owner:Alive() or owner:Team() ~= TEAM_UNDEAD or not owner:GetZombieClassTable().CanFeignDeath then
			self:Remove()
			return
		end

		if fCurTime >= self.NextHeal then
			self.NextHeal = fCurTime + 0.25

			-- genius
			--[[local status = owner:GetStatus("nestbuff")
			if owner:IsValid() and status then
				status:Remove()
			end]]

			if owner:Health() < owner:GetMaxHealth() and not owner:GetZombieClassTable().Boss then
				self.NextNest = fCurTime + 3
				owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + math.min(owner:GetMaxHealth() * 0.035, 3)))
			end
		end
	end

	self:NextThink(fCurTime)
	return true
end

function ENT:BuildNest()
	local ent = self.DroppedNest

	ent:BuildUp()

	ent.LastBuild = CurTime()
	ent.LastBuilder = self:GetOwner()

	if not ent:GetNestBuilt() and ent:GetNestHealth() == ent:GetNestMaxHealth() then
		ent:SetNestBuilt(true)
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")

		local name = self:GetOwner():Name()
		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			pl:CenterNotify(COLOR_GREEN, translate.ClientFormat(pl, "nest_built_by_x", name))
		end

		net.Start("zs_nestbuilt")
		net.Broadcast()
	end
end


function ENT:OnRemove()

	local parent = self:GetOwner()

	if parent:IsValid() then
		FeignDeath[parent] = nil
		parent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end

	if IsValid(self.DroppedNest) then
		self.DroppedNest:Destroy()
		if parent:IsValid() then
			parent:SetMaterial("")
			parent:TakeDamage(9999,parent,parent)
		end
	end

	hook.Remove("Move", tostring(self))
end
