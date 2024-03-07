AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_terrormasher")) -- Terrormasher
SWEP.Description = (translate.Get("desc_terrormasher")) -- Создает взрыв в точке удара, имеет высокий кнокбэк

-- Ивент оружие, милишка со взрывчаткой, был создан мною в сцк.
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.ViewModelFOV = 80
	
	SWEP.ShowWorldModel = false
	
	SWEP.VElements = {
	["barrel"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.101, 4.025, -25.157), angle = Angle(-2.264, 76.981, -83.774), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6.038, -1.006, -23.145), angle = Angle(81.509, -9.057, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.8, 5.031, -25.157), angle = Angle(83.774, -11.321, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.006, 7.044, -25.157), angle = Angle(88.302, 74.717, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.019, 7.044, -20.126), angle = Angle(52.075, 74.717, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, 1.006, -30.189), angle = Angle(169.811, 74.717, 4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.013, 5.031, -29.182), angle = Angle(131.321, 70.189, 4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -4.025, -28.176), angle = Angle(-131.321, 79.245, -2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -5.031, -22.138), angle = Angle(-70.189, 74.717, -4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -1.006, -18.113), angle = Angle(-22.642, 74.717, -4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 
SWEP.WElements = {
	["barrel"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.101, 4.025, -25.157), angle = Angle(-2.264, 76.981, -83.774), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6.038, -1.006, -23.145), angle = Angle(81.509, -9.057, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.8, 5.031, -25.157), angle = Angle(83.774, -11.321, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.006, 7.044, -25.157), angle = Angle(88.302, 74.717, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.019, 7.044, -20.126), angle = Angle(52.075, 74.717, 2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, 1.006, -30.189), angle = Angle(169.811, 74.717, 4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.013, 5.031, -29.182), angle = Angle(131.321, 70.189, 4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -4.025, -28.176), angle = Angle(-131.321, 79.245, -2.264), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a+++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -5.031, -22.138), angle = Angle(-70.189, 74.717, -4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["c4a++++++++"] = { type = "Model", model = "models/weapons/w_c4_planted.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.025, -1.006, -18.113), angle = Angle(-22.642, 74.717, -4.528), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.031, 2.013, 17.126), angle = Angle(-180, -158.491, 2.264), size = Vector(1.085, 1.085, 1.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/v_sledgehammer/c_sledgehammer.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 750
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 82
SWEP.MeleeSize = 4
SWEP.MeleeKnockBack = 600

SWEP.Primary.Delay = 3.3

SWEP.WalkSpeed = SPEED_SLOWEST * 0.4

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 1.33
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.4
SWEP.BlockReduction = 30
SWEP.StaminaConsumption = 17

SWEP.Tier = 5

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(20, 25))
end

function SWEP:PlayHitSound()
	self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(4)..".wav", 80, math.Rand(95, 105))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 80, math.Rand(90, 100))
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
    local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos)
        effectdata:SetNormal(tr.HitNormal)
		ParticleEffect("dusty_explosion_rockets", tr.HitPos, angle_zero)
		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 100, 100)
    BlastDamage2NoSelf(self, self.Owner, tr.HitPos, 224, self.MeleeDamage * 0.7)
	self.Owner:SetGroundEntity(NULL)
    self.Owner:SetVelocity(-900 * 1 * self.Owner:GetAimVector())
end

function BlastDamage2NoSelf(inflictor, attacker, epicenter, radius, damage)
    for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
        if ent and ent:IsValid() and ent != attacker then
            local nearest = ent:NearestPoint(epicenter)
            if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
                ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, DMG_BLAST, attacker, inflictor, nearest)
            end
        end
    end
end
