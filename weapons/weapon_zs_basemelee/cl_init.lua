include("shared.lua")

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ForceHideWeapon = true

function SWEP:TranslateFOV(fov)
	return GAMEMODE.FOVLerp * fov
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

local matGlow = Material("sprites/glow04_noz")
local texDownEdge = surface.GetTextureID("gui/gradient_down")

local lastperc = 1

function SWEP:DrawHUD()
	if not GAMEMODE.AlwaysDrawStamBar then
		self:DrawStaminaBar()
	end
	
	--if not self.NoDrawMeleeHudStates then
		--self:DrawParryWindow()
	--end
	self:DrawSpecialBar()
	self:DrawConditions()

	self:DrawAds()
	
	if not self.CantSwitchFireModes then
		self:DrawFireMode()
	end
	
	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawConditions()
	local fulltime = self.Primary.Delay * self:GetOwner():GetMeleeSpeedMul()
	
	GAMEMODE:DrawCircleEx(x, y, 17, self:IsHeavy() and COLOR_YELLOW or COLOR_DARKRED, self:GetNextPrimaryFire() , fulltime, 360)	
end

function SWEP:DrawAds()
end

local lastpercd = 1
local colBlock = Color(0, 0, 0, 0)
function SWEP:DrawSpecialBar()
	local screenscale = BetterScreenScale()
	basewid, hei = 280 * screenscale, 6 * screenscale
	wid = 280 * screenscale

	x = ScrW() / 2 - ( wid /2 )
	y = ScrH() * 0.60
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFontTiny")

	local timeleft = MySelf:GetGuardBreak() - CurTime()
	local damage = math.floor(MySelf:GetDamageBlocked())

	if 0 < timeleft or damage > 1 then
		local blocklimit = math.ceil((GAMEMODE.BlockLimit * (MySelf.BlockLimitMul or 1)) * (self.BlockStability or 1))
		local timem = 3 * (MySelf.GuardBreakDurMul or 1)
		local damageperc = math.Clamp(damage / blocklimit, 0, 1)
		local CoolDown = (0 < timeleft) and math.Clamp(timeleft / timem , 0, timem) or damageperc
		local subwidth = CoolDown * wid

		lastpercd = Lerp(FrameTime() * (CoolDown < lastpercd and 16 or 1.1), lastpercd, CoolDown)
		subwidth = lastpercd * wid
		
		colBlock.r =  CoolDown * 180
		colBlock.g = (1 - CoolDown) * 180
		colBlock.b = 0
		colBlock.a = math.Clamp(colBlock.a + (lastpercd >= 0.995 and -1.8 or 4.6) * FrameTime(),0,0.9)

		surface.SetDrawColor(0, 0, 0, 230 * colBlock.a)
		surface.DrawRect(x, y-7, wid, hei)

		surface.SetDrawColor(colBlock.r * 0.6, colBlock.g * 0.6, colBlock.b, 160 * colBlock.a)
		surface.SetTexture(texDownEdge)
		surface.DrawTexturedRect(x + 2, y - 7, subwidth - 4, hei - 2)
		surface.SetDrawColor(colBlock.r * 0.6, colBlock.g * 0.6, colBlock.b, 160 * colBlock.a)
		surface.DrawRect(x + 2, y - 7, subwidth - 4, hei - 2)

		surface.SetMaterial(matGlow)
		surface.SetDrawColor(255, 255, 255, 255 * colBlock.a)
		surface.DrawTexturedRect(x + 2 + subwidth - 6, y - 7 - hei/2, 3, hei * 2)
		
		if 0 < timeleft then
			draw.SimpleText(math.Round(timeleft, 2).." s", "ZSHUDFontTiny", x, texty-3, COLOR_GRAY, TEXT_ALIGN_LEFT)
		end
	end

end

function SWEP:DrawParryWindow()
	local owner = self:GetOwner()
	local tr = owner:CompensatedMeleeTrace(61, 1, nil, nil, false, true)
	local hitent = tr.Entity
	local screenscale = BetterScreenScale()

	basewid, hei = 280 * screenscale, 12 * screenscale
	wid = 280 * screenscale

	x = ScrW() / 2 - ( wid /2 )
	y = ScrH() * 0.60
	
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFontTiny")
	
	if tr.Hit and hitent:IsValidLivingZombie() and tr.HitPos:Distance(tr.StartPos) <= 61 then
		local wep = hitent:GetActiveWeapon()
		if wep and wep:IsValid() and wep.GetSwingEndTime then
			local endtime = wep:GetSwingEndTime()
			local curtime = CurTime()

			local window = math.max(0, (1.7 - (self.BlockStability or 1)) * 0.05) + 0.06
			if curtime > (endtime - window) and curtime < endtime then
				draw.SimpleText("BASH NOW", "ZSHUDFontTiny", x + wid * 0.6, texty, COLOR_CYAN, TEXT_ALIGN_RIGHT)
			end
		end
	end
end

function SWEP:DrawFireMode()
	local screenscale = BetterScreenScale()
	local wid, hei = 2 * 220 * screenscale, 19 * screenscale
	local x, y = ScrW() - wid - 32 * screenscale, ScrH() - hei - 18 * screenscale
	
	if not self.CantSwitchFireModes then
		draw.SimpleTextBlurry(self:DefineFireMode2D() or "", "ZSHUDFontSmall", x + wid * 0.5, y - hei * 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function SWEP:OnRemove()
	self:Anim_OnRemove()
end

function SWEP:ViewModelDrawn()
	self:Anim_ViewModelDrawn()
end

function SWEP:PreDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(0)
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end
end

local meta = FindMetaTable("Entity")
local E_GetTable = meta.GetTable

function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	local owner_valid = IsValid(owner)

	if not owner_valid then return end

	if FrameNumber() - (LastDrawFrame[owner] or 0) > 30 then return end
	if E_GetTable(owner).ShadowMan or SpawnProtection[owner] then return end
	if GAMEMODE.NoDrawHumanWeaponsAsZombie and MySelf and MySelf:Team() == TEAM_UNDEAD and owner:Team() == TEAM_HUMAN then return end
	if MySelf and owner ~= MySelf and owner:GetPos():DistToSqr(EyePos()) > (GAMEMODE.SCKWorldRadius or 250000) then return end

	self:Anim_DrawWorldModel()
end

function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	return pos, ang
end