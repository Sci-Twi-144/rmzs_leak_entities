AddCSLuaFile()  

DEFINE_BASECLASS("weapon_zs_fastzombie")

SWEP.PrintName = "Tormentor"  
SWEP.ViewModel = Model("models/weapons/v_fza.mdl")   
SWEP.WorldModel = ""  

if CLIENT then  
	SWEP.ViewModelFOV = 70 
end  

SWEP.MeleeDamage = 10  
SWEP.SlowMeleeDelay = 0.8 
SWEP.SlowMeleeDamage = 22    
SWEP.PounceDamage = 40 
SWEP.PounceVelocity = 800

SWEP.BleedDamageMul = 5 / SWEP.MeleeDamage
SWEP.MeleeDamageVsProps = 10

function SWEP:Initialize()
	self.TormentorAttack = CreateSound(self, "npc/antlion_guard/confused1.wav")
	self.TormentorAttack:SetSoundLevel(75)

	self.BaseClass.Initialize(self)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() and not (self:IsPouncing() or self:GetPounceTime() > 0) then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() and not (self:IsPouncing() or self:GetPounceTime() > 0) then
		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(damage * self.BleedDamageMul)
			bleed.Damager = self:GetOwner()
		end
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:PlayPounceHitSound()  
	self:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")  
	self:EmitSound("npc/fast_zombie/wake1.wav", 75, math.random(75, 80), nil, CHAN_AUTO) 
end  

function SWEP:PlayPounceStartSound()  
self:EmitSound("npc/fast_zombie/leap1.wav", 75, math.random(75, 80), nil, CHAN_AUTO) 
end 

function SWEP:PlayPounceSound()  
	self:EmitSound("npc/ichthyosaur/attack_growl1.wav", 75, math.random(75, 80), nil, CHAN_AUTO) 
end  

function SWEP:PlaySwingEndSound()  
	self:EmitSound("npc/zombie_poison/pz_alert2.wav", 75, nil, nil, CHAN_AUTO) 
end 

function SWEP:StartSwingingSound()
	self.TormentorAttack:PlayEx(1, 100)
end  

function SWEP:StopSwingingSound()  
	self.TormentorAttack:Stop()
end  

function SWEP:PlaySlowSwingSound()  
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav") 
end

function SWEP:PlayAlertSound()  
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(1, 3)..".wav", 75, math.random(80, 85)) 
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound 


function SWEP:OnRemove()
	self.TormentorAttack:Stop() 
	self.BaseClass.OnRemove(self)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSkin = Material("models/flesh")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSkin)
end