SWEP.PrintName = "Take a pills"

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/error.mdl"
SWEP.UseHands = false

SWEP.Primary.Sound = ")weapons/crossbow/fire1.wav"
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 100

SWEP.Primary.ClipSize = 9999
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 9999
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ShowWorldModel = false

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 1

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.ReloadSpeed = 500

SWEP.AllowQualityWeapons = false

function SWEP:PrimaryAttack()
	local n = 1
	n = math.random(1, 20)
	if n == 1 then
		self.Primary.Projectile = "projectile_arrow"
	elseif n == 2 then
		self.Primary.Projectile = "projectile_flak"
	elseif n == 3 then
		self.Primary.Projectile = "projectile_flakbomb"
	elseif n == 4 then
		self.Primary.Projectile = "projectile_arrow_cha"
	elseif n == 5 then
		self.Primary.Projectile = "projectile_arrow_inq"
	elseif n == 6 then
		self.Primary.Projectile = "projectile_arrow_mini"
	elseif n == 7 then
		self.Primary.Projectile = "projectile_arrow_sli"
	elseif n == 8 then
		self.Primary.Projectile = "projectile_arrow_zea"
	elseif n == 9 then
		self.Primary.Projectile = "projectile_disc_razor"
	elseif n == 10 then
		self.Primary.Projectile = "projectile_grenade_ak103"
	elseif n == 11 then
		self.Primary.Projectile = "projectile_grenade_bouncy"
	elseif n == 2 then
		self.Primary.Projectile = "projectile_grenade_launcher"
	elseif n == 12 then
		self.Primary.Projectile = "projectile_juggernaut"
	elseif n == 13 then
		self.Primary.Projectile = "projectile_nova"
	elseif n == 14 then
		self.Primary.Projectile = "projectile_rocket"
	elseif n == 15 then
		self.Primary.Projectile = "projectile_stone"
	elseif n == 16 then
		self.Primary.Projectile = "projectile_tithonus"
	elseif n == 17 then
		self.Primary.Projectile = "projectile_chemball_generic"
	elseif n == 18 then
		self.Primary.Projectile = "projectile_wispball"
	elseif n == 19 then
		self.Primary.Projectile = "projectile_ar2bomb"
	else
		self.Primary.Projectile = "projectile_rocket"
	end
	--print(n)
	self.BaseClass.PrimaryAttack(self)
	self:SetNextPrimaryFire(CurTime() + 0.2)
end

function SWEP:Reload()
end
--[[
self.Primary.Projectile = "projectile_flak"
self.Primary.Projectile = "projectile_flakbomb"
self.Primary.Projectile = "projectile_arrow_cha"
self.Primary.Projectile = "projectile_arrow_inq"
self.Primary.Projectile = "projectile_arrow_mini"
self.Primary.Projectile = "projectile_arrow_sli"
self.Primary.Projectile = "projectile_arrow_zea"
self.Primary.Projectile = "projectile_disc_razor"
self.Primary.Projectile = "projectile_grenade_ak103"
self.Primary.Projectile = "projectile_grenade_bouncy"
self.Primary.Projectile = "projectile_grenade_launcher"
self.Primary.Projectile = "projectile_juggernaut"
self.Primary.Projectile = "projectile_nova"
self.Primary.Projectile = "projectile_rocket"
self.Primary.Projectile = "projectile_stone"
self.Primary.Projectile = "projectile_tithonus"
self.Primary.Projectile = "projectile_chemball_generic"
self.Primary.Projectile = "projectile_wispball"
]]
--[[
self.Primary.Projectile = "projectile_zsgrenade"
self.Primary.Projectile = "projectile_zsmolotov"
self.Primary.Projectile = "projectile_corgasgrenade"
self.Primary.Projectile = "projectile_crygasgrenade"
self.Primary.Projectile = "projectile_flashbomb"
]]