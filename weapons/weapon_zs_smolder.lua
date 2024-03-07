AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

-- Оружие в 3 ветку скара

SWEP.PrintName = (translate.Get("wep_smolder")) -- "'Smolder' Assault Rifle"
SWEP.Description = (translate.Get("desc_smolder")) -- "В режиме прицела, использует двойной выстрел с пониженной скорострельностью."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	
	-- killicon.AddFont("weapon_zs_smolder", "zsdeathnoticecs", "o") в cl_deathnotice

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1.3, -5.56, -2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_SG550.Single")
SWEP.Primary.Damage = 31.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.18

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 3
SWEP.ConeMin = 0.4

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 5

SWEP.ResistanceBypass = 0.55

SWEP.IronSightsPos = Vector(11, -9, -2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Primary.DefaultDamage = SWEP.Primary.Damage -- Вернуть урон в исходное
SWEP.Primary.DefaultDelay = SWEP.Primary.Delay -- Вернуть раздержку в исходное
SWEP.Primary.DoubleDamage = SWEP.Primary.Damage * 2
SWEP.Primary.IronsightsDelay = SWEP.Primary.Delay * 1.6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2, 1)

function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self.Primary.Damage = self.Primary.DoubleDamage
			self.Primary.Delay = self.Primary.IronsightsDelay

			self:EmitSound("Weapon_AR2.Special1", 40)
		else
			self.Primary.Damage = self.Primary.DefaultDamage
			self.Primary.Delay = self.Primary.DefaultDelay

			self:EmitSound("Weapon_AR2.Special2", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
end

function SWEP:CanPrimaryAttack()
	if self:GetIronsights() and self:Clip1() == 1 then
		self:SetIronsights(false)
	end

	return self.BaseClass.CanPrimaryAttack(self)
end

function SWEP:TakeAmmo()
	if self:GetIronsights() then
		self:TakePrimaryAmmo(2)
	else
		self.BaseClass.TakeAmmo(self)
	end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 100)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end

-- Ниже идет кастомая сетка для прицела, оставил если она пригодиться

-- if CLIENT then

	-- SWEP.IronsightsMultiplier = 0.25
	
	-- function SWEP:GetViewModelPosition(pos, ang)
		-- if GAMEMODE.DisableScopes then return end

		-- if self:IsScoped() then
			-- return pos + ang:Up() * 256, ang
		-- end

		-- return BaseClass.GetViewModelPosition(self, pos, ang)
	-- end

	-- function SWEP:DrawHUDBackground()
		-- if GAMEMODE.DisableScopes then return end

		-- if self:IsScoped() then
			-- self:DrawScopes() -- Отображение самой сетки, должна находиться до текстуры круга
			-- self:DrawRegularScope()
			-- self.ScopeStatus = 1 -- Выключает основной прицел
			-- else
			-- self.ScopeStatus = 0 -- Включает его обратно
		-- end
	-- end
-- end

-- function SWEP:DrawHUD()

	-- if self.ScopeStatus == 0 then -- Та самая проверка на прицел
	-- self:DrawWeaponCrosshair()
	-- end

	-- if GAMEMODE:ShouldDraw2DWeaponHUD() then
		-- self:Draw2DHUD()
	-- end
-- end

-- function SWEP:DrawScopes()
-- -- No crosshair when ironsights is on
	-- if ( self.Weapon:GetNWBool( "Ironsights" ) ) then return end

	-- local x, y -- local, always

	-- -- If we're drawing the local player, draw the crosshair where they're aiming
	-- -- instead of in the center of the screen.
	-- if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then
		-- local tr = util.GetPlayerTrace( self.Owner )
		-- tr.mask = ( CONTENTS_SOLID+CONTENTS_MOVEABLE+CONTENTS_MONSTER+CONTENTS_WINDOW+CONTENTS_DEBRIS+CONTENTS_GRATE+CONTENTS_AUX ) -- List the enums that should mask the crosshair on camrea/thridperson
		-- local trace = util.TraceLine( tr )
		
		-- local coords = trace.HitPos:ToScreen()
		-- x, y = coords.x, coords.y

	-- else
		-- x, y = ScrW() / 2.0, ScrH() / 2.0 -- Center of screen
	-- end
	
	-- local scale = 5
	-- local LastShootTime = self.Weapon:GetNWFloat( "LastShootTime", 0 )
        -- -- Scale the size of the crosshair according to how long ago we fired our weapon
	-- scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	-- --                    R   G    B  Alpha
	-- surface.SetDrawColor( 0, 0, 0, 255 ) -- Sets the color of the lines we're drawing
	
-- -- Draw a crosshair
	-- local gap = 0 -- Пространство для основного прицела
	-- local gap2 = 150 -- Пространство для толстых линий
	-- local length = gap + 500 * scale -- основная сетка прицела
	-- local length2 = gap + 1 * scale -- для маленьких линий
	-- local length3 = gap + 2 * scale -- для больших линий
	-- surface.DrawLine( x - length, y, x - gap, y )
	-- surface.DrawLine( x + length, y, x + gap, y )
	-- surface.DrawLine( x, y - length, x, y - gap )
	-- surface.DrawLine( x, y + length, x, y + gap )

	-- -- Основной крест прицела

	-- for f=-2, 2, 1 do
		-- surface.DrawLine( x - length, y+f, x - gap2, y+f )
		-- surface.DrawLine( x + length, y+f, x + gap2, y+f )
		-- surface.DrawLine( x+f, y - length, x+f, y - gap2 )
		-- surface.DrawLine( x+f, y + length, x+f, y + gap2 )
	-- end -- Толстые линии на конце
	
	-- for i=-100, 100, 50 do
		-- surface.DrawLine( x - length3, y-i, x - gap, y-i )
		-- surface.DrawLine( x + length3, y-i, x + gap, y-i )
		-- surface.DrawLine( x-i, y - length3, x-i, y - gap )
		-- surface.DrawLine( x-i, y + length3, x-i, y + gap )
	-- end -- линии вдоль прицела (большие)
	
	-- for i=-100, 125, 25 do
		-- surface.DrawLine( x - length2, y-i, x - gap, y-i )
		-- surface.DrawLine( x + length2, y-i, x + gap, y-i )
		-- surface.DrawLine( x-i, y - length2, x-i, y - gap )
		-- surface.DrawLine( x-i, y + length2, x-i, y + gap )
	-- end -- линии вдоль прицела (маленькие)

	-- surface.DrawOutlinedRect( x, y, 1, 1 )
	-- surface.SetDrawColor(10,127,20,5)
	-- surface.DrawRect( 1, 1, 200000, 200000 ) -- Зеленоватый квадрат на весь экран, чтобы видеть прицел в полной темноте
-- end
