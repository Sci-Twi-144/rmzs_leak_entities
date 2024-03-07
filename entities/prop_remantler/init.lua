--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local function RefreshRemantlerOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_remantler")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "Remantler.PlayerDisconnected", RefreshRemantlerOwners)
hook.Add("OnPlayerChangedTeam", "Remantler.OnPlayerChangedTeam", RefreshRemantlerOwners)

function ENT:Initialize()
	self.Contents = {}
	self.NextUse = {}

	if RI_EUSERVER then
		self:SetModel("models/props_lab/powerbox01a.mdl")
	else
		self:SetModel("models/rmzs_customs/remantler.mdl")
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE_TURRET, ZS_COLLISIONGROUP_ALL)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetMaxObjectHealth(200)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end

		local pos = self:LocalToWorld(self:OBBCenter())

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_remantler")
	pl:GiveAmmo(1, "remantler")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth(), self:GetScraps())

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
end

ENT.DeployableFills = true
function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() then return end

	local uid = activator:UniqueID()
	if self.NextUse[uid] and CurTime() < self.NextUse[uid] then return end
	self.NextUse[uid] = CurTime() + 0.75

	local owner = self:GetObjectOwner()
	if not owner:IsValid() then
		self:SetObjectOwner(activator)
		self:GetObjectOwner():SendDeployableClaimedMessage(self)
		return
	end

	local currentwep = activator:GetActiveWeapon()
	if not currentwep:IsValid() then return end

	local currentwepclass = currentwep:GetClass()
	local heldtbl = weapons.Get(currentwepclass)

	if activator == owner and self:GetScraps() > 0 then
		local amount = self:GetScraps()
		self:SetScraps(0)

		net.Start("zs_ammopickup")
			net.WriteUInt(amount, 16)
			net.WriteString("scrap")
		net.Send(activator)

		activator:GiveAmmo(amount, "scrap")
		rawset(ScrapRecivedFromRemantler, activator, rawget(ScrapRecivedFromRemantler, activator) + amount)

		self.NextUse[uid] = CurTime() + 0.05
		return
	end

	if (heldtbl.AllowQualityWeapons or heldtbl.PermitDismantle) then
		activator:SendLua("surface.PlaySound(\"ambient/misc/shutter1.wav\")")
	end

	activator:SendLua("GAMEMODE:OpenRemantlerMenu(MySelf:NearestRemantler())")
end
