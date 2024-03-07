AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_marksman"))
SWEP.Description = (translate.Get("desc_marksman"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Python"
	SWEP.HUD3DPos = Vector(0, -1, -4)
	SWEP.HUD3DScale = 0.015
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "COIN"
		elseif self:GetFireMode() == 1 then
			return "S-COIN"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Throw Coin"
		elseif self:GetFireMode() == 1 then
			return "Special Coin"
		end
	end
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), self.ResCap, "S-COIN")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), self.ResCap, "S-COIN")
	end
	
	function SWEP:Draw2DHUDAds(x, y, hei, wid)
		local maxcoins, coinsleft = 3, self:GetCoins()
		draw.SimpleTextBlurry(coinsleft.." / "..maxcoins, "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(188, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUDAds(x, y, hei, wid)
		local maxcoins, coinsleft = 3, self:GetCoins()
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * 0.92, wid, 34)
		draw.SimpleTextBlurry(coinsleft.."/"..maxcoins, "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(188, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	SWEP.VElements = {
		["Bul1++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet3", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} },
		["Bul1+++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet4", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "Python", rel = "", pos = Vector(-0.408, 4.866, -4.927), angle = Angle(0, 0, -79.383), size = Vector(0.035, 0.046, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Bul1+++++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet6", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} },
		["Trigger"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "Python", rel = "", pos = Vector(0, -1.301, 2.982), angle = Angle(0, -90, -180), size = Vector(0.071, 0.119, 0.152), color = Color(103, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Train"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "Python", rel = "", pos = Vector(0, 0.324, 2.776), angle = Angle(180, 0, -90), size = Vector(0.014, 0.017, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Stvol"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "Python", rel = "", pos = Vector(0, 1.047, 5), angle = Angle(90, 0, -90), size = Vector(0.013, 0.013, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "Cylinder", rel = "", pos = Vector(0, 0, -0.218), angle = Angle(0, 0, 0), size = Vector(0.043, 0.043, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Bul1"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = false, material = "lights/white", skin = 0, bodygroup = {} },
		["Bul1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} },
		["Bul1++++"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "Bullet5", rel = "", pos = Vector(0, 0, 1.282), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["handle"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.861, 0.628, 2.407), angle = Angle(180, 85.932, 6.131), size = Vector(0.035, 0.046, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Trigger"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.522, 0.961, -4.672), angle = Angle(87.622, 0, 0), size = Vector(0.142, 0.133, 0.156), color = Color(103, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Train"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.692, 0.847, -3.471), angle = Angle(-180, -90, 4), size = Vector(0.014, 0.017, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Stvol"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.218, 0.888, -6.088), angle = Angle(-4, 0, 0), size = Vector(0.014, 0.012, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.774, 1.042, -3.766), angle = Angle(-94, 0, 0), size = Vector(0.043, 0.043, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Bul1"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.725, 1.605, -3.77), angle = Angle(-94, 0, 0), size = Vector(0.07, 0.07, 0.043), color = Color(0, 255, 255, 255), surpresslightning = false, material = "lights/white", skin = 0, bodygroup = {} },
		["Bul1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.774, 0.159, -3.724), angle = Angle(-94, 0, 0), size = Vector(0.07, 0.07, 0.043), color = Color(0, 255, 255, 255), surpresslightning = true, material = "lights/white", skin = 0, bodygroup = {} }
	}
	
	function SWEP:PostDrawViewModel(vm)
		local greeny, speciality = Color(0, 255, 255), Color(188, 255, 0)
		if self:GetFireMode() == 1 then
			self.VElements["Bul1"].color = greeny
			self.VElements["Bul1+"].color = greeny
			self.VElements["Bul1++"].color = greeny
			self.VElements["Bul1+++"].color = greeny
			self.VElements["Bul1++++"].color = greeny
			self.VElements["Bul1+++++"].color = greeny
			self.VElements["Trigger"].color = Color(100, 255, 255)
		else
			self.VElements["Bul1"].color = speciality
			self.VElements["Bul1+"].color = speciality
			self.VElements["Bul1++"].color = speciality
			self.VElements["Bul1+++"].color = speciality
			self.VElements["Bul1++++"].color = speciality
			self.VElements["Bul1+++++"].color = speciality
			self.VElements["Trigger"].color = Color(188, 255, 100)
		end
		self.BaseClass.PostDrawViewModel(self, vm)
	end
	function SWEP:EmitFireSound()
		self:EmitSound("weapons/zs_longarm/longarm_fire.ogg", 75, math.random(81, 85), 0.8)
		self:EmitSound("weapons/galil/galil-1.wav", 75, math.random(142, 148), 0.7, CHAN_WEAPON + 20)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.6

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.93
SWEP.ConeMin = 0.41

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

SWEP.TracerName = "tracer_piercer"
SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.HasAbility = true
SWEP.ResCap = 1200
SWEP.CoinRecharge = 2.25
SWEP.Cringe = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.46, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.22, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetCoins(3)
end

function SWEP:Deploy()
	if self:GetCoins() < 3 then
		local holstertime = CurTime() - (self:GetCoinRecharge() - self.CoinRecharge)
		local coinsholster = holstertime > 0 and (math.floor(holstertime / self.CoinRecharge)) or 0
		self:SetCoins(math.min(self:GetCoins() + coinsholster, 3))
		if self:GetCoins() < 3 and coinsholster > 0 then
			self:SetCoinRecharge(self:GetCoinRecharge() + holstertime + self.CoinRecharge * (holstertime/self.CoinRecharge - coinsholster))
		end
	end
	self.BaseClass.Deploy(self)	
	return true
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:SecondaryAttack()
	if self.Cringe > CurTime() then return end
	self.Cringe = CurTime() + 0.28
	if self:GetPrimaryAmmoCount() < 6 or self:GetReloadFinish() > 0 then return false end
	if self:GetFireMode() == 0 then
		if self:GetCoins() > 0 then
			--self:SetBoom(false)
			
			if self:GetCoins() == 3 then
				self:SetCoinRecharge(CurTime() + self.CoinRecharge)
			end

			if SERVER then
				self:GetOwner():RemoveAmmo(3, self.Primary.Ammo)
			end
			
			if CLIENT then
				VManip:PlayAnim("throw_coin_v1")
			end

			self:SetCoins(self:GetCoins() - 1)
			self:ThrowCoin(false)
			self:EmitSound("physics/metal/soda_can_impact_hard1.wav", 75, math.random(80, 90), 0.8)
		end
	elseif self:GetFireMode() == 1 then
		if self:GetCoins() > 0 and self:GetResource() >= self.ResCap then
			
			if self:GetCoins() == 3 then
				self:SetCoinRecharge(CurTime() + self.CoinRecharge)
			end
			
			self:SetResource(0)
			--self:SetResource(self:GetResource() - 600)
			self:SetCoins(self:GetCoins() - 1)
			if CLIENT then
				VManip:PlayAnim("throw_coin_v1")
			end
			self:ThrowCoin(true)
			self:EmitSound("physics/metal/soda_can_impact_hard1.wav", 75, math.random(80, 90), 0.8)
		end
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)

	--[[if self:GetFireMode() == 1 then
		self:ProcessCharge()
	end]]
	
	if self:GetCoins() < 3 then
		if self:GetCoinRecharge() < CurTime() then
			self:SetCoins(self:GetCoins() + 1)
			self:SetCoinRecharge(CurTime() + self.CoinRecharge)
		end
	end

end

function SWEP:ThrowCoin(special)
	local owner = self:GetOwner()
	
	if special then
		self:SetTumbler(true)
	end
	
	if SERVER then
		local ent = ents.Create("projectile_coin")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos() + owner:GetAimVector():GetNormalized() * 20)
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjSource = self
			ent.Team = owner:Team()
			ent.MyInflictor = self
			ent.Special = special and true or false

			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()

				local angle = owner:GetAimVector():Angle()
				local throwangle = special and angle:Forward() or (angle:Forward() * 2 + Vector(0, 0, 1))
				local forcemul = self:GetOwner():KeyDown(IN_DUCK) and 0.5 or 1
				angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
				angle:RotateAroundAxis(angle:Up(), math.Rand(-self:GetCone(), self:GetCone()))
				phys:SetVelocityInstantaneous(throwangle * 220 * (owner.ProjectileSpeedMul or 1) * forcemul + owner:GetVelocity() * forcemul)
			end
		end
	end
end

function SWEP:SetBoom(boom)
	self:SetDTBool(15, boom)
end

function SWEP:GetBoom()
	return self:GetDTBool(15)
end

function SWEP:SetCoins(coins)
	self:SetDTInt(15, coins)
end

function SWEP:GetCoins()
	return self:GetDTInt(15)
end

function SWEP:SetCoinRecharge(timer)
	self:SetDTFloat(15, timer)
end

function SWEP:GetCoinRecharge()
	return self:GetDTFloat(15)
end