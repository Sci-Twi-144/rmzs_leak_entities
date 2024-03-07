include("shared.lua")
include("cl_animations.lua")

ENT.ColorModulation = Color(1, 0.5, 0)

function ENT:Think()
	local itype = self:GetInventoryItemType()
	if itype ~= self.LastInvItemType then
		self.LastInvItemType = itype

		self:RemoveModels()

		local invdata = GAMEMODE.ZSInventoryItemData[itype]
 
		if invdata then
			local droppedeles = invdata.DroppedEles
			--local showmdl = --weptab.ShowWorldModel or not self:LookupBone("ValveBiped.Bip01_R_Hand") and not weptab.NoDroppedWorldModel
			self.ShowBaseModel = not istable(droppedeles)--weptab.ShowWorldModel == nil and true or showmdl

			if istable(droppedeles) then
				self.WElements = table.FullCopy(droppedeles)
				self:CreateModels(self.WElements)
			end

			self.ColorModulation = invdata.DroppedColorModulation or self.ColorModulation
			self.PropWeapon = true
			self.QualityTier = invdata.QualityTier
			self.PrintName =  invdata.QualityTier and invdata.PrintName or (translate.Get(invdata.PrintName) or "Invalid Trinket")
			self.WepClass = invdata.Icon or "weapon_zs_trinket" --itypesw
		end
	end
end

function ENT:OnRemove()
	self:RemoveModels()
end
