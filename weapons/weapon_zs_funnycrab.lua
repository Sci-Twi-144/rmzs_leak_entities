AddCSLuaFile()

SWEP.Base = "weapon_zs_headcrab"

SWEP.Primary.Delay = 0.4

SWEP.PounceDamage = 6
SWEP.PounceDamageType = DMG_SLASH
SWEP.BiteReach = 11

SWEP.NoHitRecovery = 0.75
SWEP.HitRecovery = 1

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
        ent.FunnyCrabLastBite = CurTime()
        if ent.FunnyCrabLastBite <= (CurTime() + 3) then
            ent.FunnyCrabBiteCount = ent.FunnyCrabBiteCount + 1
        else
             ent.FunnyCrabBiteCount = 0
        end
        if ent.FunnyCrabBiteCount >= 3 then
			ent:ApplyZombieDebuff("anchor", 3, {Applier = self:GetOwner()}, true, 34)
        end
	end
end

function SWEP:Reload()
end