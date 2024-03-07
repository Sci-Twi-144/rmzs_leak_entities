SWEP.PrintName = "Sigil Placer"

--Instructions are also printed on the HUD in SWEP:DrawHUD()
SWEP.Instructions = [[
PRIMARY FIRE = Place Sigil
PRIMARY FIRE (on sigil) = Edit Sigil
SECONDARY FIRE = Remove sigil

SPRINT+RELOAD = Load map-placed sigils
RELOAD (hold) = Clear premade sigils
RELOAD (hold longer) = Clear ALL sigils
]]

local kv = { --These contain ZS gamemode variables after the sigil loads, they are not the mapping KVs, this is important!!
	["ForceSpawn"] = "Boolean",
	["DisableTeleports"] = "Boolean",
	["SigilGroup"] = "Generic",
	["NoCrate"] = "Boolean",
}

local instructions = [[
GUI Controls:
ForceSpawn: If checked, sigil will always spawn
DisableTeleports: If checked, Disables teleporting to and from sigil
SigilGroup: Defines a group the sigil will be considered a part of, unused without a configured info_sigilgroup
NoCrate: If checked, disables this sigil as a candidate for the PointSave sigil
]]

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.PermitDismantle = true
SWEP.DismantleScrap = 0

local function CanPlace(pl)
	return pl:IsValid() and (pl:IsSuperAdmin() or pl:IsAdmin())
end

function SWEP:Initialize()
	if SERVER then
		self:RefreshSigils()
	elseif MySelf == self:GetOwner() then --is this check needed?
		MySelf:ChatPrint("See console for extra instructions!")
		print(instructions)
	end
end

function SWEP:Deploy()
	local owner = self:GetOwner()

	if SERVER then
		self:RefreshSigils()
	end

	if SERVER and not (owner:IsSuperAdmin() or owner:IsAdmin()) then
        self:Remove()
    end

	return true
end

function SWEP:Holster()
	if SERVER then
		for _, ent in pairs(ents.FindByClass("point_fakesigil")) do
			ent:Remove()
		end
	end

	return true
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end
	local tr = owner:TraceLine(10240)

	--This controls whether we should edit a sigil we are looking at on PrimaryFire
	for _, ent in pairs(ents.FindByClass("point_fakesigil")) do
		local id = ent:GetID()
		local point = ent:GetPos()
		if point:DistToSqr(tr.HitPos) < 4096 then
			owner:ChatPrint("Editing Sigil... ID="..id)

			net.Start("zs_profilerdata")
				net.WriteUInt(id, 12)
				net.WriteTable(ent.Metadata or {})
			net.Send(owner)

			return
		end
	end

	for index, point in pairs(GAMEMODE.ProfilerNodes) do
		if point:DistToSqr(tr.HitPos) < 4096 then --prevent sigils from being placed on top of eachother
			return
		end
	end

	--place a new sigil
	if tr.HitWorld and tr.HitNormal.z >= 0.8 then
		table.insert(GAMEMODE.ProfilerNodes, tr.HitPos)
		table.insert(GAMEMODE.ProfilerMetadata, {}) --placeholder, so that IDs are consistent on removal

		self:RefreshSigils()
		GAMEMODE.ProfilerIsPreMade = true
	if SERVER then
		GAMEMODE:SaveProfilerPreMade()
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end

	local tr = owner:TraceLine(10240)

	local remindex
	for index, point in pairs(GAMEMODE.ProfilerNodes) do
		if point:DistToSqr(tr.HitPos) < 4096 then
			remindex = index
			break
		end
	end

	if not remindex then return end

	table.remove(GAMEMODE.ProfilerNodes, remindex)
	table.remove(GAMEMODE.ProfilerMetadata, remindex)

	self:RefreshSigils()
	GAMEMODE.ProfilerIsPreMade = true

	GAMEMODE:SaveProfilerPreMade()
end

SWEP.NextReload = 0
function SWEP:Reload()
	local owner = self:GetOwner()
	if not CanPlace(owner) then return end

	owner:DoAttackEvent()

	if CLIENT then return end

	if owner:KeyDown(IN_SPEED) then
		if self.NextReload < CurTime() then
			self.NextReload = CurTime() + 1

			local sigils = ents.FindByClass("info_sigilnode")

			if #sigils < 1 or #GAMEMODE.ProfilerNodes > 0 then --Don't load if we have no sigils or risk overwriting a profile
				owner:ChatPrint("There are no map-defined sigils or there is already a profile on this map!")
				return
			end

			for k, ent in ipairs(sigils) do
				local t = {}
				for key, _ in pairs(kv) do
					if ent[key] then
						t[key] = ent[key]
					end
				end
				GAMEMODE.ProfilerNodes[k] = ent:GetPos() --Get suitable nodes
				GAMEMODE.ProfilerMetadata[k] = t --Extract metadata, if any
			end

			owner:ChatPrint("Loaded map-defined sigils!")
			self:RefreshSigils()
		end
		return
	end

	if not self.StartReload and not self.StartReload2 then
		self.StartReload = CurTime()
		owner:ChatPrint("Keep holding reload to clear all pre-made sigil points.")
	end
