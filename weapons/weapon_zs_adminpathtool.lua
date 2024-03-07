if CLIENT then
	SWEP.PrintName = "Admin Path Tool"
	SWEP.NewSlot = 6
	SWEP.SlotPos = 100
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 2 then
			return "MASS"
		else
			return "OVRCL"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "In Stock"
		elseif self:GetFireMode() == 2 then
			return "Mass Placing"
		else
			return "Overclocked"
		end
	end		
end

SWEP.Base = "weapon_zs_base"

SWEP.Author = ""
SWEP.Instructions = "Do stuff."
SWEP.Contact = ""
SWEP.Purpose = ""
 
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"
 
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = true
 
SWEP.NextStrike = 0
 
SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl") --The model while being held
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl") --World model (on the ground)
SWEP.UseHands = true
 
SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav") --The sound
 
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

SWEP.OnlyCrosshairDot = true
SWEP.ForcedPathFlags = 0

SWEP.AllowQualityWeapons = false


SWEP.SetUpFireModes = 2
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true
function SWEP:CheckOverClock()
	if self:GetFireMode() == 2 then
		self.Primary.Automatic = false
		self.Secondary.Automatic = false
		self.Primary.Delay = 0
		self.Secondary.Delay = 0

	elseif self:GetFireMode() == 1 then
		self.Primary.Automatic = true
		self.Secondary.Automatic = true
		self.Primary.Delay = 0.01
		self.Secondary.Delay = 0.01

	elseif self:GetFireMode() == 0 then
		self.Primary.Automatic = false
		self.Secondary.Automatic = false
		self.Primary.Delay = 0
		self.Secondary.Delay = 0

	end
end

function SWEP:CallWeaponFunction()
	self:CheckOverClock()
end

function SWEP:SetSelfTypeMass(value)
	self:SetDTInt(15, value)
end

function SWEP:GetSelfTypeMass()
	return self:GetDTInt(15)
end

function SWEP:SetSelfScaleMass(value)
	self:SetDTInt(16, value)
end

function SWEP:GetSelfScaleMass()
	return self:GetDTInt(16)
end

function SWEP:SetSelfTypeOfPlacingMass(value)
	self:SetDTInt(17, value)
end

function SWEP:GetSelfTypeOfPlacingMass()
	return self:GetDTInt(17)
end

function SWEP:Deploy()
	self.LastDeploy = nil
	
	local owner = self:GetOwner()
	if SERVER and owner and not owner:IsBot() then
		GAMEMODE:NetworkPathList(owner)
		owner:PrintMessage( HUD_PRINTTALK, "Use 'zs_admin_purgepaths' to purge all paths" )
	end
end

function SWEP:Initialize()
end

