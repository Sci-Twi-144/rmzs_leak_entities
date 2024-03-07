SWEP.Base = "weapon_zs_base"

SWEP.PrintName = "Food"
SWEP.Slot = 5
SWEP.SlotPos = 0

--SWEP.ViewModel = "models/weapons/c_gren_drink.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"
SWEP.EatHoldType = "camera"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "watermelon"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.FoodHealth = 15
SWEP.FoodEatTime = 4
SWEP.EatViewAngles = Angle(80, 0, 15)
SWEP.EatViewOffset = Vector(-8, -40, 0)

SWEP.AmmoIfHas = true
SWEP.NoPickupIfHas = true
SWEP.NoMagazine = true

SWEP.AllowQualityWeapons = false

SWEP.DroppedColorModulation = Color(1, 0, 1)

SWEP.NeedToPlayEatSound = true
SWEP.SugarRushFood = false

SWEP.AnimStart = ACT_VM_PRIMARYATTACK
SWEP.AnimLoop = ACT_VM_HOLSTER
SWEP.AnimEnd = ACT_VM_FIDGET

SWEP.WalkSpeed = SPEED_NORMAL

AccessorFuncDT(SWEP, "EatEndTime", "Float", 0)
AccessorFuncDT(SWEP, "EatStartTime", "Float", 1)

SWEP.Weight = 1

SWEP.IsFood = true
SWEP.FoodType = "drink"

function SWEP:Initialize()
	GAMEMODE:DoChangeDeploySpeed(self)
	self:SetWeaponHoldType(self.HoldType)
	self:SetFoodEatHoldType(self.EatHoldType)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:SetFoodEatHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateSwing = new
end

function SWEP:CanEat()
	local owner = self:GetOwner()

	if owner:GetStatus("sickness") then return false end

	if owner:IsSkillActive(SKILL_SUGARRUSH) then
		return true
	end

	return true
end

function SWEP:PrimaryAttack()
	self:AnimTime()
	local foodloop, mul
	if self:GetEatEndTime() == 0 and self:CanEat() then
		local mul = self:CalculateEatTime() and (self:GetFoodEatTime()/self:CalculateTotalTime()) or 1
		local loopwindow = self:GetFoodEatTime() - (self.BaseStart + self.BaseEnd)
		local looptime = self.BaseLoop * mul
		self:SetDTInt(18, math.max(math.floor(loopwindow/looptime), 1))
		local endloop = self.BaseEnd
		if self:CalculateEatTime() then	
			foodloop = self.BaseStart * mul
			self:SendWeaponAnim(self.AnimStart)
			self:ProcessAnim(1/mul)
		else
			foodloop = self.BaseStart
			self:SendWeaponAnim(self.AnimStart)
			self:ProcessAnim(1)
		end
		self:SetEatStartTime(CurTime() + foodloop)
		self:SetEatEndTime(CurTime() + self:GetFoodEatTime())
		self:SetDTFloat(17, CurTime() + self:GetFoodEatTime() - endloop * mul)
		self:SetDTFloat(19, CurTime() + foodloop)
	end
end

function SWEP:CalculateEatTime()
	local total = self.BaseStart + self.BaseLoop + self.BaseEnd
	
	if total >= self:GetFoodEatTime() then
		return true
	else
		return false
	end
end

function SWEP:CalculateTotalTime()
	local total = self.BaseStart + self.BaseLoop + self.BaseEnd
	return total
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()

	if owner.HasTProcessor then
		owner:EmitSound("weapons/bugbait/bugbait_squeeze1.wav", 65, 150)

		if SERVER then
			owner:GiveAmmo(self.FoodHealth, "Battery")
			owner:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:Reload()
end

function SWEP:BuffMe()
	
end

function SWEP:DoLoopAnim() 
	local mul = self:CalculateEatTime() and (self:GetFoodEatTime()/self:CalculateTotalTime()) or 1
	local looptime = self.BaseLoop * mul
	local start, loop, endt = self.BaseStart, self.BaseLoop, self.BaseEnd
	if self:CalculateEatTime() then
		local loopnum = 1
		local loopdelay = looptime * loopnum
		self:SetDTInt(18, self:GetDTInt(18) - 1)
		self:SetDTFloat(19, CurTime() + loopdelay)
		
		self:SendWeaponAnim(self.AnimLoop)
		self:ProcessAnim(1/mul)
	else
		local loopwindow = self:GetFoodEatTime() - (start + endt)
		local loopnum = loopwindow/looptime
		local totalmul = 1 + (looptime * loopwindow - math.floor(looptime * loopnum) * looptime)/loopnum
		local loopdelay = looptime / totalmul
		self:SetDTInt(18, self:GetDTInt(18) - 1)
		self:SetDTFloat(19, CurTime() + loopdelay)
		self:SendWeaponAnim(self.AnimLoop)
		self:ProcessAnim(totalmul)
	end
