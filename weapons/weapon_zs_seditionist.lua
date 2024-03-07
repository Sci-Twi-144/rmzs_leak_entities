AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_seditionist"))
SWEP.Description = (translate.Get("desc_seditionist"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-1.5, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.IronSightsPos = Vector(-6.36, 5, 1.6)

	SWEP.VElements = {
		["laserbeam"] = { type = "Sprite", sprite = "sprites/glow01", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(-0.018, -3.799, -1.691), size = { x = 0.79, y = 0.79 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["back++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "back", pos = Vector(0, -0.387, -1.553), angle = Angle(0, 0, -180), size = Vector(0.018, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["back"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0.02, -3.869, -4.113), angle = Angle(0, 0, -90), size = Vector(0.018, 0.013, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["scope"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back+", pos = Vector(2.154, 0, 2.752), angle = Angle(90, 0, 0), size = Vector(0.028, 0.024, 0.098), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["scopeinnard+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.426, 0, 0.323), angle = Angle(90, 0, 0), size = Vector(0.025, 0.024, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["back+"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, 1.519, 1.187), angle = Angle(90, -0.288, -90), size = Vector(0.01, 0.021, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["back+++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.Deagle_Parent", rel = "back", pos = Vector(0, -3.51, -0.551), angle = Angle(0, 0, -90), size = Vector(0.03, 0.03, 0.03), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["dribble+"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(-1.209, 3.344, 0.642), angle = Angle(-105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["scopeinnard"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.423, 0, 0.323), angle = Angle(90, 180, 0), size = Vector(0.025, 0.024, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/props_phx/trains/wheel_medium.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(0, -3.399, -1.675), angle = Angle(0, 0, -90), size = Vector(0.016, 0.016, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["dribble"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(1.208, 3.344, 0.094), angle = Angle(105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["scopeinnard+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 8.166, 1.659), angle = Angle(180, 90, 0), size = Vector(0.025, 0.024, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["laserbegins"] = { type = "Sprite", sprite = "sprites/glow01", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(-0.018, -3.799, -1.691), size = { x = 0.79, y = 0.79 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["scopeinnard++"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 8.166, 1.659), angle = Angle(0, 90, 0), size = Vector(0.025, 0.024, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["scope"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 7.666, 1.121), angle = Angle(90, 90, 0), size = Vector(0.028, 0.024, 0.098), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["back"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.425, 2.095, -4.106), angle = Angle(180, -94.622, 2.526), size = Vector(0.018, 0.013, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["back+"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.125, 1.56, -2.293), angle = Angle(178.087, -4.79, 0), size = Vector(0.01, 0.021, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["back+++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -3.51, -0.551), angle = Angle(0, 0, -90), size = Vector(0.03, 0.03, 0.03), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["back++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -0.387, -1.553), angle = Angle(0, 0, -180), size = Vector(0.018, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["dribble+"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(-1.209, 3.344, 0.642), angle = Angle(-105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/props_phx/trains/wheel_medium.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -3.399, -1.675), angle = Angle(0, 0, -90), size = Vector(0.016, 0.016, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
		["dribble"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(1.208, 3.344, 0.094), angle = Angle(105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 53
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.32
SWEP.Primary.KnockbackScale = 2

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.ConeMax = 3.75
SWEP.ConeMin = 1.5

SWEP.FireAnimSpeed = 1.3

SWEP.Tier = 4

SWEP.Pierces = 4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BULLET_PIERCES, 1)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/deagle/deagle-1.wav", 75, math.random(122, 130), 0.6)
	self:EmitSound("weapons/elite/elite-1.wav", 75, math.random(82, 88), 0.4, CHAN_WEAPON + 20)
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

local M_Player = FindMetaTable("Player")
local P_Team_Old = M_Player.Team

local function P_Team(pl)
	return (IS_SERVER_RUNNING and InitPlayerTeams[pl] or P_Team_Old(pl)) or P_Team_Old(pl)
end

local function EntityIsPlayer(e)
	return getmetatable(e) == M_Player
end

local temp_ignore_team
local temp_shooter = NULL
local temp_attacker = NULL

local function BCBBulletFilter(ent)
	if ent and isnumber(ent) then
		ent = Entity(ent) -- Convert to real entity.
	end


	--print(temp_shooter)
	--print(temp_attacker, "attacker")
	if ent == temp_shooter or ent == temp_attacker or EntityIsPlayer(ent) and P_Team(ent) == temp_ignore_team then
		return false
	end

	local etbl = E_GetTable(ent)
	if etbl.NeverAlive or SpawnProtection[ent] or etbl.IgnoreBullets then
		return false
	end

	if AlreadyDamaged[ent] then
		return false
	end

	if etbl.AlwaysImpactBullets then
		return true
	end

	if IS_SERVER_RUNNING and GAMEMODE.ZombieEscape then
		return use_ze_bullet and not EntityIsPlayer(ent) or (ZE_IsBoss and not ZE_IsBoss(ent, etbl))
	end

	return true
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = attacker:GetActiveWeapon()
	local stbl = E_GetTable(wep)
	local dmg = stbl.Primary.Damage
	local numbul = stbl.Primary.NumShots
	--local start = attacker:GetShootPos()
	local trpen = ents.FindAlongRay(tr.HitPos, tr.HitPos + attacker:GetAimVector() * 768, nil, nil)
	local vPos = attacker:GetShootPos() --attacker:GetPos()

	local dmgf = function(i) return dmg * (1 - 0.1 * i) end
	
	for i = 1, #trpen do
		local hitent = trpen[i]
		if hitent:IsPlayer() then
			if i > (stbl.Pierces + 1) - 1 then break end
			if WorldVisible(vPos, hitent:NearestPoint(vPos)) then

				AlreadyDamaged[hitent] = false
				attacker:FireBulletsLua(tr.HitPos, attacker:GetAimVector(), 0, numbul, dmg/i, nil, stbl.Primary.KnockbackScale, "", nil, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, BCBBulletFilter, wep)
				AlreadyDamaged[hitent] = true
			else
				attacker:FireBulletsLua(tr.HitPos, attacker:GetAimVector(), 0, numbul, dmg, nil, stbl.Primary.KnockbackScale, "", nil, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, BCBBulletFilter, wep)
				break
			end
		end
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_hunter", effectdata)
	end
	return {damage = false}
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local wep = owner:GetActiveWeapon()

	temp_shooter = owner
	temp_attacker = owner

	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, dmg, nil, stbl.Primary.KnockbackScale, stbl.TracerName, stbl.BulletCallback, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, nil, wep)
	owner:LagCompensation(false)
end