include("shared.lua")

ENT.ColorModulation = Color(0.25, 1, 0.25)

function ENT:Think()
	local ammotype = self:GetAmmoType()
	if ammotype ~= self.LastAmmoItemType then
		self.LastAmmoItemType = ammotype

       -- self.AmmoNames

		local ammodata = GAMEMODE.AmmoNames[ammotype]
		if ammodata then
            --print(GAMEMODE.AmmoIcons[ammotype][2])
			self.ColorModulation = GAMEMODE.AmmoIcons[ammotype][2]
			self.IsAmmo = true
			self.PrintName = ammodata or "Unknown Ammo"
			self.WepClass = ammotype or "weapon_zs_trinket"
		end
	end
end