function SWEP:DeployNode( bAlt, massplacing )
	if CurTime() < self.NextStrike then return end

	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)
	
	self:EmitSound(self.Sound)
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + 0.4
	
	if CLIENT then
		if self.ClientEditMode==2 then
			local pos = nil
			local InAir = (owner:KeyDown(IN_SPEED) or owner:WaterLevel()>=2)

			if InAir then
				pos = owner:GetPos()
			else
				local tr = owner:TraceLine(1024, MASK_SOLID_BRUSHONLY, owner:IsPlayer())
				if not tr.Hit then
					return
				end
				pos = tr.HitPos
			end

			local testpath = GAMEMODE:FindPathAt( pos )
			if self.LastDeploy then
				self.LastDeploy = nil
			elseif testpath then
				self.LastDeploy = true
			end
		else
			if bAlt==2 then
				self.LastDeploy = nil
			elseif owner:KeyDown(IN_SPEED) then
				if not bAlt then
					self.LastDeploy = true
				end
			else
				self.LastDeploy = nil
			end
		end
		return
	end
	
	if self.ServerEditMode==2 then
		local pos = nil
		local InAir = (owner:KeyDown(IN_SPEED) or owner:WaterLevel()>=2)

		if InAir then
			pos = owner:GetPos()
		else
			local tr = owner:TraceLine(1024, MASK_SOLID_BRUSHONLY, owner:IsPlayer())
			if not tr.Hit then
				owner:PrintMessage( HUD_PRINTTALK, "Aim target is too far away." )
				return
			end
			pos = tr.HitPos
		end
		
		local findpath,foundpathpos = GAMEMODE:FindPathAt( pos )
		if not findpath then
			self.LastDeploy = nil
			owner:PrintMessage( HUD_PRINTTALK, "None node found nearby!" )
			return
		end
		if self.LastDeploy then
			local ctrl = false
			--print(self.ForcedPathFlags)
			if tonumber(self.ForcedPathFlags) == 32 then -- Ставить пути в обе стороны
				local Er1 = GAMEMODE:EditReachSpec( self.LastDeploy, findpath, (bAlt and 2 or 1), 0 )
				local findpath2,foundpathpos2 = GAMEMODE:FindPathAt( self.LastDeploy )
				timer.Simple(0, function() -- Боже упаси от Timer Failed
					local Er2 = GAMEMODE:EditReachSpec( foundpathpos, findpath2, (bAlt and 2 or 1), 0 )
				end)
				ctrl = true
			else
				ctrl = false
				local Er = GAMEMODE:EditReachSpec( self.LastDeploy, findpath, (bAlt and 2 or 1), self.ForcedPathFlags )
			end

			self.LastDeploy = nil
			if (ctrl and (isstring(Er1) or isstring(Er2))) or isstring(Er) then
				if ctrl then
					owner:PrintMessage( HUD_PRINTTALK, "Failed to edit pathnode1: "..Er1 )
					owner:PrintMessage( HUD_PRINTTALK, "Failed to edit pathnode2: "..Er2 )
				else
					owner:PrintMessage( HUD_PRINTTALK, "Failed to edit pathnode: "..Er )
				end
			else
				owner:PrintMessage( HUD_PRINTTALK, "Path edited!" )
			end
		else
			owner:PrintMessage( HUD_PRINTTALK, "Selected START path at: "..tostring(foundpathpos) )
			self.LastDeploy = foundpathpos
		end
		return
	end
	
	local pos = nil

	if massplacing then
		local A_Meta = FindMetaTable("Angle")
		local A_Up = A_Meta.Up
		local A_Forward = A_Meta.Forward
		local A_Right = A_Meta.Right

		--local V_Meta = FindMetaTable("Vector")
		--local V_Angle = V_Meta.Angle

		local type = ((self:GetSelfTypeOfPlacingMass() == 3) and "rectangle") or ((self:GetSelfTypeOfPlacingMass() == 2) and "circle") or "quad"

		local numofnodes = self:GetSelfTypeMass()
		local pattern = self:GeneratePattern(type, numofnodes)
		--local src = owner:GetShootPos()
		--local base_ang = V_Angle(owner:GetAimVector())
		local classic_spread = (numofnodes * 6) * self:GetSelfScaleMass() / 360

		local firsttrace = owner:TraceLine(1536, MASK_SOLID_BRUSHONLY, nil)
		if not firsttrace.Hit then
			owner:PrintMessage( HUD_PRINTTALK, "Aim target is too far away." )
			return
		end
		local first_pos = firsttrace.HitPos + Vector(0, 0, 72)
		local src = first_pos
		local base_ang = Angle(90, 0, 0)

		for i = 0, numofnodes - 1 do
			timer.Simple(0.025 * i, function()
				local x, y = pattern[i + 1][1] * classic_spread, pattern[i + 1][2] * classic_spread
				local dir = A_Forward(base_ang) + x * A_Right(base_ang) + y * A_Up(base_ang)
	
				local tr_tbl = {start = src, endpos = src + dir * 1536, mask = MASK_SOLID_BRUSHONLY}
				local tr = util.TraceLine(tr_tbl)
				if not tr.Hit then
					owner:PrintMessage( HUD_PRINTTALK, "Aim target is too far away." )
					return
				end
				local pos = tr.HitPos
	
				if bAlt == 1 then
					GAMEMODE:RemovePathNode(pos, true)
				else
					GAMEMODE:DeployPathNode(pos,nil,Flags, true)
				end
			end)
		end

		return
	end

	local Flags = (bAlt==2 or owner:WaterLevel()>=2) and 1 or nil
	
	if not Flags and owner:KeyDown(IN_SPEED) and not self.LastDeploy and bAlt then
		Flags = 2
	end
	
	if Flags then
		pos = owner:GetPos()
	else
		local tr = owner:TraceLine(1024, MASK_SOLID_BRUSHONLY, nil)
		if not tr.Hit then
			owner:PrintMessage( HUD_PRINTTALK, "Aim target is too far away." )
			return
		end
		pos = tr.HitPos
		
		if self.ServerEditMode==3 then
			Flags = 4
		elseif self.ServerEditMode==4 then
			Flags = 5
		end
	end

	local err = nil
	local ForceType = nil
	if owner:KeyDown(IN_SPEED) and bAlt~=2 then
		if bAlt then
			if self.LastDeploy then -- Leap destination (3)
				Flags = 3
				err = GAMEMODE:DeployPathNode(pos,self.LastDeploy,Flags, true)
			else -- Flight path (2)
				err = GAMEMODE:DeployPathNode(pos,nil,Flags, true)
			end
		else
			if self.LastDeploy then -- Forced destination
				ForceType = 2
				err = GAMEMODE:DeployPathNode(pos,self.LastDeploy,Flags, true)
			else -- Forced start
				ForceType = 1
				err = GAMEMODE:DeployPathNode(pos,self.LastDeploy,Flags, true)
			end
		end
	elseif bAlt then -- Delete
		ForceType = 3
		err = GAMEMODE:RemovePathNode(pos, true)
	else -- Normal path
		err = GAMEMODE:DeployPathNode(pos,nil,Flags, true)
	end

	if isstring(err) then
		owner:PrintMessage( HUD_PRINTTALK, (ForceType==3 and "Failed to delete pathnode: " or "Failed to add pathnode: ")..tostring(err) )
		return
	end
	
	self.LastDeploy = nil

	local msg = nil
	if ForceType==3 then
		msg = "Remove pathnode near at "
	elseif ForceType==1 then
		self.LastDeploy = pos
		msg = "Add forced path START at "
	elseif ForceType==2 then
		self.LastDeploy = pos
		msg = "Add forced path END at "
	elseif Flags==3 then
		self.LastDeploy = pos
		msg = "Add forced leap path END at "
	elseif Flags==2 then
		msg = "Add flying path at "
	else
		msg = "Add pathnode at "
	end
	owner:PrintMessage( HUD_PRINTTALK, msg..tostring(pos) )
	GAMEMODE.NavEditors[owner:Nick()]=true
