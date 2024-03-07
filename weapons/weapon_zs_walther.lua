AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")
SWEP.PrintName = (translate.Get("wep_walther"))
SWEP.Description = "Урон увеличивается, если зомби больше чем людей, лимит в x2.5" -- (translate.Get("desc_walther"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	SWEP.ShowWorldModel = false 

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.05, -2.5, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -115)
	SWEP.HUD3DScale = 0.0095
	
	function SWEP:Draw2DHUDAds(x, y, hei, wid)
		local dmgbonus = self.BonusDmg
		draw.SimpleTextBlurry("x"..math.Round(dmgbonus, 2).." DMG", "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUDAds(x, y, hei, wid)
		local dmgbonus = self.BonusDmg
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * 0.92, wid, 34)
		draw.SimpleTextBlurry("x"..math.Round(dmgbonus, 2).." DMG", "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/w_ins2_pist_p99.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.1000000238419, -1.2999999523163), angle = Angle(0, -7, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.ViewModelBoneMods = {
        ["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
        ["A_Suppressor"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0.75, -0.1), angle = Angle(0, 0, 0) },
        ["A_Underbarrel"] = { scale = Vector(0.6, 0.75, 0.85), pos = Vector(0, 0.55, -0.15), angle = Angle(0, 0, 0) },
        ["R UpperArm"] = { scale = Vector(0.975, 0.975, 0.975), pos = Vector(-0.1, -0.1, -0.1), angle = Angle(-0.5, 0, 0) },	
        ["L UpperArm"] = { scale = Vector(0.975,0.975, 0.975), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },	
		["Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.93, 1, 0.93), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(1.95, 3, -0.95)
	SWEP.VMAng = Angle(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
    function SWEP:Think()
        if (self:Clip1() == 0) and not (self:GetReloadFinish() > 0) then
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, Vector(0, 1.85, 0) )
        else
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end

    function SWEP:DrawAds()
		if not self:GetIronsights() then
			self.ViewModelFOV = 70
		end
	end

    function SWEP:SecondaryAttack()
        if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
            self:SetIronsights(true)
            if CLIENT then
                self.ViewModelFOV = 74
            end
        end
    end
    
	SWEP.LowAmmoSoundThreshold = 0.33
	SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
	SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
	function SWEP:EmitFireSound()
		BaseClass.EmitFireSound(self)
		local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
		local mult = clip1 / maxclip1
		self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		if self:Clip1() <= 1 then
			self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_ins2_pist_p99.mdl"
SWEP.WorldModel = "models/weapons/w_ins2_pist_p99.mdl"

SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/p99/fire.wav"
SWEP.Primary.Damage = 36.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 16
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.FireAnimSpeed = 1.25

SWEP.Primary.Ammo = "pistol"
SWEP.ConeMax = 1.8
SWEP.ConeMin = 0.9

SWEP.Tier = 5
SWEP.HeadshotMulti = 1.75
SWEP.WindowDur = 0.145

SWEP.ResistanceBypass = 0.8

SWEP.IronSightsPos = Vector(-3.81, -3.25, 1.275)
SWEP.IronSightsAng = Vector(0.935, 0.025, 0)

SWEP.BonusDmg = 1

-- GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_WINDOWDUR, 0.0075, 2)
-- GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.15, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)

SWEP.IronAnim = ACT_VM_PRIMARYATTACK_1
function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	self.ReloadTimerAnim = CurTime() + self:SequenceDuration() / (1.25 * self:GetReloadSpeedMultiplier())
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

-- function SWEP:Think()
	-- local num_z = team.NumPlayers(TEAM_UNDEAD)
	-- local num_h = team.NumPlayers(TEAM_HUMAN)
	
	-- self.BonusDmg = math.Clamp(num_z / math.max(1, num_h), 1, 2.5)

	-- self.BaseClass.Think(self)
-- end

function SWEP:Deploy()
	local num_z = team.NumPlayers(TEAM_UNDEAD)
	local num_h = team.NumPlayers(TEAM_HUMAN)
	self.BonusDmg = math.Clamp(num_z / math.max(1, num_h), 1, 2.5)
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:Initialize()
	local num_z = team.NumPlayers(TEAM_UNDEAD)
	local num_h = team.NumPlayers(TEAM_HUMAN)
	self.BonusDmg = math.Clamp(num_z / math.max(1, num_h), 1, 2.5)
	self.BaseClass.Initialize(self)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()
	
	local num_z = team.NumPlayers(TEAM_UNDEAD)
	local num_h = team.NumPlayers(TEAM_HUMAN)
	
	wep.BonusDmg = math.Clamp(num_z / math.max(1, num_h), 1, 2.5)
	dmginfo:SetDamage(dmginfo:GetDamage() * wep.BonusDmg)

end

-- function SWEP.BulletCallback(attacker, tr, dmginfo)	
    -- if SERVER then
        -- local ent = tr.Entity
        -- if ent:IsValidLivingZombie() then
            -- local hits = rawget(PlayerIsMarked2, ent)["Hitcount"] or 0
			-- local timeleft = rawget(PlayerIsMarked2, ent)["Time"] or 0
			-- if hits > 1 and (timeleft >= CurTime()) then
				-- local is_boss = (ent:GetBossTier() >= 2) and 0.25 or 0.66
				-- if rawget(PlayerIsMarked2, ent)["Attacker"] and rawget(PlayerIsMarked2, ent)["Attacker"] == attacker then
					-- print(dmginfo:GetDamage() * hits * is_boss, rawget(PlayerIsMarked2, ent)["Attacker"] == attacker)
					-- dmginfo:SetDamage(dmginfo:GetDamage() * hits * is_boss)
				-- end
			-- end
			
            -- if timeleft and not (timeleft >= CurTime()) then
                -- rawset(PlayerIsMarked2, ent, {})
            -- end
            -- local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
            -- rawset(PlayerIsMarked2, ent, {Time = CurTime() + dmginfo:GetInflictor().WindowDur or 0.165, Hitcount = hitcount, Attacker = attacker})
        -- end
    -- end
-- end

sound.Add({
	name = 			"TFA_INS2.P99.Safety",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/fireselect.wav"
})


sound.Add({
	name = 			"TFA_INS2.P99.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/slideback.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/slideforward.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Boltslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/slideback.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/maghit.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/magin_2.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/magrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.P99.MaginRelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/p99/magrelease.wav"
})