end

function SWEP:DoEndAnim()
	local mul = self:CalculateEatTime() and (self:CalculateTotalTime()/self:GetFoodEatTime()) or 1
	self:SetDTFloat(17, self:GetEatEndTime())
	self:SendWeaponAnim(self.AnimEnd)
	self:ProcessAnim(mul)
end

function SWEP:AnimTime()
	self.BaseStart = self:SequenceDuration(self:SelectWeightedSequence(self.AnimStart))
	self.BaseLoop = self:SequenceDuration(self:SelectWeightedSequence(self.AnimLoop))
	self.BaseEnd = self:SequenceDuration(self:SelectWeightedSequence(self.AnimEnd))
end

--[[function SWEP:GetRealSeqTime(arg)
	local aboba
	local owner = self:GetOwner()
	local viewmod = owner:GetViewModel()
	if arg == "start" then
		aboba = self:SequenceDuration(self:SelectWeightedSequence(self.AnimStart)) / viewmod:GetPlaybackRate()
		print(aboba, "aboba")
		return aboba
	elseif arg == "loop" then
		aboba = self:SequenceDuration(self:SelectWeightedSequence(self.AnimLoop)) / viewmod:GetPlaybackRate()
		return aboba
	else
		aboba = self:SequenceDuration(self:SelectWeightedSequence(self.AnimEnd)) / viewmod:GetPlaybackRate()
		return aboba
	end
end]]

function SWEP:Think()
	if self:GetEatEndTime() > 0 then
		local time = CurTime()

		--[[if math.cos(12 * math.pi * (time - self:GetEatStartTime()) / self:GetFoodEatTime()) < 0 then -- Derivitive of sin(x) = cos(x/2)
			if self.NeedToPlayEatSound then
				self.NeedToPlayEatSound = false
				local snd
				if self.FoodIsLiquid then
					snd = "zombiesurvival/drink"..math.random(3)..".ogg"
				else
					snd = "zombiesurvival/eat1.ogg"
				end
				self:EmitSound(snd, 60, math.random(90, 110))
			end
		else
			self.NeedToPlayEatSound = true
		end]]
		
		if self:ShouldDoLoopAnim() then
			self:DoLoopAnim()
		end
		
		if self:ShouldDoEndAnim() then
			self:DoEndAnim()
		end
		
		if time >= self:GetEatEndTime() then
			self:SetEatEndTime(0)

			if SERVER then
				self:Eat()

				return
			end
		end

		local owner = self:GetOwner()
		if not owner:IsValid() then return end

		if owner:GetStatus("sickness") then
			self:SetEatEndTime(0)
		end

		if owner:IsSkillActive(SKILL_GLUTTON) or owner:IsSkillActive(SKILL_SUGARRUSH) then return end
	end
end

function SWEP:Holster()
	self:SetEatStartTime(0)
	self:SetEatEndTime(0)

	return true
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
	return true
end

function SWEP:GetFoodEatTime()
	local owner = self:GetOwner()
	return self.FoodEatTime * ((owner:IsValid() and owner.FoodEatTimeMul or 1) * (owner.Gourmet and 3 or 1))
end

function SWEP:ProcessAnim(mul)
	self:GetOwner():GetViewModel():SetPlaybackRate(mul)
end

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]      	= ACT_HL2MP_IDLE_DUEL,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA
}

function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= index+9

	-- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

	-- these two aren't defined in ACTs for whatever reason
	if t == "knife" or t == "melee2" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = nil
	end
end

SWEP:SetWeaponHoldType("melee")

function SWEP:TranslateActivity( act )
	if self:GetEatEndTime() ~= 0 and self.ActivityTranslateSwing[act] then
		return self.ActivityTranslateSwing[act] or -1
	end

	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end

function SWEP:ShouldDoEndAnim()
	return self:GetDTFloat(17) > 0 and CurTime() >= self:GetDTFloat(17)
end

function SWEP:ShouldDoLoopAnim()
	return self:GetDTInt(18) > 0 and self:GetDTFloat(19) <= CurTime() and true or false
end

sound.Add(
{
	name = "chew",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"zombiesurvival/eat1.ogg"}
})

sound.Add(
{
	name = "nom",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"zombiesurvival/eat1.ogg"}
})

sound.Add(
{
	name = "glit",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/foods/glit.mp3"}
})

sound.Add(
{
	name = "roar",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/foods/roar.wav"}
})

sound.Add(
{
	name = "pshh",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = {"weapons/foods/pshh.mp3"}
})