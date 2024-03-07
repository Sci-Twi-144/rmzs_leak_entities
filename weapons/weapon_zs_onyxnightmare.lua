AddCSLuaFile()

SWEP.PrintName = (translate.Get("class_onyx_nightmare"))

SWEP.Base = "weapon_zs_zombie"

if CLIENT then
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Mass Regenration", false, true, false)
	end
end

SWEP.MeleeDamage = 35
SWEP.SlowDownScale = 1
SWEP.ResourceMul = 1
SWEP.ResCap = 200
SWEP.HasAbility = true

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	-- ��������� �����
--[[	if SERVER and ent:IsPlayer() then
		local gt = ent:GiveStatus("frightened", 2) 
		if gt and gt:IsValid() then
			gt.Applier = self:GetOwner()
		end
	end
]]
	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if (self:GetResource() >= self.ResCap) then
		local center = owner:GetPos() + Vector(0, 0, 32)
		
		owner:EmitSound("npc/combine_gunship/gunship_moan.wav", 90)
		
		if SERVER then
			for _, ent in pairs(util.BlastAlloc(self, owner, center, 150)) do
				if ent:IsValidLivingZombie() and WorldVisible(ent:WorldSpaceCenter(), center) then
					local status = ent:GiveStatus("zombie_regen2")
					local percent = (ent:GetBossTier() >= 2) and 0.1 or (ent:GetBossTier() >= 1) and 0.3 or 0.8
					if status and status:IsValid() then
						status.ThinkRate = 0.05
						status:SetHealLeft(ent:GetMaxHealthEx() * percent)
					end
				end
			end
		end
		self:SetResource(0)
		self.BaseClass.SecondaryAttack(self)
	else
		self.BaseClass.SecondaryAttack(self)
	end
end

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist<10000 then -- Square(100)
			return 0
		elseif (self:GetResource() >= self.ResCap) then
			return 2 
		end
	end
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav", 75, 85)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