end

if SERVER then
function SWEP:Think()
	if self.StartReload2 then
		if not self:GetOwner():KeyDown(IN_RELOAD) then
			self.StartReload2 = nil
			return
		end

		if CurTime() >= self.StartReload2 + 3 then
			self.StartReload2 = nil

			self:GetOwner():ChatPrint("Deleted everything including generated nodes. Turned off generated mode.")

			GAMEMODE.ProfilerIsPreMade = true
			GAMEMODE:DeleteProfilerPreMade()
			GAMEMODE.ProfilerNodes = {}
			GAMEMODE:SaveProfiler()

			self:RefreshSigils()
		end
	elseif self.StartReload then
		if not self:GetOwner():KeyDown(IN_RELOAD) then
			self.StartReload = nil
			return
		end

		if CurTime() >= self.StartReload + 3 then
			self.StartReload = nil

			self:GetOwner():ChatPrint("Deleted all pre-made sigil points and reverted to generated mode. Keep holding reload to delete ALL nodes.")

			GAMEMODE.ProfilerIsPreMade = false
			GAMEMODE:DeleteProfilerPreMade()
			GAMEMODE:LoadProfiler()

			self:RefreshSigils()

			self.StartReload2 = CurTime()
		end
	end
end

concommand.Add("zs_sigilplacer", function(sender)
	if CanPlace(sender) then
		sender:Give("weapon_zs_sigilplacer")
	end
end)

