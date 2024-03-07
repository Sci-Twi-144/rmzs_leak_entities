SWEP.PrintName = "Grenade1"
SWEP.Description = "A simple fragmentation grenade.\nWhen used in the right conditions, it can obliterate groups of zombies.\nDeals explosive damage."
SWEP.Base = "weapon_zs_basethrown"
SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 999999
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.DefaultClip = 999999
SWEP.Primary.Delay=0.1
SWEP.Primary.Automatic=true

	SWEP.ViewModelBoneMods = {
		["ValveBiped.cube1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.cube"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_lab/monitor01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4, 0), angle = Angle(0,0,0), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_lab/monitor01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 5, 0), angle = Angle(0, 0, 0), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
function SWEP:ShootBullets()
	if SERVER then
		local owner = self:GetOwner()
		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetModel("models/props_lab/monitor01a.mdl")
			ent:Spawn()
			ent:SetPhysicsAttacker(owner,999)
			ent:Fire("kill","",480)
			timer.Simple(0.05,function()
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
			end)
			ent:EmitSound("WeaponFrag.Throw")
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetMass(9999)
				phys:SetBuoyancyRatio(9999)
				phys:EnableGravity(false)
				phys:AddAngleVelocity(VectorRand() * 360)
				phys:SetVelocityInstantaneous(self:GetOwner():GetAimVector() * 2000)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		for _, ent in pairs(ents.FindByClass("prop_physics")) do
			if ent and ent:GetModel() == "models/props_lab/monitor01a.mdl" then 
				ent:Remove() 
			end
		end
	end
end

SWEP.SecondThrow=SWEP.Throw
