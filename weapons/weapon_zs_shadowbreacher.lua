AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	
	function SWEP:ViewModelDrawn()
		render.ModelMaterialOverride(0)
		render.SetColorModulation(1, 1, 1)
	end

	local matSkin = Material("models/flesh")
	function SWEP:PreDrawViewModel(vm)
		render.ModelMaterialOverride(matSkin)
		render.SetColorModulation(0.15, 0.15, 0.15)
	end
end

SWEP.PrintName = "Chem Breacher"

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/weapons/zombine/v_zombine_fix.mdl")
SWEP.WorldModel = ""

SWEP.MeleeDelay = 0.6
SWEP.Primary.Delay = 1.2

SWEP.MeleeDamage = 32

SWEP.AlertDelay = 3.5

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:SendAttackAnim()
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local armdelay = stbl.MeleeAnimationMul

	if stbl.SwapAnims then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	stbl.SwapAnims = not stbl.SwapAnims
	if stbl.SwingAnimSpeed then
		owner:GetViewModel():SetPlaybackRate(stbl.SwingAnimSpeed * armdelay)
	else
		owner:GetViewModel():SetPlaybackRate(1 * armdelay)
	end
end
--[[
function SWEP:MeleeHit(ent, trace, damage, forcescale)
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local radius = stbl.Radius

	if not ent:IsPlayer() then
		if SERVER then 
			local pos = trace.HitPos -- or ent:GetPos()???

			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
				if hitent:IsBarricadeProp() then
					local nearest = ent:NearestPoint(pos)
					
					damage = damage * stbl.Taper
					hitent:TakeSpecialDamage((((radius ^ 2) - nearest:DistToSqr(pos)) / (radius ^ 2)) * damage, DMG_SLASH, owner, self)

				end
			end
		end
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end
]]
function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if SERVER then
		if ent:IsBarricadeProp() then 
			local debuff = ent:EGiveStatus("ruin", 3)
			if debuff and debuff:IsValid() then 
				debuff.Applier = self:GetOwner()
				debuff:SetDTEntity(0, ent) 
			end
		end
	end
	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end


function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/combine_gunship/gunship_moan.wav", 75, math.random(45,60))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, math.random(55,65))
end