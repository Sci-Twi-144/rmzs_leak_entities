--[[SECURE]]--

ENT.Type = "point"

local SF_PLAYEREQUIP_USEONLY = 1
local MAX_EQUIP = 32
local EquipList = {}
local bHooked = false

function ENT:Initialize()
	self.m_UseOnly = self.m_UseOnly or false
	if not self.m_UseOnly then
		EquipList[self] = true
		
		if not bHooked then
			bHooked = true
			hook.Add( "PostPlayerSpawn", "PostPlayerSpawn.Game_Equip_", function(pl)
				if pl:Team()==TEAM_HUMAN then
					for eq, vl in pairs(EquipList) do
						eq:CheckEquip(pl)
					end
				end
			end)
		end
	end
end

function ENT:OnRemove()
	EquipList[self] = nil
end

function ENT:AcceptInput(name, activator, caller, data)
	if string.lower(name)=="use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
		self:EquipPlayer(activator)
	end
	return true
end

local RenameWeapons = {
	["weapon_hegrenade"]="weapon_zs_zegrenade",
	["weapon_knife"]="weapon_zs_zeknife",
	["weapon_elite"]="weapon_zs_zepeashooter",
}

local KVIgnore = {'origin','targetname','classname','hammerid'}
function ENT:KeyValue( key, value )
	if table.HasValue(KVIgnore,key) then return false end

	if key == "spawnflags" then

		local flags = tonumber(value)
		if flags and bit.band(flags,SF_PLAYEREQUIP_USEONLY)~=0 then
			self.m_UseOnly = true
		end

		return true
		
	end

	if !self.BaseClass.KeyValue(self,key,value) then
		
		if !self.m_weapons then
			self.m_weapons = {}
		end

		key = string.lower(key)
		local nk = RenameWeapons[key]
		if nk then
			key = nk
		end
		
		if string.StartsWith(key,"ammo_") then
			key = "ammo"
		end
		table.insert(self.m_weapons,key)
		return true

	end

	return false
end

function ENT:CheckEquip( ply )
	if not self:CheckPassesFilter(ply) then return end
	self:EquipPlayer(ply)
end

function ENT:EquipPlayer( pEntity )
	if !IsValid(pEntity) or !pEntity:IsPlayer() then return end

	for i=1, #self.m_weapons do
		local item = self.m_weapons[i]
		if item=="item_kevlar" then
			pEntity:SetArmor(100)
		elseif item=="ammo" then
			local wp = pEntity:GetActiveWeapon()
			if IsValid(wp) and wp.Primary and wp.Primary.ClipSize then
				wp:SetClip1(wp.Primary.ClipSize)
			end
		else
			pEntity:Give( item )
		end
	end
end