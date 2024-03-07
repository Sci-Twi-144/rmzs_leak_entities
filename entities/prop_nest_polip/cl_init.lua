include("shared.lua")

ENT.ShieldNum = 0
ENT.Timer2 = 0
ENT.Timer3 = 0
ENT.HideIt = true

local EmitSounds = {
	Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard2.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard3.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard4.wav"),
	Sound(")npc/barnacle/barnacle_die1.wav"),
	Sound(")npc/barnacle/barnacle_die2.wav"),
	Sound(")npc/barnacle/barnacle_digesting1.wav"),
	Sound(")npc/barnacle/barnacle_digesting2.wav"),
	Sound(")npc/barnacle/barnacle_gulp1.wav"),
	Sound(")npc/barnacle/barnacle_gulp2.wav")
}

function ENT:Initialize()
    ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, -40, 2))
        ent:SetLocalAngles(angle_zero + Angle(0, 90, 0))
        ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2, 1.35, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase = ent
    end

    ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 40, 2))
        ent:SetLocalAngles(angle_zero + Angle(0, 270, 0))
        ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2, 1.35, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase2 = ent
    end

    ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, 2))
        ent:SetLocalAngles(angle_zero + Angle(0, 270, 0))
        ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2, 1.35, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase3 = ent
    end

    ent = ClientsideModel("models/gibs/strider_gib1.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 20, 45))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 90))
        ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(0.5, 1, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase4 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(35, 5, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, 90, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase5 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(20, 35, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, 135, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase6 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(20, -25, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, 45, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase7 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-35, -5, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, -90, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase8 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-20, -35, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, -45, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase9 = ent
    end

    ent = ClientsideModel("models/gibs/hgibs_spine.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-20, 25, 15))
        ent:SetLocalAngles(angle_zero + Angle(0, -135, -35))
        --ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(2.5, 1.5, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase10 = ent
    end
end

function ENT:Think()

    if self.Timer3 < CurTime() then
		self.Timer3 = CurTime() + 1
        self:EmitSound(EmitSounds[math.random(#EmitSounds)], 65, math.random(95, 105))
    end

    if self.Timer2 < CurTime() then
		self.Timer2 = CurTime() + 0.1

        local atch = self.SelfBase5
        local atch2 = self.SelfBase6
        local atch3 = self.SelfBase7
        local atch4 = self.SelfBase8
        local atch5 = self.SelfBase9
        local atch6 = self.SelfBase10
        matrix = Matrix()

        if self:GetShield() then
            self.ShieldNum = math.min(self.ShieldNum + 0.5, 15)
            matrix:Scale(Vector(2.5, 1.5, 5))
            atch:EnableMatrix("RenderMultiply", matrix)
            atch2:EnableMatrix("RenderMultiply", matrix)
            atch3:EnableMatrix("RenderMultiply", matrix)
            atch4:EnableMatrix("RenderMultiply", matrix)
            atch5:EnableMatrix("RenderMultiply", matrix)
            atch6:EnableMatrix("RenderMultiply", matrix)

            local pos = atch:GetLocalPos()
            pos.z = self.ShieldNum
            atch:SetLocalPos(pos)

            local pos2 = atch2:GetLocalPos()
            pos2.z = self.ShieldNum
            atch2:SetLocalPos(pos2)

            local pos3 = atch3:GetLocalPos()
            pos3.z = self.ShieldNum
            atch3:SetLocalPos(pos3)

            local pos4 = atch4:GetLocalPos()
            pos4.z = self.ShieldNum
            atch4:SetLocalPos(pos4)

            local pos5 = atch5:GetLocalPos()
            pos5.z = self.ShieldNum
            atch5:SetLocalPos(pos5)

            local pos6 = atch6:GetLocalPos()
            pos6.z = self.ShieldNum
            atch6:SetLocalPos(pos6)

        elseif not self:GetShield() then
            self.ShieldNum = math.max(self.ShieldNum - 0.5, -15)
            if self.ShieldNum == -15 then
                self.HideIt = true 
            else
                self.HideIt = false
            end
            local bool = self.HideIt and 0 or 5
            matrix:Scale(Vector(2.5, 1.5, bool))
            atch:EnableMatrix("RenderMultiply", matrix)
            atch2:EnableMatrix("RenderMultiply", matrix)
            atch3:EnableMatrix("RenderMultiply", matrix)
            atch4:EnableMatrix("RenderMultiply", matrix)
            atch5:EnableMatrix("RenderMultiply", matrix)
            atch6:EnableMatrix("RenderMultiply", matrix)

            local pos = atch:GetLocalPos()
            pos.z = self.ShieldNum
            atch:SetLocalPos(pos)

            local pos2 = atch2:GetLocalPos()
            pos2.z = self.ShieldNum
            atch2:SetLocalPos(pos2)

            local pos3 = atch3:GetLocalPos()
            pos3.z = self.ShieldNum
            atch3:SetLocalPos(pos3)

            local pos4 = atch4:GetLocalPos()
            pos4.z = self.ShieldNum
            atch4:SetLocalPos(pos4)

            local pos5 = atch5:GetLocalPos()
            pos5.z = self.ShieldNum
            atch5:SetLocalPos(pos5)

            local pos6 = atch6:GetLocalPos()
            pos6.z = self.ShieldNum
            atch6:SetLocalPos(pos6)
        end
    end
end

function ENT:OnRemove()
    self.SelfBase:Remove()
    self.SelfBase2:Remove()
    self.SelfBase3:Remove()
    self.SelfBase4:Remove()
    self.SelfBase5:Remove()
    self.SelfBase6:Remove()
    self.SelfBase7:Remove()
    self.SelfBase8:Remove()
    self.SelfBase9:Remove()
    self.SelfBase10:Remove()
end