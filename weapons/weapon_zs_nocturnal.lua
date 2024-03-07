AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_fastzombie")

SWEP.PrintName = (translate.Get("class_nocturnal"))

SWEP.ViewModel = Model("models/weapons/v_fza.mdl") --Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = ""

if CLIENT then
	SWEP.ViewModelFOV = 42
	
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Tremor and Slow", false, true, false)
	end
end
--[[
sound.Add({
	name = "Weapon_Lacerator.Swinging",
	channel = CHAN_AUTO,
	volume = 0.55,
	level = 75,
	pitch = 100,
	sound = "npc/antlion_guard/confused1.wav"
})
]]
SWEP.MeleeDamage = 11

SWEP.SlowMeleeDelay = 0.8
SWEP.SlowMeleeDamage = 20
SWEP.PounceDamage = 30

SWEP.BleedDamageMul = 0.75
SWEP.EnfeebleDurationMul = 0.25
SWEP.ResourceMul = 1
SWEP.ResCap = 200
SWEP.HasAbility = true

function SWEP:Initialize()
	self.LaceratorAttack = CreateSound(self, "npc/antlion_guard/confused1.wav")
	self.LaceratorAttack:SetSoundLevel(75)

	self.BaseClass.Initialize(self)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = math.floor(damage * 18/22)
	elseif ent:IsPlayer() and ent:IsValidLivingHuman() then
		if ent.NoctHit and ent.NoctHit > CurTime() then
			damage = damage + damage * (ent.NoctHitCount or 0) * 0.1
			ent.NoctHitCount = ent.NoctHitCount + 1
		else
			ent.NoctHitCount = 1
		end
		ent.NoctHit = CurTime() + 1.5
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(damage * self.BleedDamageMul)
			bleed.Damager = self:GetOwner()
		end
		
		ent:ApplyZombieDebuff("enfeeble", damage * self.EnfeebleDurationMul, {Applier = self:GetOwner(), Stacks = 3}, true, 6)
		
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if (self:GetResource() >= self.ResCap) then
		local center = owner:GetPos() + Vector(0, 0, 32)
		
		owner:EmitSound("npc/stalker/go_alert2a.wav", 90)
		
		if SERVER then
			for _, ent in pairs(util.BlastAlloc(self, owner, center, 150)) do
				if ent:IsValidLivingHuman() and WorldVisible(ent:WorldSpaceCenter(), center) then
					ent:ApplyZombieDebuff("slow", 5, {Applier = owner}, true, 8)
					ent:ApplyZombieDebuff("frightened", 5, {Applier = owner}, true, 39)
					ent:AddLegDamage(3)	
				end
			end
		end
		self:SetResource(0)
		self.BaseClass.Reload(self)
	else
		self.BaseClass.Reload(self)
	end
end

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist<10000 then -- Square(100)
			return 0
		elseif dist<250000 and (not self.NextLeapTimer or self.NextLeapTimer<CurTime()) then -- Square(500)
			self.NextLeapTimer = CurTime() + math.Rand(1,4)
			return 1
		elseif (self:GetResource() >= self.ResCap) then
			return 2 
		end
	end
end

function SWEP:PlayPounceHitSound()
	self:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	self:EmitSound("npc/fast_zombie/wake1.wav", 75, math.random(75, 80), nil, CHAN_AUTO)
end

function SWEP:PlayPounceStartSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", 75, math.random(75, 80), nil, CHAN_AUTO)
end

function SWEP:PlayPounceSound()
	self:EmitSound("npc/ichthyosaur/attack_growl1.wav", 75, math.random(100, 116), nil, CHAN_AUTO)
end

function SWEP:PlaySwingEndSound()
	self:EmitSound("npc/zombie_poison/pz_alert2.wav", 75, nil, nil, CHAN_AUTO)
end

function SWEP:StartSwingingSound()
--	self:EmitSound("Weapon_Lacerator.Swinging")
	self.LaceratorAttack:PlayEx(1, 100)
end

function SWEP:StopSwingingSound()
--	self:StopSound("Weapon_Lacerator.Swinging")
	self.LaceratorAttack:Stop()
end

function SWEP:PlaySlowSwingSound()
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(1, 3)..".wav", 75, math.random(80, 85))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:OnRemove()
	self.LaceratorAttack:Stop() 
	self.BaseClass.OnRemove(self)
end

local matSheet = Material("Models/charple/charple4_sheet.vtf")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