--This command shows information about the map's sigils/sigilgroups (if any) as well as the type of profile that is currently active
concommand.Add("zs_profilestatus", function(sender)
	if CanPlace(sender) then
		--Map name
		local map = string.format("Map: %s", game.GetMap())

		--evaluate the sigil logic entities on the map
		local mapsigils = string.format("Map has info_sigilnodes: %s", #ents.FindByClass("info_sigilnode") > 0 and "true" or "false")
		local sigilgroup = #ents.FindByClass("info_sigilgroup") > 0
		local sigilgroupmode = "default - random"
		if GAMEMODE.SigilGrouping and GAMEMODE.SigilGrouping ~= 0 then
			if GAMEMODE.SigilGrouping == 1 then
				sigilgroupmode = "Inclusive grouping"
			else
				sigilgroupmode = "Exclusive grouping"
			end
		end

		local sigilgroupstatus = string.format("Sigil group present: %s - Group mode: %s", sigilgroup and "true" or "false", sigilgroupmode)

		--evaluate the profile status of the map
		local premade = string.format("SigilPlacer profile active: %s", GAMEMODE.ProfilerIsPreMade and "true" or "false")
		local profileisautogenned = "false"

		if #GAMEMODE.ProfilerNodes > 0 and not GAMEMODE.ProfilerIsPreMade then
			profileisautogenned = "true"
		end

		profileisautogenned = string.format("Profile is autogenerated: %s", profileisautogenned)

		--print to the sender in probably the most inefficent way possible
		--should be fine since this command isn't meant to be run often at all
		sender:ChatPrint(map)
		sender:ChatPrint(mapsigils)
		sender:ChatPrint(sigilgroupstatus)
		sender:ChatPrint(premade)
		sender:ChatPrint(profileisautogenned)
	end
end)

--Should this be moved out of SWEP? I think it's fine here.
util.AddNetworkString("zs_profilerdata")
net.Receive("zs_profilerdata", function(ln, ply)
	if not (ply and ply:IsValid() and CanPlace(ply)) then return end
	local sigilid = net.ReadUInt(12) --4000 sigils...
	local sigiltab = net.ReadTable()
	local existtab = GAMEMODE.ProfilerMetadata[sigilid] or {}

	sigiltab = table.Merge(existtab, sigiltab)

	GAMEMODE.ProfilerMetadata[sigilid] = sigiltab
	GAMEMODE:SaveProfilerPreMade()
end)

end

function SWEP:RefreshSigils()
	for _, ent in pairs(ents.FindByClass("point_fakesigil")) do
		ent:Remove()
	end

	for i, point in pairs(GAMEMODE.ProfilerNodes) do
		local ent = ents.Create("point_fakesigil")
		if ent:IsValid() then
			ent:SetPos(point)
			ent:SetID(i)
			ent:Spawn()

			GAMEMODE.ProfilerMetadata[i] = GAMEMODE.ProfilerMetadata[i] or {} --populate the metadata table if we're editing an old mesh
			local meta = GAMEMODE.ProfilerMetadata[i]
			ent.Metadata = meta
		end
	end
end

local ENT = {}

ENT.Type = "anim"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(1.1, 0)
	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
end


if CLIENT then
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
function ENT:DrawTranslucent()
	if MySelf:IsValid() then
		local wep = MySelf:GetActiveWeapon()
		if wep:IsValid() and wep:GetClass() == "weapon_zs_sigilplacer" then
			cam.IgnoreZ(true)
			render.SetBlend(0.5)
			render.SetColorModulation(1, 0, 0)
			render.SuppressEngineLighting(true)

			self:DrawModel()

			render.SuppressEngineLighting(false)
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			cam.IgnoreZ(false)
		end
	end
end
end

scripted_ents.Register(ENT, "point_fakesigil")


if not CLIENT then return end

net.Receive("zs_profilerdata", function(ln)
	local id = net.ReadUInt(12)
	local data = net.ReadTable()

	local wep = MySelf:GetActiveWeapon()

	if wep and wep:IsValid() and wep.CreateEditSigilPanel then
		wep:CreateEditSigilPanel(id, data)
	end
end)

--Yes I know this could be done better
local COLOR_BLACK = Color(0,0,0)
function SWEP:CreateEditSigilPanel(id, sigildata)
	local bss = BetterScreenScale()
	local frame = vgui.Create("DFrame")
	frame:SetSize(600 * bss, 200 * bss)
	frame:SetPos(ScrW() / 2 - frame:GetWide() / 2, ScrH() / 2 + 100 * bss) --open out of the way of the cursor
	frame:SetTitle("Edit Sigil KeyValues: SigilID "..id)

	--Sigil editing controls panel
	local pnledit = vgui.Create("DPanel", frame)
	pnledit.Paint = function() end
	pnledit:SetSize(300 * bss, 200 * bss)
	pnledit:Dock(LEFT)

	local psigilkv = vgui.Create("DProperties", pnledit)
	psigilkv:SetWide(300 * bss)
	psigilkv:Dock(FILL)
	psigilkv.Info = {}

	local cat = "Sigil KeyValues"
	for key, type in pairs(kv) do
		local row = psigilkv:CreateRow(cat, key)
		row:Setup(type)
		row.DataChanged = function(s, data)
			psigilkv.Info[key] = data
		end

		if sigildata[key] ~= nil then
			row:SetValue(sigildata[key])
			psigilkv.Info[key] = sigildata[key]
		end

		if type == "Generic" then
			--this is terrible, but it works, and theres no other accessor
			local te = row:GetChild(1):GetChildren()[1]:GetChildren()[1]
			te:SetTextColor(COLOR_BLACK)
		end
		psigilkv[key] = row
	end

	local btn = EasyButton(pnledit, "[Save]")
	btn:SetFont("ZSHUDFontSmall")
	btn:SizeToContents()
	btn:Dock(BOTTOM)
	btn.DoClick = function()
		net.Start("zs_profilerdata")
			net.WriteUInt(id, 12)
			net.WriteTable(psigilkv.Info)
		net.SendToServer()

		MySelf:ChatPrint("Sigil properties applied!")
		frame.Applied = true
		frame:Close()
	end

	--Information panel
	local pnlinfo = vgui.Create("DPanel", frame)
	pnlinfo.Paint = function() end
	pnlinfo:SetSize(280 * bss, 200 * bss)
	pnlinfo:Dock(RIGHT)

	local lab = EasyLabel(pnlinfo, instructions, "DermaDefault") --Better font?
	lab:Dock(FILL)
	lab:SetWrap(true)

	frame.OnClose = function()
		if not frame.Applied then
			MySelf:ChatPrint("NOTE: Sigil changes discarded and not saved!")
		end
	end

	frame:MakePopup()
end


local controls = {
	{"[PRIMARY FIRE] - Place Sigil", color_white},
	{"[PRIMARY FIRE] (on sigil) - Edit Sigil", COLOR_CYAN},
	{"[SECONDARY FIRE] - Remove Sigil", COLOR_RED},
	{''},
	{"[SPRINT+RELOAD] - Load map-placed sigils into profile", COLOR_GREEN},
	{"[RELOAD] (hold) - Clear premade sigils", COLOR_ORANGE},
	{"[RELOAD] (hold longer) - Clear ALL sigils", COLOR_ORANGE},
}

local font = "ZSHUDFontSmaller"
function SWEP:DrawHUD()
	local bss = BetterScreenScale()
	local startx = 32 * bss
	local starty = 200 * bss

	surface.SetFont(font)
	local _, h = surface.GetTextSize("W")
	local offset = 0
	for _, control in ipairs(controls) do
		draw.SimpleText(control[1], font, startx, starty + offset, control[2])
		offset = offset + h
	end
end
