--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
ENT.DeathTime = 0
ENT.ResupClass = nil

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/hunter/misc/sphere075x075.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetRenderFX(kRenderFxDistort)
	self:SetModelScale(0.1)
	self.DeathTime = CurTime() + 5
	self:DoElectricityEffectSmall()
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	self:EmitSound("ambient/levels/labs/electric_explosion2.wav", 75, 100)

	self.AmbientSound = CreateSound(self, "ambient/levels/labs/teleport_malfunctioning.wav")
	self.AmbientSound:PlayEx(0.5, 65)
	
	for _, sig in pairs(GAMEMODE:GetSigils()) do
		local effectdata = EffectData()
			effectdata:SetOrigin(sig:GetPos() + Vector(0, 0, 60))
			effectdata:SetStart(self:GetPos())
			--effectdata:SetEntity(self)
		util.Effect("tracer_lightning_xen", effectdata)
	end
end

function ENT:Think()
	if self.DeathTime <= CurTime() then
		self:Remove()
	end
	self:NextThink(CurTime())
end

function ENT:OnRemove()
	--self:EmitSound("ambient/levels/labs/electric_explosion2.wav", 75, 100)
	self.AmbientSound:Stop()
	self:EmitSound("ambient/machines/teleport3.wav", 75, 100)
	local ang = Angle(0, 0, 0)
	local resuptype = "prop_xenresupbox_ammo"
	ang.yaw = math.random(90)

	local think = math.random(1, 9 - math.min((GAMEMODE:GetWave() or 0), 6))

	if think == 1 then
		resuptype = "prop_xenresupbox_wep"
	elseif think == 2 then
		resuptype = "prop_xenresupbox_ammo_wep"
	else
		resuptype = "prop_xenresupbox_ammo"
	end

	resuptype = self.ResupClass or resuptype

	if self.ResupClass == "SpawnDemi" then
		local bots = player.GetBots()
		for i = 1, #bots do
			local bot = bots[i]
			if bot:IsBot() and (bot:GetBossTier() < 1) and bot:IsBot() then
				GAMEMODE.ShouldSpawnOnSpecialPlace = self
				GAMEMODE:SpawnDemibossByDirector(bot, true, true)
				GAMEMODE.ShouldSpawnOnSpecialPlace = false
				break
			end
		end
	elseif self.ResupClass == "SpawnPSCrate" then
		local ent = ents.Create("prop_psarsenal2")
		if ent:IsValid() then
			ent:SetPos(self:GetPos() + Vector(0, 0, -15))
			ent:SetAngles(ang)
			ent:Spawn()
		end
		--for _, pl in pairs(player.GetHumans()) do pl:CenterNotify(COLOR_RED, "Появилась консоль вызова.") end
		GAMEMODE:CenterNotify({font = "CloseCaption_Bold"}, "", Color(100,70,255), "Появилась консоль вызова.")
	else
		local ent = ents.Create(resuptype)
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetAngles(ang)
			ent:Spawn()
			ent:Fire("kill", "", 90)
		end
	end
end
 -- sprites/hydraspinalcord effects/tau_beam sprites/lgtning prites/laserbeam sprites/lgtning_noz sprites/plasmabeam sprites/physbeama.vmt
function ENT:DoElectricityEffectSmall()
	local teslacoil = ents.Create("point_tesla")
	if !teslacoil or !IsValid(teslacoil) then return false end
	teslacoil:SetPos(self:GetPos())
	teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
	teslacoil:SetKeyValue("texture", "sprites/plasmabeam.vmt")
	teslacoil:SetKeyValue("m_Color", "50, 255, 50")
	teslacoil:SetKeyValue("m_flRadius", (128))
	teslacoil:SetKeyValue("interval_min", (0.016 * 0.75))
	teslacoil:SetKeyValue("interval_max", (0.022 * 1.25))
	teslacoil:SetKeyValue("beamcount_min", 3)
	teslacoil:SetKeyValue("beamcount_max", 9)
	teslacoil:SetKeyValue("thick_min", (1 * 0.75))
	teslacoil:SetKeyValue("thick_max", (1 * 1.25))
	teslacoil:SetKeyValue("lifetime_min", (0.3 * 0.75))
	teslacoil:SetKeyValue("lifetime_max", (0.3 * 1.25))
	teslacoil:Spawn()
	for i = 1, math.random(5, 10) do
		teslacoil:Fire("DoSpark", "", i / 2)
	end
	teslacoil:Fire("kill", "", 5)
end