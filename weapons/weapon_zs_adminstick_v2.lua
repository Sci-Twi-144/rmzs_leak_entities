if CLIENT then
	SWEP.PrintName = "Admin Stick"
	SWEP.Slot = 5
	SWEP.SlotPos = 100
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Base = "weapon_zs_basemelee"
 
SWEP.Author = ""
SWEP.Instructions = "Left click to unnail prop.\nRight click to remove prop."
SWEP.Contact = ""
SWEP.Purpose = ""
 
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"
 
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
 
SWEP.NextStrike = 0
 
SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.UseHands = true
 
SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = ""
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.Undroppable = true
SWEP.Ungiveable = true

function SWEP:Initialize()
	if SERVER then self:SetWeaponHoldType("normal") end
end

function SWEP:PrimaryAttack()
	if CurTime() < self.NextStrike then return end

	if SERVER then
		--self:SetWeaponHoldType("melee")
		timer.Simple(0.3, function(wep) if IsValid(wep) then wep:SetWeaponHoldType("normal") end end, self)
	end

	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)

	self:EmitSound(self.Sound)
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	local tr = util.TraceLine( {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 10000,
		filter = team.GetPlayers(owner:Team())
	} )
	local trent = tr.Entity

	if not IsValid(trent) then return end

	if CLIENT then
		MsgN(trent:GetClass())
		return
	end
	
	if SERVER then
		owner:PrintMessage( HUD_PRINTCONSOLE, "ent "..tostring(trent).." "..trent:GetClass().." "..trent:GetName().." "..tostring(trent:GetParent()) )
		--if trent:CreatedByMap() then
			PrintTableTo(owner,trent:GetKeyValues())
		--end
		owner:PrintMessage( HUD_PRINTCONSOLE, "Collision group:"..tostring(trent:GetCustomCollisionGroup() or trent:GetCollisionGroup()).." vsOwner: "..tostring(GAMEMODE:ShouldCollide(owner, trent)) )
	end

	if not util.IsValidPhysicsObject(trent, tr.PhysicsBone)
		or tr.Fraction == 0
		or trent:GetMoveType() ~= MOVETYPE_VPHYSICS and not trent:GetNailFrozen()
		or trent.NoNails
		or trent:GetMaxHealth() == 1 and trent:Health() == 0 and not trent.TotalHealth
		or not trent:IsNailed() and not trent:GetPhysicsObject():IsMoveable() then return end

	for _, ent in pairs(trent:GetNails()) do
		trent:RemoveNail(ent, nil, owner)
	end
end
 
function SWEP:SecondaryAttack()
	if CurTime() < self.NextStrike then return end

	if SERVER then
		--self:SetWeaponHoldType("melee")
		timer.Simple(0.3, function(wep) if IsValid(wep) then wep:SetWeaponHoldType("normal") end end, self)
	end

	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)

	self:EmitSound(self.Sound)
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	local tr = util.TraceLine( {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 10000,
		filter = team.GetPlayers(owner:Team())
	} )
	local trent = tr.Entity

	if not IsValid(trent) then return end

	if CLIENT then
		MsgN(trent:GetClass())
		return
	end
	
	if trent:IsPlayer() then
		trent:Kill()
	else
		trent:Remove()
	end
end