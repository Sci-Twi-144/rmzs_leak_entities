ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "UpDMG", "Bool", 10)
AccessorFuncDT(ENT, "UpMoveSpeed", "Bool", 11)
AccessorFuncDT(ENT, "UpResist", "Bool", 12)

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	local enty = self
	local ENTC = tostring(enty)

	-- pl:SetHealth(pl:GetMaxZombieHealth())
	if SERVER then
		self:CreateSVHook(ENTC, enty)
	end

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(self) then return end
		
		if pl ~= enty:GetOwner() then return end
	
		if enty:GetUpMoveSpeed() then
			local zerospeed = move:GetMaxSpeed() > 0
			move:SetMaxSpeed(move:GetMaxSpeed() + (zerospeed and 12 or 0)) -- так трудно было сделать нахуй а не сувать ебаную проверку в think?
			move:SetMaxClientSpeed(move:GetMaxSpeed())
		end
	end)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:OnRemove()
	local ENTC = tostring(self)
	if SERVER then self:RemoveSVHook(ENTC) end
	hook.Remove("Move", ENTC)

	self.BaseClass.OnRemove(self)
end
