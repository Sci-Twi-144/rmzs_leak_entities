AddCSLuaFile()

SWEP.PrintName = "Ghoul"

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"

SWEP.MeleeDamage = 100
SWEP.MeleeForceScale = 1
SWEP.SlowDownScale = 0.25
SWEP.MeleeDamageVsProps = 100

function SWEP:Reload()
end

function SWEP:PlayAlertSound()
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
end

function SWEP:SecondaryAttack()
	if self.Cock and self.Cock >= CurTime() then return end
	self.Cock = CurTime() + 4

	if SERVER then
		self:GetOwner():EmitSound("hl1/creatures/gon_alert"..math.random(3)..".wav", 150, 50)
	end
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
