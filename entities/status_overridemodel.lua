AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
    self:SetRenderMode(RENDERMODE_TRANSALPHA)

    local pPlayer = self:GetOwner()
    if pPlayer:IsValid() then
        pPlayer.status_overridemodel = self
        if SERVER then
            if pPlayer:Team() ~= TEAM_UNDEAD or pPlayer:GetZombieClassTable().HideMainModel then
                pPlayer:SetRenderMode(RENDERMODE_NONE)
            else
                pPlayer:SetRenderMode(RENDERMODE_NORMAL)
            end
        end
    end
end

function ENT:PlayerSet(pPlayer, bExists)
    if SERVER then
        if pPlayer:Team() ~= TEAM_UNDEAD or pPlayer:GetZombieClassTable().HideMainModel then
            pPlayer:SetRenderMode(RENDERMODE_NONE)
        else
            pPlayer:SetRenderMode(RENDERMODE_NORMAL)
        end
    end
end

function ENT:OnRemove()
    local pPlayer = self:GetOwner()
    if SERVER and pPlayer:IsValid() then
        pPlayer:SetRenderMode(RENDERMODE_NORMAL)
    end
end

function ENT:Think()
end

if CLIENT then
	local M_Player = FindMetaTable("Player")
	local M_Entity = FindMetaTable("Entity")

	local E_IsValid = M_Entity.IsValid
	local E_GetTable = M_Entity.GetTable

	local P_Team = M_Player.Team

	function ENT:Draw()
		local owner = self:GetOwner()

		if owner == MySelf and not MySelf:ShouldDrawLocalPlayer() then
			return
		end

		if E_IsValid(owner) and owner:Alive() then
			local opaque = true
			local pcolor = owner:GetColor()
			if SpawnProtection[owner] then
				pcolor.a = (0.02 + (CurTime() + self:EntIndex() * 0.2) % 0.05) * 255
				pcolor.r = 0
				pcolor.b = 0
				pcolor.g = 255
				render.SuppressEngineLighting(true)
				if not owner.Transparency then
					hook.Run("PlayerAlphaChanged", owner, 0)
				end
				owner.Transparency = 0
				opaque = false
			end
			self:SetColor(pcolor)

			local owner_tb = E_GetTable(owner)
			local class_tb = GAMEMODE.ZombieClasses[owner_tb.Class or 1]

			if 	not (SpawnProtection[owner] and class_tb.HideMainModel) and
				not owner:CallZombieFunction1("PrePlayerDrawOverrideModel", self) then

				local radius = GAMEMODE.TransparencyRadius

				local draw_model = true
				if owner ~= MySelf and P_Team(MySelf) == TEAM_UNDEAD then
					local dist = owner:GetPos():DistToSqr(EyePos())
					if dist < radius then
						local blend = (dist / radius) ^ 1.4
						if blend <= 0.1 then
							draw_model = false
							blend = 0
						end

						if owner_tb.Transparency ~= blend then
							hook.Run("PlayerAlphaChanged", owner, blend)
						end
						owner_tb.Transparency = blend
						opaque = false

						render.SetBlend(blend)
					end
				end

				if draw_model and blend ~= 0 then
					LastDrawFrame[owner] = FrameNumber()
					self:DrawModel()
				end

				owner:CallZombieFunction1("PostPlayerDrawOverrideModel", self)
			end

			if SpawnProtection[owner] then
				render.SuppressEngineLighting(false)
			end

			if opaque and owner_tb.Transparency then
				owner_tb.Transparency = nil
				hook.Run("PlayerAlphaChanged", owner, 1)
			end
		end
	end
	ENT.DrawTranslucent = ENT.Draw
end