ENT.Type = "anim"
ENT.Base = "status__base"

ENT.TimeForAccumulation = 0
ENT.TimeWhenShieldStartsToDecrease = 0
ENT.Timer1lost = false

AccessorFuncDT(ENT, "Magnitude", "Int", 5)

local matDef = Material("zombiesurvival/defense.png")

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	
	local ent = self
	local ENTC = tostring(ent)
	
	if CLIENT then		
		hook.Add("PostDrawHUD", ENTC, function()
			if MySelf ~= ent:GetOwner() then return end
			if ent:GetMagnitude() <= 0 then return end
			local screenscale = BetterScreenScale()
			local x = ScrW() * 0.5
			local y = ScrH() * 0.7
			local wid, hei = 200 * screenscale, 20 * screenscale
			x = x - wid/2
			y = y - hei/2
			x = x + 1
			y = y + 1
			local color = Color(0, 125, 255, 220)

			surface.SetDrawColor(color)
			surface.SetMaterial(matDef)
			surface.DrawTexturedRect(x * 1.033, y * 0.92, wid - 50, hei + 80)
			draw.SimpleText(ent:GetMagnitude(), "ZSHUDFont", x + (wid-2) * 0.5, y + hei * -0.5, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end )
	end
end

function ENT:Think()
	local owner = self:GetOwner()

	if self.TimeForAccumulation < CurTime() then
		self.TimeForAccumulation = 99999
		owner.RedMarrowShielded = false
		owner:SetZombieShield(owner.RedMarrowShieldAccu)
		self:SetMagnitude(0)
		self.Timer1lost = true
	end

	if self.TimeWhenShieldStartsToDecrease < CurTime() then
		owner:SetZombieShield(math.max(owner:GetZombieShield() - owner:GetZombieShield() * 0.1), 0)
		if owner:GetZombieShield() <= 15 then 
			self:Remove()
		end
	end

    if not self.Timer1lost then
		self:SetMagnitude(owner.RedMarrowShieldAccu)
    end

	if not (owner:IsValidLivingZombie() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Red Marrow") or (self.Timer1lost and (owner:GetZombieShield() <= 0)) then
		self:Remove()
	end
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.RedMarrowShielded = true
	pPlayer.RedMarrowShieldAccu = 0

	self.TimeForAccumulation = CurTime() + 6
	self.TimeWhenShieldStartsToDecrease = self.TimeForAccumulation + 5
end 

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner:SetZombieShield(0)
end