end

function SWEP:PrimaryAttack()
	self:DeployNode(nil, self:GetFireMode() == 2)
end

function SWEP:SecondaryAttack()
	self:DeployNode(1, self:GetFireMode() == 2)
end

function SWEP:Reload()
	self:DeployNode(2)
end

if SERVER then
	concommand.Add("zs_patheditmode", function(sender, command, arguments)
		if not IsValid(sender) then return end

		local wep = sender:GetActiveWeapon()
		if IsValid(wep) and wep.SetEditMode then
			wep:SetEditMode(arguments[1],arguments[2])
		end
	end)
	function SWEP:SetEditMode( Mode, Flgs )
		if Mode=="t" then
			local o = self:GetOwner()
			if math.floor(tonumber(Flgs))==0 then
				o:SetMoveType(MOVETYPE_WALK)
			else
				o:SetMoveType(MOVETYPE_NOCLIP)
			end
			return
		end
		self.ServerEditMode = math.floor(tonumber(Mode))
		if Flgs then
			self.ForcedPathFlags = math.floor(tonumber(Flgs))
		end
		self.LastDeploy = nil
	end
end

if not CLIENT then return end

GAMEMODE.AIWriteZ=CreateClientConVar("zs_ai_writez","0",true,false):GetBool()
cvars.AddChangeCallback("zs_ai_writez",function(a,b,c)
	GAMEMODE.AIWriteZ=tonumber(c)==1 
end)

concommand.Add("zs_ai_render_writez", function(sender, command, arguments)
	if not IsValid(sender) then return end

	local wep = sender:GetActiveWeapon()
	if IsValid(wep) and wep.SetEditMode then
		wep:SetEditMode(arguments[1],arguments[2])
	end
end)

