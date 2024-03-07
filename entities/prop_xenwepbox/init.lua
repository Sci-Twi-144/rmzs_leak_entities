--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NamesOfAmmo = {
	[1] = "ar2",
	[2] = "pistol",
	[3] = "smg1",
	[4] = "357",
	[5] = "xbowbolt",
	[6] = "buckshot",
	[7] = "chemical",
	[8] = "scrap",
	[9] = "pulse",
	[10] = "impactmine",
	[11] = "battery"
}

ENT.NamesOfGrenade = {
	[1] = "Grenade",
	[2] = "flashbomb",
	[3] = "rfgrenade"
}

ENT.NamesOfSWEPGrenade = {
	[1] = "weapon_zs_grenade",
	[2] = "weapon_zs_flashbomb",
	[3] = "weapon_zs_rfgrenade"
}

ENT.LastUse = 0
ENT.Checked = false

function ENT:Initialize()
	self:SetModel("models/weapons/w_weaponbox.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	local num = math.random(1, 11)
	if num == 3 then num = math.random(3, 4) end
	self:SetSelfType(num)
end

function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() then return end
	if activator.LastTimeXenUsed >= CurTime() then
		if self.LastUse <= CurTime() then
			activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "used_xen_already").." "..math.ceil(activator.LastTimeXenUsed - CurTime()).." seconds")
			self.LastUse = CurTime() + 0.5
		end
	return end


	if self:GetSelfType() == 1 then
		caller:SetBloodArmor(caller.MaxBloodArmor)
		caller:Health(caller:GetMaxHealth())
		local strght = {Applier = caller, Damage = (0.4 * (caller.BuffEffectiveness or 1))} 
		local prot = {Applier = caller, Damage = 0.3 * (caller.BuffEffectiveness or 1)}
		caller:ApplyHumanBuff("strengthdartboost", 120 * (caller.BuffDuration or 1), strght)
		caller:ApplyHumanBuff("medrifledefboost", 120 * (caller.BuffDuration or 1), prot)
		caller:ApplyHumanBuff("healdartboost", 8 * (caller.BuffDuration or 1), {Applier = caller})
		caller:EmitSound(")items/suitchargeok1.wav", 1, 80)
		caller:CenterNotify(COLOR_CYAN, "You are full!")
	elseif self:GetSelfType() == 2 then
		local num = math.random(3)
		caller:Give(self.NamesOfSWEPGrenade[num])
		caller:GiveAmmo(1, self.NamesOfGrenade[num])
		net.Start("zs_ammopickup")
			net.WriteUInt(1, 16)
			net.WriteString(self.NamesOfGrenade[num])
		net.Send(caller)
	elseif self:GetSelfType() == 3 then
		caller:AddInventoryItem("trinket_bounty")
		net.Start("zs_invitem")
			net.WriteString("trinket_bounty")
		net.Send(caller)
	else
		--local ammotypecaller = caller:GetActiveWeapon().Primary.Ammo
		local ammotype = caller:GetResupplyAmmoType()

		--[[for i = 1, 11 do 
			if self.NamesOfAmmo[i] == ammotypecaller then
				self.Checked = true
			end
		end]]

		if ammotype != "scrap" then 
			caller:GiveAmmo(GAMEMODE.AmmoCache[ammotype] * 2, ammotype)
			net.Start("zs_ammopickup")
				net.WriteUInt(GAMEMODE.AmmoCache[ammotype] * 2, 16)
				net.WriteString(ammotype)
			net.Send(caller)
		else
			local i = math.random(1, 11)
			caller:GiveAmmo(GAMEMODE.AmmoCache[self.NamesOfAmmo[i]] * 2, self.NamesOfAmmo[i])
			net.Start("zs_ammopickup")
				net.WriteUInt(GAMEMODE.AmmoCache[self.NamesOfAmmo[i]] * 2, 16)
				net.WriteString(self.NamesOfAmmo[i])
			net.Send(caller)
		end
	end
	
	activator.LastTimeXenUsed = CurTime() + 5
	
	self:Remove()
end