--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:SecondaryHands(remove)
	timer.Simple(0, function() -- ofc we forgot about hand setup on spawn! so i moved it to next frame and error fixed
		if self and self:IsValid() then
			if remove then
				local oldhands = self:GetOwner():GetSecondaryHands()
				if IsValid(oldhands) then
					oldhands:Remove()
				end
			else
				local oldhands = self:GetOwner():GetSecondaryHands()
				if IsValid(oldhands) then
					oldhands:Remove()
				end

				local hands = ents.Create("zs_hands")
				if hands:IsValid() then
					hands.Initialize = function(self)
						hook.Add( "OnViewModelChanged", tostring(self), function( vm, old, new )
							if not IsValid(self) then return end
							-- Ignore other peoples viewmodel changes!
							if vm:GetOwner() ~= self:GetOwner() then return end

							self:AttachToViewmodel(self:GetOwner():GetViewModel(1))
						end)

						self:SetNotSolid( true )
						self:DrawShadow( false )
						self:SetTransmitWithParent( true ) -- Transmit only when the viewmodel does!
					end

					hands.OnRemove = function(self)
						hook.Remove( "OnViewModelChanged", tostring(self))
					end

					hands.DoSetup = function(self, ply)
						ply:SetSecondaryHands( self )

						self:SetOwner( ply )

						-- Which hands should we use?
						local info = GAMEMODE:GetHandsModel( ply )
						if ( info ) then
							self:SetModel( info.model )
							self:SetSkin( info.skin )
							self:SetBodyGroups( info.body )
						end

						-- Attach them to the viewmodel
						local vm = ply:GetViewModel(1)
						self:AttachToViewmodel( vm )

						vm:DeleteOnRemove( self )
						ply:DeleteOnRemove( self )
					end

					hands:DoSetup(self:GetOwner())
					hands:Spawn()
				end
			end

			-- Hack Fix! OnViewModelChanged doesn't work at deploy "pickup!" but serverside allowed that!
			if self:IsValid() then
				self:GetOwner():GetHands():AttachToViewmodel(self:GetOwner():GetViewModel(0))
				self:GetOwner():GetSecondaryHands():AttachToViewmodel(self:GetOwner():GetViewModel(1))
			end
		end
	end)
end

function SWEP:OnZombieDed(zombie)
	local attacker = self:GetOwner()
	--local tiermul = 1 + ((6 - self.Tier or 1) * 0.2)
	
	if attacker:IsValid() then
		-- just reserved this
		--[[if attacker.TrinketReaperInf then
			if math.random() <= (attacker.ReaperChance * (self.IsAoe and 0.5 or 1) * tiermul) then
				local status = attacker:GiveStatus("reaper", 10)
				if status and status:IsValid() then
					status:SetStacks(math.min(status:GetStacks() + 1, attacker.ReaperStackMul))
				end
			end
		end
		
		if attacker.TrinketHeadbonk then
			if math.random() <= (attacker.HeadBonkChance * (self.IsAoe and 0.5 or 1) * tiermul) and zombie:WasHitInHead() then
				attacker:GiveStatus("renegade", 10)
			end
		end
		
		if attacker.TrinketFFTotem then
			if math.random() <= (attacker.FFTotemChance * (self.IsAoe and 0.5 or 1) * tiermul) then
				local status = attacker:GiveStatus("fftotem", 10)
				if status and status:IsValid() then
					status:SetStacks(math.min(status:GetStacks() + 1, attacker.FFTotemStackMul))
				end
			end
		end
		
		if attacker.TrinketMuscularStimulator then
			if math.random() <= (attacker.MStimChance * (self.IsAoe and 0.5 or 1) * tiermul) then
				local status = attacker:GiveStatus("fasthand", 15)
				if status and status:IsValid() then
					status:SetStacks(math.min(status:GetStacks() + 1, attacker.MStimStackMul))
				end
			end
		end
		
		if attacker.TrinketPerceptionAccumulator then
			if math.random() <= (attacker.PAccuChance * (self.IsAoe and 0.5 or 1) * tiermul) then
				local status = attacker:GiveStatus("focused", 15)
				if status and status:IsValid() then
					status:SetStacks(math.min(status:GetStacks() + 1, attacker.PAccuStackMul))
				end
			end
		end]]
		
		if attacker.TrinketResupplyKill then -- wut???
			rawset(PLAYER_NextResupplyUse, attacker, rawget(PLAYER_NextResupplyUse, attacker) - math.ceil(zombie:GetMaxHealth() * 0.02))
			net.Start("zs_nextresupplyuse")
			net.WriteFloat(rawget(PLAYER_NextResupplyUse, attacker))
			net.Send(attacker)
		end
	end
end