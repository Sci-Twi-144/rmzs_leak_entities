AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_deathdealers"))
SWEP.Description = (translate.Get("desc_deathdealers"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 62
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "v_weapon.slide_right"
	SWEP.HUD3DPos = Vector(0, -3, -3.5)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["handle+"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel++", pos = Vector(-0.308, 20.618, -2.906), angle = Angle(-60.416, 89, 0), size = Vector(0.685, 1.394, 1.488), color = Color(105, 105, 105, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel", pos = Vector(-0.308, 20.618, -2.906), angle = Angle(-60.416, 89, 0), size = Vector(0.685, 1.394, 1.488), color = Color(105, 105, 105, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.elite_right", rel = "barrel", pos = Vector(0, 11.961, 0), angle = Angle(0, 0, 0), size = Vector(0.035, 0.004, 0.029), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["barrel+++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.elite_right", rel = "barrel++", pos = Vector(0, 11.961, 0), angle = Angle(0, 0, 0), size = Vector(0.035, 0.004, 0.029), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["bottom2"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel", pos = Vector(0, -5.393, -3.069), angle = Angle(180, 90, 0), size = Vector(0.143, 0.07, 0.057), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0.028, -2.34, 17.02), angle = Angle(180, 0, -90), size = Vector(0.034, 0.045, 0.029), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["BARREL2+"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel++", pos = Vector(-0.138, -14.155, -0.889), angle = Angle(180, -90, -90), size = Vector(0.352, 0.356, 0.18), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["bottom2+"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel++", pos = Vector(0, -5.393, -3.069), angle = Angle(180, 90, 0), size = Vector(0.143, 0.07, 0.057), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["barrel++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.213, -2.34, 17.02), angle = Angle(180, 0, -90), size = Vector(0.034, 0.045, 0.029), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["BARREL2"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel", pos = Vector(-0.138, -14.155, -0.889), angle = Angle(180, -90, -90), size = Vector(0.352, 0.356, 0.18), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["barrel"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.041, 2.372, -5.764), angle = Angle(180, -95, 16), size = Vector(0.034, 0.045, 0.029), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(-0.308, 20.618, -2.906), angle = Angle(-60.416, 89, 0), size = Vector(0.685, 1.394, 1.488), color = Color(105, 105, 105, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(0, 11.961, 0), angle = Angle(0, 0, 0), size = Vector(0.035, 0.004, 0.029), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["BARREL2"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(-0.138, -14.155, -0.889), angle = Angle(180, -90, -90), size = Vector(0.352, 0.356, 0.18), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["bottom2"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(0, -5.393, -3.069), angle = Angle(180, 90, 0), size = Vector(0.143, 0.07, 0.057), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },

		-- Fix left hand idk why cause rel is broken or what...
		["fixleft"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(21.978, 22.829, 2.127), angle = Angle(0, -95, 8), size = Vector(0.001, 0.001, 0.001), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "fixleft", pos = Vector(-19.978, 2.829, 4.127), angle = Angle(0, 0, 8), size = Vector(0.034, 0.045, 0.029), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle+"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "barrel++", pos = Vector(-0.308, 20.618, -2.906), angle = Angle(-60.416, 89, 0), size = Vector(0.685, 1.394, 1.488), color = Color(105, 105, 105, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel+++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "barrel++", pos = Vector(0, 11.961, 0), angle = Angle(0, 0, 0), size = Vector(0.035, 0.004, 0.029), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["BARREL2+"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "barrel++", pos = Vector(-0.138, -14.155, -0.889), angle = Angle(180, -90, -90), size = Vector(0.352, 0.356, 0.18), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
		["bottom2+"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "barrel++", pos = Vector(0, -5.393, -3.069), angle = Angle(180, 90, 0), size = Vector(0.143, 0.07, 0.057), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} }	
	}

	SWEP.ViewModelBoneMods = {
		["v_weapon.elite_right"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.19, -4.318), angle = Angle(0, 0, -3) },
		["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 4.721, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7, 0, 0) },
		["v_weapon.elite_left"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.126, -3.794), angle = Angle(0, 0, -3) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7, 0, 0) }
	}

	function SWEP:Draw3DHUD(vm, pos, ang)
		self.BaseClass.Draw3DHUD(self, vm, pos, ang)
	
		local wid, hei = 180, 200
		local x, y = wid * -0.6, hei * -0.5
	
		cam.Start3D2D(pos, ang, self.HUD3DScale)
			local owner = self:GetOwner()
			local ownerstatus = owner:GetStatus("reaper")
			if ownerstatus then
				local text = ""
				for i = 0, ownerstatus:GetStacks() -1 do
					text = text .. "+"
				end
				draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.FakeWorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 14.5
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.6

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 6
SWEP.ConeMin = 4

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.75)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05, 2)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_ks23")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, nil, nil, "weapon_zs_aa12")

SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.IsShotgun = true

SWEP.ReloadActivity = ACT_VM_DRAW

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() or not self:CanReload() then return end

	if SERVER then
		for i=1,2 do
			local ent = ents.Create("prop_fakeweapon")
			if ent:IsValid() then
				ent:SetOwner(owner)
				ent:SetWeaponType(self:GetClass())
				local pos = owner:EyePos() + owner:EyeAngles():Right() * (i == 1 and 8 or -8)
				ent:SetPos(pos)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:AddAngleVelocity(Vector(math.Rand(-420, 420), math.Rand(-420, 420), math.Rand(-420, 420)))
					phys:ApplyForceCenter(phys:GetMass() * owner:GetAimVector() * math.random(64, 128))
				end
			end
		end
	end

	self.BaseClass.Reload(self)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav", 75, math.random(125, 130))
end

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()

	if killer:IsValid() then
		local reaperstatus = killer:GiveStatus("reaper", 5)
	
		if reaperstatus and reaperstatus:IsValid() then
			reaperstatus:SetStacks(math.min(reaperstatus:GetStacks() + 1, 3))
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
		end
	end
end

if not CLIENT then return end

function SWEP:GetTracerOrigin()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local vm = owner:GetViewModel()
		if vm and vm:IsValid() then
			local attachment = vm:GetAttachment(self:Clip1() % 2 + 3)
			if attachment then
				return attachment.Pos
			end
		end
	end
end