function SWEP:DrawHUD()
	local screenscale = BetterScreenScale()
	local wid, hei = 180 * screenscale, 64 * screenscale
	local xs, ys = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72

	local fnt = "ZSHUDFontTiny"
	local owner = self:GetOwner()
	local x = ScrW() * 0.01 * screenscale
	local y =  ScrH() - 820 - screenscale * 72
	local bWater = owner:WaterLevel()>=2

	if bWater then
		draw.SimpleTextBlurry("Water Path: Nodes are placed ontop of you and not at crosshair", fnt, x, y, COLOR_BLUE)
		y = y+16
	end
	
	--if CLIENT then
		if not self.CantSwitchFireModes then
			draw.SimpleTextBlurry(self:DefineFireMode2D() or "", "ZSHUDFontSmall", xs + wid * 0.5, ys + hei * 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	--end
	
	if self.ClientEditMode==2 then
		if self.LastDeploy then
			draw.SimpleTextBlurry("Select path END:", fnt, x, y, COLOR_WHITE)
			y = y+16
			draw.SimpleTextBlurry("[Fire] - Add ReachSpec from START to END", fnt, x, y, COLOR_GREEN)
			y = y+16
			draw.SimpleTextBlurry("[AltFire] - Delete ReachSpec from START to END", fnt, x, y, COLOR_RED)
			y = y+16
		else
			draw.SimpleTextBlurry("[Fire/AltFire] - Select path START", fnt, x, y, COLOR_WHITE)
			y = y+16
		end
		draw.SimpleTextBlurry("Hold [Sprint] - Select path at your CAMERA location, not crosshair location!", fnt, x, y, COLOR_WHITE)
		y = y+16
	else
		if owner:KeyDown(IN_SPEED) then
			if self.LastDeploy then
				draw.SimpleTextBlurry("END Path -", fnt, x, y, COLOR_RED)
				y = y+16
				draw.SimpleTextBlurry("[Fire] - Place forced destination/middle path", fnt, x, y, COLOR_RED)
				y = y+16
				draw.SimpleTextBlurry("[AltFire] - Place leap/climb path destination", fnt, x, y, COLOR_RED)
				y = y+16
			else
				draw.SimpleTextBlurry("START Path -", fnt, x, y, COLOR_YELLOW)
				y = y+16
				draw.SimpleTextBlurry("[Fire] - Place starting node", fnt, x, y, COLOR_YELLOW)
				y = y+16
				draw.SimpleTextBlurry("[AltFire] - Place flying path node at your location", fnt, x, y, COLOR_YELLOW)
				y = y+16
			end
		else
			draw.SimpleTextBlurry("Hold [Sprint] to place forced paths.", fnt, x, y, COLOR_WHITE)
			y = y+16
			draw.SimpleTextBlurry("[Fire] - Deploy path", fnt, x, y, COLOR_WHITE)
			y = y+16
			draw.SimpleTextBlurry("[AltFire] - Delete path", fnt, x, y, COLOR_WHITE)
			y = y+16
		end
		
		draw.SimpleTextBlurry("[Reload] - Delete path at camera location", fnt, x, y, COLOR_RED)
		y = y+16
	end
end

local EditModeNames = {"Create Mode","Edit ReachSpecs","Add Supply Crate nodes","Add the empty node"}
local DrawDistances = {{D=300,T="Short"},{D=800,T="Medium"},{D=1200,T="Long"},{D=3500,T="Really far"}}
local PathFlagsMode = {"Fast Zombie jump","Flesh Beast climb","Headcrab jump","Teleport zombie","Stealth Mode", "Edit two path ways"}
local FlagsNoClip = {[4]=true}

function SWEP:SetEditMode( Mode )
	self.ClientEditMode = Mode
	self.LastDeploy = nil
	RunConsoleCommand("zs_patheditmode",Mode)
end

function SWEP:SetPathFlags( Index, Enable )
	if FlagsNoClip[Index] then
		RunConsoleCommand("zs_patheditmode","t",(Enable and 1 or 0))
		return
	end
	Index = bit.lshift(1,Index)
	if Enable then
		self.ForcedPathFlags = bit.bor(self.ForcedPathFlags,Index)
	else
		self.ForcedPathFlags = bit.band(self.ForcedPathFlags,bit.bnot(Index))
	end
	RunConsoleCommand("zs_patheditmode",self.ClientEditMode or 1,self.ForcedPathFlags)
end

function SWEP:GetPathFlags( Index )
	if FlagsNoClip[Index] then
		return MySelf:GetMoveType()==MOVETYPE_NOCLIP and 1 or 0
	end
	Index = bit.lshift(1,Index)
	return bit.band(self.ForcedPathFlags,Index)~=0 and 1 or 0
end

function SWEP:HandleHumanMenu()
	if IsValid(self.PathMenu) then
		return
	end

	local W,H = ScrW(),ScrH()
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:ShowCloseButton(false)
	DermaPanel:SetPos( W-200, (H-400)*0.5 )
	DermaPanel:SetSize( 200, 500 )
	DermaPanel:SetTitle( "Path Edit Tool" )
	DermaPanel:SetDraggable( false )
	DermaPanel.StartChecking = RealTime()+0.25
	DermaPanel.Think = function()
			if RealTime() >= DermaPanel.StartChecking and not MySelf:KeyDown(GAMEMODE.MenuKey) then
				DermaPanel:Remove()
			end
		end
	DermaPanel.OnRemove = function()
			self.PathMenu = nil
		end
	
	local DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Path edit mode:" )

	local DComboBox = vgui.Create( "DComboBox", DermaPanel )
	DComboBox:SetSize( 90, 20 )
	DComboBox:Dock(TOP)
	DComboBox:SetSortItems(false)
	DComboBox:SetValue( EditModeNames[self.ClientEditMode or 1] )
	for i=1, #EditModeNames do
		DComboBox:AddChoice( EditModeNames[i], nil, (self.ClientEditMode or 1)==i )
	end
	DComboBox.OnSelect = function( panel, index, value )
		self:SetEditMode(index)
	end
	
	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Path draw distance:" )
	
	DComboBox = vgui.Create( "DComboBox", DermaPanel )
	DComboBox:SetSize( 90, 20 )
	DComboBox:Dock(TOP)
	DComboBox:SetSortItems(false)
	local matched = 1
	for i=1, #DrawDistances do
		local bSelected = false
		if DrawDistances[i].D==GAMEMODE.PathDrawDistance then
			matched = i
			bSelected = true
		end
		DComboBox:AddChoice( DrawDistances[i].T, nil, bSelected )
	end
	DComboBox:SetValue( DrawDistances[matched].T )
	DComboBox.OnSelect = function( panel, index, value )
		GAMEMODE.PathDrawDistance = DrawDistances[index].D
	end
	
	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Path flags (for path edit):" )
	
	for i=1, #PathFlagsMode do
		local p = vgui.Create( "DPanel", DermaPanel )
		p:Dock( TOP )

		DLabel = vgui.Create( "DLabel", p )
		DLabel:SetText( PathFlagsMode[i]..":" )
		DLabel:Dock( FILL )
		
		local DCheckbox = vgui.Create("DCheckBox", p)
		DCheckbox:SetPos(176,0)
		DCheckbox:CenterVertical()
		DCheckbox:SetValue(self:GetPathFlags(i-1))
		DCheckbox.OnChange = function( chk, val )
			self:SetPathFlags(i-1,val)
		end
	end

	local DButton = vgui.Create( "DButton", DermaPanel )
	DButton:Dock(TOP)
	DButton:SetText( "Edit navmesh comment" )
	DButton.DoClick=function()
		local frame = vgui.Create( "DFrame" )
		frame:SetSize( 600, 400 )
		frame:SetTitle("Edit comment")
		frame:Center()
		frame:MakePopup()

		local TextEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
		TextEntry:Dock(FILL)
		TextEntry:SetText( GAMEMODE.NavComment or "" )
		TextEntry:SetPlaceholderText("Edit comment")
		TextEntry:SetMultiline(true)
		TextEntry.Paint = function(self)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
		local DButton = vgui.Create( "DButton", frame )
		DButton:Dock(BOTTOM)
		DButton:SetText( "SAVE" )
		DButton.DoClick = function()
			if string.len(TextEntry:GetValue())==0 then return end
			net.Start("zs_ai_comment")
			net.WriteString(TextEntry:GetValue())
			net.SendToServer()
		end
	end

	check = vgui.Create("DCheckBoxLabel", DermaPanel)
	check:Dock(TOP)
	check:SetText("Disable nodes wallhack?")
	check:SetConVar("zs_ai_writez")
	check:SizeToContents()

	local DButton = vgui.Create( "DButton", DermaPanel )
	DButton:Dock(TOP)
	DButton:SetText( "Import navmesh from other map" )
	DButton.DoClick=function()
		local frame = vgui.Create( "DFrame" )
		frame:SetSize( 600, 70 )
		frame:SetTitle("Import navmesh from other map")
		frame:Center()
		frame:MakePopup()

		local TextEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
		TextEntry:Dock(FILL)
		TextEntry:SetPlaceholderText("Specify map file name without extension")
		TextEntry:SetMultiline(false)
		TextEntry.Paint = function(self)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
		local DButton = vgui.Create( "DButton", frame )
		DButton:Dock(BOTTOM)
		DButton:SetText( "IMPORT" )
		DButton.DoClick = function()
			if string.len(TextEntry:GetValue())==0 then return end
			RunConsoleCommand("zs_navmesh_import", TextEntry:GetValue())
		end
	end

	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Mass placing | Node Count:" )

	dropdown = vgui.Create("DComboBox", DermaPanel )
	dropdown:SetMouseInputEnabled(true)
	dropdown:Dock(TOP)
	dropdown:AddChoice("4 nodes")
	dropdown:AddChoice("9 nodes")
	dropdown:AddChoice("25 nodes (fps drop)")
	dropdown:AddChoice("50 nodes (fps drop++)")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_typeofstickmasseditor", value == "4 nodes" and 5 or value == "9 nodes" and 9 or value == "25 nodes (fps drop)" and 25 or value == "50 nodes (fps drop++)" and 50 or 0)
	end
	local status = self:GetSelfTypeMass()
	dropdown:SetText(
	status == 5 and "4 nodes"
	or status == 9 and "9 nodes"
	or status == 25 and "25 nodes (fps drop)"
	or status == 50 and "50 nodes (fps drop++)"
	or "Nothink")

	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Mass placing | Radius Scale:" )

	dropdown = vgui.Create("DComboBox", DermaPanel )
	dropdown:SetMouseInputEnabled(true)
	dropdown:Dock(TOP)
	dropdown:AddChoice("x4")
	dropdown:AddChoice("x2")
	dropdown:AddChoice("x1")
	dropdown:AddChoice("x1.25")
	dropdown:AddChoice("x1.5")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_typeofstickmasseditor", value == "x4" and 4 or value == "x2" and 2 or value == "x1.5" and 1.5 or value == "x1.25" and 1.25 or 1, 1)
	end
	local status = self:GetSelfScaleMass()
	dropdown:SetText(
	status == 4 and "x4"
	or status == 2 and "x2"
	or status == 1.25 and "x1.25"
	or status == 1.5 and "x1.5"
	or "x1")

	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Mass placing | Type of Placing:" )

	dropdown = vgui.Create("DComboBox", DermaPanel )
	dropdown:SetMouseInputEnabled(true)
	dropdown:Dock(TOP)
	dropdown:AddChoice("quad")
	dropdown:AddChoice("circle")
	dropdown:AddChoice("rectangle")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_typeofstickmasseditor", value == "rectangle" and 3 or value == "circle" and 2 or 1, 2)
	end
	local status = self:GetSelfTypeOfPlacingMass()
	dropdown:SetText(
	status == 3 and "rectangle"
	or status == 2 and "circle"
	or "quad")

	DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:Dock(TOP)
	DLabel:SetText( "Navmesh status:" )

	dropdown = vgui.Create("DComboBox", DermaPanel )
	dropdown:SetMouseInputEnabled(true)
	dropdown:Dock(TOP)
	dropdown:AddChoice("Work in progress")
	dropdown:AddChoice("Test ready")
	dropdown:AddChoice("Confirmed (SA ONLY)")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_admin_navstatus", value == "Work in progress" and 1 or value == "Test ready" and 2 or value == "Confirmed (SA ONLY)" and 3 or 0)
	end
	local status = GetGlobalInt("Navmesh_status")
	dropdown:SetText(status== -1 and "No file"
	or status== 0 and "File exists"
	or status== 1 and "Work in progress"
	or status == 2 and "Test ready"
	or status == 3 and "Confirmed (SA ONLY)"
	or "de_inferno was a mistake")

	DermaPanel:MakePopup()
	self.PathMenu = DermaPanel
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end