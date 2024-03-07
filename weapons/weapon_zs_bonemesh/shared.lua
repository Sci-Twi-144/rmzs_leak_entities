SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeReach = 52
SWEP.MeleeDelay = 0.55
SWEP.MeleeSize = 4.5 --1.5
SWEP.MeleeDamage = 40 --28
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.05

SWEP.Primary.Delay = 1.6

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.BuildSound = CreateSound(self, "npc/antlion/charge_loop1.wav")
	self.BuildSound:PlayEx(0, 100)

	self.FlySound = CreateSound(self, "npc/antlion/fly1.wav")
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	self.BuildSound:Stop()
	self.FlySound:Stop()
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("NPC_PoisonZombie.ThrowWarn")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, 140)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:SetSwingAnimTime(time)
	self:SetDTFloat(15, time)
end

function SWEP:GetSwingAnimTime()
	return self:GetDTFloat(15)
end

function SWEP:StartSwinging()
	self.BaseClass.StartSwinging(self)
	self:SetSwingAnimTime(CurTime() + 1)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	local owner = self:GetOwner()
	if ent.ZombieConstruction then
		if owner.NestBanned then return end
		damage = damage * 3
		ent:SetNestHealth(ent:GetNestHealth() - damage)
		ent:SetNestLastDamaged(CurTime())
		if ent:GetNestHealth() <= 0 then
			gamemode.Call("NestDestroyed", ent, self)
			net.Start("zs_nestnotifier")
				net.WriteString(ent:GetClass())
				net.WriteString(self:GetClass())
				net.WriteEntity(owner)
			net.Broadcast()

			net.Start("zs_nestdestroyed")
				net.WriteString(owner and owner:Name() or "")
				net.WriteBool(owner)
				net.WriteInt(ent:GetNestMutationLevel(), 4)
			net.Send(team.GetPlayers(TEAM_UNDEAD))

			ent:Destroy()
		end
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if not self:GetOwner():KeyDown(IN_RELOAD) then
	--	self:SetRightClickStart(0)

		if self.BuildSoundPlaying then
			self.BuildSoundPlaying = false
			self.BuildSound:ChangeVolume(0, 0.5)
		end
	else
		if not self.BuildSoundPlaying then
			self.BuildSoundPlaying = true
			self.BuildSound:ChangeVolume(0.45, 0.5)
		end

		if SERVER then
			self:BuildingThink()
		end
	end

	self:NextThink(CurTime())
	return true
end