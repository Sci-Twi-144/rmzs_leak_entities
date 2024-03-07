
include('glon.lua')

surface.CreateFont("12ptFont", {font = "Arial", size = 12, width = 500, antialias = true, additive = false})
surface.CreateFont("24ptFont", {font = "Arial", size = 24, width = 500, antialias = true, additive = false})

SWEP.selectedElement = ""
SWEP.useThirdPerson = false
SWEP.thirdPersonAngle = Angle(0,-90,0)
SWEP.thirdPersonAngleView = Angle( 0, 0, 0 )
SWEP.thirdPersonDis = 100
SWEP.mlast_x = ScrW()/2
SWEP.mlast_y = ScrH()/2

local playerBones = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Anim_Attachment_RH",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Shoulder",
	"ValveBiped.Bip01_R_Elbow",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Anim_Attachment_LH",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Shoulder",
	"ValveBiped.Bip01_L_Elbow"
	}
	
local model_drag_modes = {
	//["_x /y |z"] = { "x", "z", "y", "p", "r", "y" }, // this one is bad
	["_y /x |z"] = { "y", "z", "x", "y", "r", "p" },
	["view space"] = { "y", "z", "x", "y", "r", "p", vs = true },
}

SWEP.selectedModelDragMode = "view space"
SWEP.selectedModelDragPrecision = 0.01
SWEP.ModelDragAngleSnap = 0

SWEP.v_models = {}
SWEP.v_panelCache = {}
SWEP.v_modelListing = nil
SWEP.v_bonemods = {}
SWEP.v_modelbonebox = nil

SWEP.w_models = {}
SWEP.w_panelCache = {}
SWEP.w_modelListing = nil

SWEP.world_model = nil
SWEP.cur_wmodel = nil

SWEP.browser_callback = nil
SWEP.modelbrowser = nil
SWEP.modelbrowser_list = nil
SWEP.matbrowser = nil
SWEP.matbrowser_list = nil

SWEP.tpsfocusbone = "ValveBiped.Bip01_R_Hand"

SWEP.save_data = {}
local save_data_template = {
	ViewModel = SWEP.ViewModel,
	CurWorldModel = SWEP.CurWorldModel,
	w_models = {},
	v_models = {},
	v_bonemods = {},
	ViewModelFOV = SWEP.ViewModelFOV,
	HoldType = SWEP.HoldType,
	ViewModelFlip = SWEP.ViewModelFlip,
	IronSightsEnabled = true,
	IronSightsPos = SWEP.IronSightsPos,
	IronSightsAng = SWEP.IronSightsAng,
	ShowViewModel = true,
	ShowWorldModel = true
}

SWEP.ir_drag = {
	x = { true, "-x", 25 },
	y = { false, "y", 25 },
	z = { true, "y", 25 },
	pitch = { false, "y", 10 },
	yaw = { false, "x", 10 },
	roll = { false, "y", 10 }
}

SWEP.Frame = nil
SWEP.cur_drag_mode = "x / z"
SWEP.basecode = "FAILED TO READ BASE CODE"

function SWEP:ClientInit()

	SCKDebug("Client init start")

	if (IsValid(self:GetOwner())) then
		-- init view model bone mods
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	local basecodepath = "lua/weapons/swep_construction_kit/base_code.lua"
	self.basecode = file.Read(basecodepath, "GAME")

	SCKDebug("Loaded base code")

end

function SimplePanel( parent, scroll )

	local p = vgui.Create( scroll and "DScrollPanel" or "DPanel", parent)
	p.Paint = function() end
	return p

end
/*
function PrintVec( vec )
	local px, py, pz = math.floor(vec.x*1000)/1000,math.floor(vec.y*1000)/1000,math.floor(vec.z*1000)/1000
	return "Vector("..px..", "..py..", "..pz..")"
end

function PrintAngle( angle )
	local pp, py, pr = math.floor(angle.p*1000)/1000,math.floor(angle.y*1000)/1000,math.floor(angle.r*1000)/1000
	return "Angle("..pp..", "..py..", "..pr..")"
end*/

function PrintVec( vec )
	local px, py, pz = vec.x, vec.y, vec.z
	return "Vector("..px..", "..py..", "..pz..")"
end

function PrintAngle( angle )
	local pp, py, pr = angle.p, angle.y, angle.r
	return "Angle("..pp..", "..py..", "..pr..")"
end

function PrintColor( col )
	return "Color("..col.r..", "..col.g..", "..col.b..", "..col.a..")"
end

-- Populates a DChoiceList with all the bones of the specified entity
-- returns if it has a first option
function PopulateBoneList( choicelist, ent )
	if (!IsValid(choicelist)) then return false end
	if (!IsValid(ent)) then return end

	SCKDebug("Populating bone list for entity "..tostring(ent))

	if (ent == LocalPlayer()) then
		-- if the local player is in third person, his bone lookup is all messed up so
		-- we just use the predefined playerBones table
		//for k, v in pairs(playerBones) do
		//	choicelist:AddChoice(v)
		//end
		for i = 0, ent:GetBoneCount() - 1 do
			local name = ent:GetBoneName(i)
			if (ent:LookupBone(name)) then
				choicelist:AddChoice(name)
			end
		end

		return true
	else
		local hasfirstoption
		for i = 0, ent:GetBoneCount() - 1 do
			local name = ent:GetBoneName(i)
			if (ent:LookupBone(name)) then -- filter out invalid bones
				choicelist:AddChoice(name)
				if (!firstoption) then hasfirstoption = true end
			end
		end

		return hasfirstoption
	end
end

function SWEP:CreateWeaponWorldModel()

	local model = self.CurWorldModel
	SCKDebug("Creating weapon world model")

	if ((!self.world_model or (IsValid(self.world_model) and self.cur_wmodel != model)) and
		string.find(model, ".mdl") and file.Exists(model,"GAME") ) then

		if IsValid(self.world_model) then self.world_model:Remove() end
		self.world_model = ClientsideModel(model, RENDERGROUP_TRANSLUCENT)
		if (IsValid(self.world_model)) then
			self.world_model:SetParent(self:GetOwner())
			self.world_model:SetNoDraw(true)
			self.cur_wmodel = model
			if (self.world_model:LookupBone( "ValveBiped.Bip01_R_Hand" )) then
				self.world_model:AddEffects(EF_BONEMERGE)
			end
		else
			self.world_model = nil
			self.cur_wmodel = nil
		end

	end

end

function SWEP:CreateModels( tab )

	--if true then return end

	-- Create the clientside models here because Garry says we can't do it in the render hook
	for k, v in pairs( tab ) do
		if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and
				string.find(v.model, ".mdl") and file.Exists(v.model,"GAME") ) then

			SCKDebug("Creating new ClientSideModel "..v.model)

			v.modelEnt = ClientsideModel(v.model, RENDERGROUP_TRANSLUCENT)
			if (IsValid(v.modelEnt)) then
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
				v.modelEnt:SetNoDraw(true)
				v.createdModel = v.model
			else
				v.modelEnt = nil
			end

		elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) and file.Exists("materials/"..v.sprite..".vmt", "GAME")) then

			SCKDebug("Creating new sprite "..v.sprite)

			local name = v.sprite.."-"
			local params = { ["$basetexture"] = v.sprite }
			-- make sure we create a unique name based on the selected options
			local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
			for i, j in pairs( tocheck ) do
				if (v[j]) then
					params["$"..j] = 1
					name = name.."1"
				else
					name = name.."0"
				end
			end

			v.createdSprite = v.sprite
			v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)

		end
	end

end

function SWEP:Think()

	self:CreateModels( self.v_models )
	self:CreateModels( self.w_models )

	-- Some hacky shit to get 3rd person view compatible with
	-- other addons that override CalcView
	self:CalcViewHookManagement()

	--[[***********************
		Camera fiddling
	***********************]]
	self.useThirdPerson = self:GetThirdPerson()

	local mx, my = gui.MousePos()
	local diffx, diffy = (mx - self.mlast_x), (my - self.mlast_y)
	
	// model positioning
	
	local element_mode = input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_LSHIFT )
	local vm = self:GetOwner():GetViewModel()
	
	if element_mode and self.Frame and self.Frame:IsVisible() then
		
		local tbl = self.useThirdPerson and self.w_models or self.v_models
		local ent = self.useThirdPerson and self:GetOwner() or vm
		
		if tbl and tbl[ self.selectedElement ] and tbl[ self.selectedElement ].pos then
			
			local cur_mode = model_drag_modes[ self.selectedModelDragMode ]
			
			if cur_mode then
				
				local cur_el = tbl[ self.selectedElement ]
				
				if input.IsMouseDown(MOUSE_RIGHT) then
					
					if input.IsMouseDown(MOUSE_LEFT) then
						if input.IsKeyDown( KEY_LCONTROL ) then
							if cur_mode.vs and IsValid( ent ) then
								local p_pos, p_ang = self:GetBoneOrientation( tbl, self.selectedElement, ent )
								
								local thirdperson_ang = self.thirdPersonAngleView * 1
								//thirdperson_ang.y = thirdperson_ang.y + 90
								
								local view_ang = self.useThirdPerson and thirdperson_ang or LocalPlayer():EyeAngles()
								
								local offset_pos = p_pos - view_ang:Forward() * diffy * self.selectedModelDragPrecision
															
								offset_pos = WorldToLocal( offset_pos, view_ang, p_pos, p_ang )
								offset_pos.y = offset_pos.y * -1
								
								cur_el.pos = cur_el.pos + offset_pos
							else
								cur_el.pos[ cur_mode[ 3 ] ] = cur_el.pos[ cur_mode[ 3 ] ] - diffy * self.selectedModelDragPrecision
							end
						else
							if tbl[ self.selectedElement ].angle then
								
								local y_value = self.ModelDragAngleSnap > 0 and math.Round( ( diffy * self.ModelDragAngleSnap * self.selectedModelDragPrecision * 30 ) / self.ModelDragAngleSnap ) * self.ModelDragAngleSnap or diffy * self.selectedModelDragPrecision * 10
								
								if cur_mode.vs and IsValid( ent ) then
									local p_pos, p_ang = self:GetBoneOrientation( tbl, self.selectedElement, ent )
									local el_pos = p_pos + p_ang:Forward() * cur_el.pos.x + p_ang:Right() * cur_el.pos.y + p_ang:Up() * cur_el.pos.z
										
									local thirdperson_ang = self.thirdPersonAngleView * 1
									local view_ang = self.useThirdPerson and thirdperson_ang or LocalPlayer():EyeAngles()
										
									local offset_ang = p_ang * 1
									offset_ang:RotateAroundAxis( view_ang:Forward(), y_value )
										
									local _, offset_ang = WorldToLocal( el_pos, offset_ang, p_pos, p_ang )
									offset_ang.p = offset_ang.p * -1
										
									cur_el.angle = cur_el.angle + offset_ang
										
									cur_el.angle.p = math.NormalizeAngle( cur_el.angle.p )
									cur_el.angle.y = math.NormalizeAngle( cur_el.angle.y )
									cur_el.angle.r = math.NormalizeAngle( cur_el.angle.r )
										
								else
									cur_el.angle[ cur_mode[ 6 ] ] = math.NormalizeAngle( cur_el.angle[ cur_mode[ 6 ] ] - y_value )
								end
							end
						end
					else
						if input.IsKeyDown( KEY_LCONTROL ) then
							// AAAAAAAAAaaaaaaaaaaaaaaaa
							if cur_mode.vs and IsValid( ent ) then
								local p_pos, p_ang = self:GetBoneOrientation( tbl, self.selectedElement, ent )
								
								local thirdperson_ang = self.thirdPersonAngleView * 1
								
								local view_ang = self.useThirdPerson and thirdperson_ang or LocalPlayer():EyeAngles()
								
								local offset_pos = p_pos + view_ang:Right() * diffx * self.selectedModelDragPrecision - view_ang:Up() * diffy * self.selectedModelDragPrecision
															
								offset_pos = WorldToLocal( offset_pos, view_ang, p_pos, p_ang )
								offset_pos.y = offset_pos.y * -1
								
								cur_el.pos = cur_el.pos + offset_pos
							else
								cur_el.pos[ cur_mode[ 1 ] ] = cur_el.pos[ cur_mode[ 1 ] ] - diffx * self.selectedModelDragPrecision
								cur_el.pos[ cur_mode[ 2 ] ] = cur_el.pos[ cur_mode[ 2 ] ] + diffy * self.selectedModelDragPrecision
							end
						else
							if tbl[ self.selectedElement ].angle then
								
								local x_value = self.ModelDragAngleSnap > 0 and math.Round( ( diffx * self.ModelDragAngleSnap * self.selectedModelDragPrecision * 30 ) / self.ModelDragAngleSnap ) * self.ModelDragAngleSnap or diffx * self.selectedModelDragPrecision * 10
								local y_value = self.ModelDragAngleSnap > 0 and math.Round( ( diffy * self.ModelDragAngleSnap * self.selectedModelDragPrecision * 30 ) / self.ModelDragAngleSnap ) * self.ModelDragAngleSnap or diffy * self.selectedModelDragPrecision * 10

								if cur_mode.vs and IsValid( ent ) then
									local p_pos, p_ang = self:GetBoneOrientation( tbl, self.selectedElement, ent )
									local el_pos = p_pos + p_ang:Forward() * cur_el.pos.x + p_ang:Right() * cur_el.pos.y + p_ang:Up() * cur_el.pos.z
										
									local thirdperson_ang = self.thirdPersonAngleView * 1
									local view_ang = self.useThirdPerson and thirdperson_ang or LocalPlayer():EyeAngles()
										
									local offset_ang = p_ang * 1
									offset_ang:RotateAroundAxis( view_ang:Up(), x_value )
									offset_ang:RotateAroundAxis( view_ang:Right(), y_value )
										
									local _, offset_ang = WorldToLocal( el_pos, offset_ang, p_pos, p_ang )
									offset_ang.p = offset_ang.p * -1
										
									cur_el.angle = cur_el.angle + offset_ang
										
									cur_el.angle.p = math.NormalizeAngle( cur_el.angle.p )
									cur_el.angle.y = math.NormalizeAngle( cur_el.angle.y )
									cur_el.angle.r = math.NormalizeAngle( cur_el.angle.r )
										
								else
									cur_el.angle[ cur_mode[ 4 ] ] = math.NormalizeAngle( cur_el.angle[ cur_mode[ 4 ] ] - x_value )
									cur_el.angle[ cur_mode[ 5 ] ] = math.NormalizeAngle( cur_el.angle[ cur_mode[ 5 ] ] + y_value )
								end
							end
						end
					end
				
				end
				
				if input.WasMousePressed( MOUSE_WHEEL_UP ) then
					self.selectedModelDragPrecision = math.Clamp( self.selectedModelDragPrecision + 0.001, 0.005, 0.3 )
				end
				
				if input.WasMousePressed( MOUSE_WHEEL_DOWN ) then
					self.selectedModelDragPrecision = math.Clamp( self.selectedModelDragPrecision - 0.001, 0.001, 0.3 )
				end
			
			end
			
			
		end
		
		
	else
		// normal ironsights and stuff
		if (input.IsMouseDown(MOUSE_RIGHT) and !(diffx > 40 or diffy > 40) and self.Frame and self.Frame:IsVisible()) then -- right mouse press without sudden jumps

			if (self.useThirdPerson) then

				if (input.IsKeyDown(KEY_E)) then
					self.thirdPersonDis = math.Clamp( self.thirdPersonDis + diffy, 10, 500 )
				else
					self.thirdPersonAngle = self.thirdPersonAngle + Angle( diffy/2, diffx/2, 0 )
				end

			else
				-- ironsight adjustment
				for k, v in pairs( self.ir_drag ) do
					if (v[1]) then
						local temp = GetConVar( "_sp_ironsight_"..k ):GetFloat()
						if (v[2] == "x") then
							local add = -(diffx/v[3])
							if (self.ViewModelFlip) then add = add*-1 end
							RunConsoleCommand( "_sp_ironsight_"..k, temp + add )
						elseif (v[2] == "-x") then
							local add = diffx/v[3]
							if (self.ViewModelFlip) then add = add*-1 end
							RunConsoleCommand( "_sp_ironsight_"..k, temp + add )
						elseif (v[2] == "y") then
							RunConsoleCommand( "_sp_ironsight_"..k, temp - diffy/v[3] )
						end
					end
				end

			end

		end
	end

	self.mlast_x, self.mlast_y = mx, my
end

function SWEP:RemoveModels()

	SCKDebug("Removing models")

	for k, v in pairs( self.v_models ) do
		if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
	end
	for k, v in pairs( self.w_models ) do
		if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
	end
	self.v_models = {}
	self.w_models = {}

	if (IsValid(self.world_model)) then
		self.world_model:Remove()
		self.world_model = nil
		self.cur_wmodel = nil
	end
end

function SWEP:GetBoneOrientation( basetab, name, ent, bone_override, buildup )

	local bone, pos, ang
	local tab = basetab[name]

	if (tab.rel and tab.rel != "") then

		local v = basetab[tab.rel]

		if (!v) then return end

		if (!buildup) then
			buildup = {}
		end

		table.insert(buildup, name)
		if (table.HasValue(buildup, tab.rel)) then return end

		-- Technically, if there exists an element with the same name as a bone
		-- you can get in an infinite loop. Let's just hope nobody's that stupid.
		pos, ang = self:GetBoneOrientation( basetab, tab.rel, ent, nil, buildup )

		if (!pos) then return end

		pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		if (v.angle) then
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		end

	else

		bone = ent:LookupBone(bone_override or tab.bone)

		if (!bone) then return end

		pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = ent:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end

		if (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and
			ent == self:GetOwner():GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r -- Fixes mirrored models
		end

	end

	return pos, ang
end

local allbones
local hasGarryFixedBoneScalingYet = false

function SWEP:UpdateBonePositions(vm)

	if self.v_bonemods then

		if (!vm:GetBoneCount()) then return end

		-- !! WORKAROUND !! --
		-- We need to check all model names :/
		local loopthrough = self.v_bonemods
		if (!hasGarryFixedBoneScalingYet) then
			allbones = {}
			for i=0, vm:GetBoneCount() do
				local bonename = vm:GetBoneName(i)
				if (self.v_bonemods[bonename]) then
					allbones[bonename] = self.v_bonemods[bonename]
				else
					allbones[bonename] = {
						scale = Vector(1,1,1),
						pos = Vector(0,0,0),
						angle = Angle(0,0,0)
					}
				end
			end

			loopthrough = allbones
		end
		-- !! ----------- !! --

		for k, v in pairs( loopthrough ) do
			local bone = vm:LookupBone(k)
			if (!bone) then continue end

			-- !! WORKAROUND !! --
			local s = Vector(v.scale.x,v.scale.y,v.scale.z)
			local p = Vector(v.pos.x,v.pos.y,v.pos.z)
			local ms = Vector(1,1,1)
			if (!hasGarryFixedBoneScalingYet) then
				local cur = vm:GetBoneParent(bone)
				while(cur >= 0) do
					local pscale = loopthrough[vm:GetBoneName(cur)].scale
					ms = ms * pscale
					cur = vm:GetBoneParent(cur)
				end
			end

			--local bpos = vm:GetBonePosition(bone)
			--local par = vm:GetBoneParent(bone)
			s = s * ms

			--SCKDebug("Bone ("..bone..") "..vm:GetBoneName(bone).." rel to p ("..par.."): "..tostring(bpos - (vm:GetBonePosition(vm:GetBoneParent(bone)) or bpos)))
			--local relp = bpos - (vm:GetBonePosition(vm:GetBoneParent(bone)) or bpos)
			--p = relp * ms - relp
			--SCKDebug("Bone ("..bone..") scale = "..tostring(ms).." | newpos = "..tostring(p))

			-- !! ----------- !! --

			if vm:GetManipulateBoneScale(bone) != s then
				vm:ManipulateBoneScale( bone, s )
			end
			if vm:GetManipulateBoneAngles(bone) != v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) != p then
				vm:ManipulateBonePosition( bone, p )
			end
		end
	else
		self:ResetBonePositions(vm)
	end

end

function SWEP:ResetBonePositions(vm)

	if (!vm:GetBoneCount()) then return end

	for i=0, vm:GetBoneCount() do
		vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
		vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
		vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
	end

end

local helper_text_pos = nil
local matDisc = Material( "widgets/disc.png", "nocull alphatest smooth mips" )

function SWEP:ShowElementHelpers( pos, ang, v )
	
	local helper_pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
	local helper_ang = ang * 1
	
	helper_ang:RotateAroundAxis(helper_ang:Up(), v.angle.y)
	helper_ang:RotateAroundAxis(helper_ang:Right(), v.angle.p)
	helper_ang:RotateAroundAxis(helper_ang:Forward(), v.angle.r)
	
			
	helper_text_pos = helper_pos * 1
	
	if input.IsKeyDown( KEY_LSHIFT ) then
	
		if model_drag_modes[ self.selectedModelDragMode ].vs then
			helper_ang = self.useThirdPerson and self.thirdPersonAngleView or LocalPlayer():EyeAngles()
		end
	
		render.SetMaterial( matDisc )
		render.DrawQuadEasy( helper_pos, helper_ang:Forward(), 10, 10, Color( 255, 55, 55, 50 ), 0 )
		render.DrawQuadEasy( helper_pos, helper_ang:Right(), 10, 10, Color( 55, 255, 55, 50 ), 0 )
		render.DrawQuadEasy( helper_pos, helper_ang:Up(), 10, 10, Color( 55, 55, 255, 50 ), 0 )
		
	else
	
		if model_drag_modes[ self.selectedModelDragMode ].vs then
			ang = self.useThirdPerson and self.thirdPersonAngleView or LocalPlayer():EyeAngles()
		end
	
		render.DrawLine( helper_pos, helper_pos + ang:Forward() * 10, Color( 255, 55, 55 ), true )
		render.DrawLine( helper_pos, helper_pos + ang:Right() * 10, Color( 55, 255, 55 ), true )
		render.DrawLine( helper_pos, helper_pos + ang:Up() * 10, Color( 55, 55, 255 ), true )
	end
	
end

--[[*******************************
	All viewmodel drawing magic
********************************]]
SWEP.vRenderOrder = nil
function SWEP:ViewModelDrawn()

	--if true then return end
	--SCKDebugRepeat( "SWEP:VMD", "Drawing viewmodel!" )

	local vm = self:GetOwner():GetViewModel()
	if !IsValid(vm) then return end

	self:UpdateBonePositions(vm)
	--[[if vm.BuildBonePositions ~= self.BuildViewModelBones then
		vm.BuildBonePositions = self.BuildViewModelBones
	end]]

	
	if (!self.vRenderOrder) then

		-- we build a render order because sprites need to be drawn after models
		self.vRenderOrder = {}

		for k, v in pairs( self.v_models ) do
			if (v.type == "Model") then
				table.insert(self.vRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(self.vRenderOrder, k)
			end
		end

	end
	
	local show_helpers = ( input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_LSHIFT ) ) and self.Frame and self.Frame:IsVisible()

	for k, name in ipairs( self.vRenderOrder ) do

		local v = self.v_models[name]
		if (!v) then self.vRenderOrder = nil break end

		local model = v.modelEnt
		local sprite = v.spriteMaterial

		if (!v.bone) then continue end

		local pos, ang = self:GetBoneOrientation( self.v_models, name, vm )

		if (!pos) then continue end
		
		if show_helpers then
			if name == self.selectedElement then
				self:ShowElementHelpers( pos, ang, v )
			end
		else
			if helper_text_pos then helper_text_pos = nil end
		end

		if (v.type == "Model" and IsValid(model)) then

			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

			model:SetAngles(ang)
			--model:SetModelScale(v.size)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix( "RenderMultiply", matrix )
			
			if v.size.x < 0 and not v.inversed then
				v.inversed = true
			end
				
			-- reset back just in case
			if v.inversed and v.size.x > 0 then
				v.inversed = nil
			end

			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() != v.material) then
				model:SetMaterial( v.material )
			end

			if (v.skin != model:GetSkin()) then
				model:SetSkin(v.skin)
			end

			for k, v in pairs( v.bodygroup ) do
				if (model:GetBodygroup(k) != v) then
					model:SetBodygroup(k, v)
				end
			end

			if (v.surpresslightning) then
				render.SuppressEngineLighting(true)
			end

			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			if v.inversed then render.CullMode(MATERIAL_CULLMODE_CW) end
			model:DrawModel()
			if v.inversed then render.CullMode(MATERIAL_CULLMODE_CCW) end
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			if (v.surpresslightning) then
				render.SuppressEngineLighting(false)
			end

		elseif (v.type == "Sprite" and sprite) then

			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

		elseif (v.type == "Quad") then

			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

			cam.Start3D2D(drawpos, ang, v.size)
				draw.RoundedBox( 0, -20, -20, 40, 40, Color(200,0,0,100) )
				surface.SetDrawColor( 255, 255, 255, 100 )
				surface.DrawOutlinedRect( -20, -20, 40, 40 )
				draw.SimpleTextOutlined("12pt arial","12ptFont",0, -12, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
				draw.SimpleTextOutlined("40x40 box","12ptFont",0, 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
				surface.SetDrawColor( 0, 255, 0, 230 )
				surface.DrawLine( 0, 0, 0, 8 )
				surface.DrawLine( 0, 0, 8, 0 )
			cam.End3D2D()

		end

	end

end

--[[*******************************
	All worldmodel drawing science
********************************]]
SWEP.wRenderOrder = nil
function SWEP:DrawWorldModel()

	--if true then return end
	--SCKDebugRepeat( "SWEP:WMD", "Drawing worldmodel!" )

	local wm = self.world_model
	if !IsValid(wm) then return end

	if (!self.wRenderOrder) then

		self.wRenderOrder = {}

		for k, v in pairs( self.w_models ) do
			if (v.type == "Model") then
				table.insert(self.wRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(self.wRenderOrder, k)
			end
		end

	end

	local bone_ent

	if (IsValid(self:GetOwner())) then
		self:SetColor(Color(255,255,255,255))
		self:SetRenderMode(0)
		wm:SetNoDraw(true)
		if (self:GetOwner():IsPlayer() and self:GetOwner():GetActiveWeapon() != self.Weapon) then return end
		wm:SetParent(self:GetOwner())
		if !self:GetOwner():IsPlayer() then
			wm:SetRenderBounds( self:GetOwner():OBBMins()*2, self:GetOwner():OBBMaxs()*2 )
			self:SetRenderBounds( self:GetOwner():OBBMins()*2, self:GetOwner():OBBMaxs()*2 )
		end
		if (self.ShowWorldModel) and self:GetOwner():IsPlayer() then
			wm:DrawModel()
		end
		bone_ent = self:GetOwner()
	else
		-- this only happens if the weapon is dropped, which shouldn't happen normally.
		self:SetColor(Color(255,0,0,0))
		self:SetRenderMode( RENDERMODE_NONE )
		wm:SetNoDraw(false) -- else DrawWorldModel stops being called for some reason
		wm:SetParent(self)
		--wm:SetPos(opos)
		--wm:SetAngles(oang)
		if (self.ShowWorldModel) then
			wm:DrawModel()
		end
		//self:DrawModel()

		-- the reason that we don't always use this bone is because it lags 1 frame behind the player's right hand bone when held
		bone_ent = wm
	end

	--[[ BASE CODE FOR NEW SWEPS ]]
	--[[self:DrawModel()
	if (IsValid(self:GetOwner())) then
		bone_ent = self:GetOwner()
	else
		-- when the weapon is dropped
		bone_ent = self
	end]]

	local show_helpers = ( input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_LSHIFT ) ) and self.Frame and self.Frame:IsVisible()
	
	for k, name in pairs( self.wRenderOrder ) do

		local v = self.w_models[name]
		if (!v) then self.wRenderOrder = nil break end

		local pos, ang

		if (v.bone) then
			pos, ang = self:GetBoneOrientation( self.w_models, name, bone_ent )
		else
			pos, ang = self:GetBoneOrientation( self.w_models, name, bone_ent, "ValveBiped.Bip01_R_Hand" )
		end

		if (!pos) then continue end
		
		if show_helpers then
			if name == self.selectedElement then
				self:ShowElementHelpers( pos, ang, v )
			end
		else
			if helper_text_pos then helper_text_pos = nil end
		end

		local model = v.modelEnt
		local sprite = v.spriteMaterial

		if (v.type == "Model" and IsValid(model)) then

			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

			model:SetAngles(ang)
			--model:SetModelScale(v.size)
			local matrix = Matrix()
			matrix:Scale(v.size)			
			model:EnableMatrix( "RenderMultiply", matrix )

			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() != v.material) then
				model:SetMaterial( v.material )
			end

			if (v.skin != model:GetSkin()) then
				model:SetSkin(v.skin)
			end

			for k, v in pairs( v.bodygroup ) do
				if (model:GetBodygroup(k) != v) then
					model:SetBodygroup(k, v)
				end
			end

			if (v.surpresslightning) then
				render.SuppressEngineLighting(true)
			end

			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			if (v.surpresslightning) then
				render.SuppressEngineLighting(false)
			end

		elseif (v.type == "Sprite" and sprite) then

			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

		elseif (v.type == "Quad") then

			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

			cam.Start3D2D(drawpos, ang, v.size)
				draw.RoundedBox( 0, -20, -20, 40, 40, Color(200,0,0,100) )
				surface.SetDrawColor( 255, 255, 255, 100 )
				surface.DrawOutlinedRect( -20, -20, 40, 40 )
				draw.SimpleTextOutlined("12pt arial","12ptFont",0, -12, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
				draw.SimpleTextOutlined("40x40 box","12ptFont",0, 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
				surface.SetDrawColor( 0, 255, 0, 230 )
				surface.DrawLine( 0, 0, 0, 8 )
				surface.DrawLine( 0, 0, 8, 0 )
			cam.End3D2D()

		end

	end

end

function SWEP:Holster()
	self.useThirdPerson = false

	local vm = self:GetOwner():GetViewModel()
	if IsValid(vm) then
		self:ResetBonePositions(vm)
	end

	return true
end

local function DrawDot( x, y )

	surface.SetDrawColor(100, 100, 100, 255)
	surface.DrawRect(x - 2, y - 2, 4, 4)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawRect(x - 1, y - 1, 2, 2)

end

SWEP.FirstTimeOpen = true

function SWEP:DrawHUD()

	if helper_text_pos then
		
		local pos = helper_text_pos:ToScreen()
		
		draw.SimpleTextOutlined("Drag Precision: "..self.selectedModelDragPrecision,"12ptFont",pos.x, pos.y, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		
	end

	/*DrawDot( ScrW()/2, ScrH()/2 )
	DrawDot( ScrW()/2 + 10, ScrH()/2 )
	DrawDot( ScrW()/2 - 10, ScrH()/2 )
	DrawDot( ScrW()/2, ScrH()/2 + 10 )
	DrawDot( ScrW()/2, ScrH()/2 - 10 )

	if (self.Frame and self.Frame:IsVisible()) then

		self.FirstTimeOpen = false
		local text = ""
		if (self.useThirdPerson) then
			text = "Hold right mouse and drag to rotate. Additionally hold E key to zoom."
		else
			text = "Hold right mouse and drag to adjust ironsights (mode: "..self.cur_drag_mode..")"
		end
		draw.SimpleTextOutlined(text, "default", ScrW()/2, ScrH()/4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(20,20,20,255))

	elseif (self.FirstTimeOpen) then
		draw.SimpleTextOutlined("Press right mouse to open menu", "default", ScrW()/2, ScrH()/4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(20,20,20,255))
	end*/

end

--[[***** Create model browser ****]]
-- callback = function( selected_model )
function SWEP:OpenBrowser( current, browse_type, callback )

	local wep = self
	wep.browser_callback = callback
	wep.Frame:SetVisible( false )

	if (browse_type == "model" and wep.modelbrowser) then
		wep.modelbrowser:SetVisible(true)
		wep.modelbrowser:MakePopup()
		wep.modelbrowser_list.OnRowSelected(nil,nil,current)
		return
	elseif (browse_type == "material" and wep.matbrowser) then
		wep.matbrowser:SetVisible(true)
		wep.matbrowser:MakePopup()
		wep.matbrowser_list.OnRowSelected(nil,nil,current)
		return
	end

	local browser = vgui.Create("DFrame")
	browser:SetSize( 480, ScrH()*0.8 )
	browser:SetPos( 50, 50 )
	browser:SetDraggable( true )
	browser:ShowCloseButton( false )
	browser:SetSizable( true )
	browser:SetDeleteOnClose( false )

	if (browse_type == "model") then
		browser:SetTitle( "Model browser" )
		wep.modelbrowser = browser
	elseif (browse_type == "material") then
		browser:SetTitle( "Material browser" )
		wep.matbrowser = browser
	end

	local tree = vgui.Create( "DTree", browser )
	--tree:SetPos( 5, 30 )
	--tree:SetSize( browser:GetWide() - 10, browser:GetTall()-355 )
		tree:SetTall(300)
	tree:DockPadding(5,5,5,5)
	tree:Dock(TOP)

	local nodelist = {}
	local filecache = {}
	local checked = {}

	local modlist = vgui.Create("DListView", browser)
		modlist:SetMultiSelect(false)
		modlist:SetDrawBackground(true)
		if (browse_type == "model") then
			modlist:AddColumn("Model")
		elseif (browse_type == "material") then
			modlist:AddColumn("Material")
		end
	modlist:DockPadding(5,5,5,0)
	modlist:Dock(FILL)

	local bpanel = vgui.Create("DPanel", browser)
		bpanel:SetTall(200)
		bpanel:SetDrawBackground(false)
	bpanel:DockMargin(5,5,5,5)
	bpanel:Dock(BOTTOM)

	local modzoom = 30
	local modview

	if (browse_type == "model") then
		modview = vgui.Create("DModelPanel", bpanel)
		modview:SetModel("")
		modview:SetCamPos( Vector(modzoom,modzoom,modzoom/2) )
		modview:SetLookAt( Vector( 0, 0, 0 ) )
	elseif (browse_type == "material") then
		modview = vgui.Create("DImage", bpanel)
		--modview:SetImage("")
	end

	modview:SetSize(200, 200)
	modview:Dock(LEFT)

	local rpanel = vgui.Create("DPanel", bpanel)
		rpanel:SetDrawBackground(false)
	rpanel:DockPadding(5,0,0,0)
	rpanel:Dock(FILL)

	local mdlabel = vgui.Create("DLabel", rpanel)
		mdlabel:SetText( current )
		mdlabel:SizeToContents()
	mdlabel:Dock(TOP)

	if (browse_type == "model") then

		local zoomslider = vgui.Create( "DNumSlider", rpanel)
			zoomslider:SetText( "Zoom" )
			zoomslider:SetMin( 8 )
			zoomslider:SetMax( 256 )
			zoomslider:SetDecimals( 0 )
			zoomslider:SetValue( modzoom )
			zoomslider.Wang.ConVarChanged = function( panel, value )
				local modzoom = tonumber(value)
				modview:SetCamPos( Vector(modzoom,modzoom,modzoom/2) )
				modview:SetLookAt( Vector( 0, 0, 0 ) )
			end
		zoomslider:Dock(FILL)

	end

	local selected = ""

	modlist.OnRowSelected = function( panel, line, override )
		if (type(override) != "string") then override = nil end -- for some reason the list itself throws a panel at it in the callback
		local path = override or modlist:GetLine(line):GetValue(1)

		if (browse_type == "model") then
			modview:SetModel(path)
		elseif (browse_type == "material") then
			if (path:sub( 1, 10 ) == "materials/") then
				path = path:sub( 11 ) -- removes the "materials/" part
			end
			path = path:gsub( "%.vmt", "" )
			if (file.Exists( "materials/"..path..".vmt", "GAME" )) then
				modview:SetImage(path)
			end
		end

		mdlabel:SetText(path)
		selected = path
	end

	-- set the default
	modlist.OnRowSelected(nil,nil,current)
	if (browse_type == "model") then
		wep.modelbrowser_list = modlist
	elseif (browse_type == "material") then
		wep.matbrowser_list = modlist
	end

	local cancelbtn = vgui.Create("DButton", rpanel)
		cancelbtn:SetTall(20)
		cancelbtn:SetText("cancel")
		cancelbtn.DoClick = function()
			if (wep.Frame) then
				wep.Frame:SetVisible(true)
			end
			browser:Close()
		end
	cancelbtn:Dock(BOTTOM)

	local choosebtn = vgui.Create("DButton", rpanel)
		choosebtn:SetTall(20)
		if (browse_type == "model") then
			choosebtn:SetText("DO WANT THIS MODEL")
		elseif (browse_type == "material") then
			choosebtn:SetText("DO WANT THIS MATERIAL")
		end

		choosebtn.DoClick = function()
			if (wep.browser_callback) then
				pcall(wep.browser_callback, selected)
			end
			if (wep.Frame) then
				wep.Frame:SetVisible(true)
			end
			browser:Close()
		end
	choosebtn:DockMargin(0,0,0,5)
	choosebtn:Dock(BOTTOM)



	local LoadDirectories
	local AddNode = function( base, dir, tree_override )

		local newpath = base.."/"..dir
		local basenode = nodelist[base]

		if (tree_override) then
			newpath = dir
			basenode = tree_override
		end

		if (!basenode) then
			print("No base node for \""..tostring(base).."\", \""..tostring(dir).."\", "..tostring(tree_override))
		end

		nodelist[newpath] = basenode:AddNode( dir )
		nodelist[newpath].DoClick = function()
			LoadDirectories( newpath )
			modlist:Clear()
			modlist:SetVisible(true)

			if (filecache[newpath]) then
				for k, f in pairs(filecache[newpath]) do
					modlist:AddLine(f)
				end
			else
				filecache[newpath] = {}
				local files, folders
				if (newpath:sub(1,9) == "materials") then
					files, folders = file.Find(newpath.."/*.vmt", "GAME")
				else
					files, folders = file.Find(newpath.."/*.mdl", "GAME")
				end
				table.sort(files)
				for k, f in pairs(files) do
					local newfilepath = newpath.."/"..f
					modlist:AddLine(newfilepath)
					table.insert(filecache[newpath], newfilepath)
				end
			end
		end

	end

	if (browse_type == "model") then
		AddNode( "", "models", tree )
	elseif (browse_type == "material") then
		AddNode( "", "materials", tree )
	end

	LoadDirectories = function( v )

		if (table.HasValue(checked,v)) then return end
		local files
		files, newdirs = file.Find(v.."/*", "GAME")
		table.insert(checked, v)

		table.sort(newdirs)

		for _, dir in pairs(newdirs) do
			AddNode( v, dir )
		end

	end

	if (browse_type == "model") then
		LoadDirectories( "models" )
	elseif (browse_type == "material") then
		LoadDirectories( "materials" )
	end

	browser:SetVisible( true )
	browser:MakePopup()

end

--[[**************************
			Menu
**************************]]
local function CreateMenu( preset )

	local wep = GetSCKSWEP( LocalPlayer() )
	if !IsValid(wep) then return nil end

	wep.save_data = table.Copy(save_data_template)

	if (preset) then
		-- use the preset
		for k, v in pairs( preset ) do
			wep.save_data[k] = v
		end
	end

	-- Now for the actual menu:
	local f = vgui.Create("DFrame")
	f:SetSize( 480, ScrH()*0.8 )
	f:SetPos( 50, 50 )
	f:SetTitle( "SWEP Construction Kit" )
	f:SetDraggable( true )
	f:ShowCloseButton( true )
	f:SetSizable( true )
	f:SetDeleteOnClose( false )
	// this will stay here until I'll get a better idea (walks away with a crucible)
	f.Think = function( self )
		local mx, my = gui.MouseX(), gui.MouseY()
		local w, h = self:GetWide(), self:GetTall()
		local x, y = self:GetPos()
		
		local inside = mx > x and mx < ( x + w ) and my > y and my < ( y + h ) and !( input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_LSHIFT ) )
		
		//self:SetKeyboardInputEnabled( inside )
		//self:SetMouseInputEnabled( inside )
		
	end

	local mpanel = vgui.Create( "DPanel", f )
		mpanel:SetDrawBackground(false)
		mpanel:SetTooltip("Hold CTRL to enter elements drag mode.\nHold SHIFT to enter element rotation mode.\n\n  - Hold RMB for 2D axis mode.\n  - Hold LMB and RMB for 1D axis mode.\n  - Use SCROLL WHEEL to adjust drag sensitivity.")
		mpanel:SetTall(20)
	mpanel:DockMargin(0,0,0,5)
	mpanel:Dock(TOP)
	
	local mlabel = vgui.Create( "DLabel", mpanel )
		mlabel:SetText( "Elements drag mode:" )
		mlabel:SetTooltip("Hold CTRL to enter elements drag mode.\nHold SHIFT to enter element rotation mode.\n\n  - Hold RMB for 2D axis mode.\n  - Hold LMB and RMB for 1D axis mode.\n  - Use SCROLL WHEEL to adjust drag sensitivity.")
		mlabel:SizeToContents()
		mlabel:SetTall(20)
	mlabel:DockMargin(5,0,0,0)
	mlabel:Dock(LEFT)
	
	local msnap = vgui.Create( "DNumberWang", mpanel )
		msnap:SetTooltip("Angle snap value\n\nExtremely janky! Use at your own risk!")
		msnap:SizeToContents()
		msnap:SetTall(20)
		msnap:SetMin(0)
		msnap:SetMax(90)
		msnap:SetValue( wep.ModelDragAngleSnap )
		msnap.OnValueChanged = function( p )
			wep.ModelDragAngleSnap = p:GetValue()
		end
	msnap:DockMargin(5,0,0,0)
	msnap:Dock(RIGHT)
	
	local mlabel2 = vgui.Create( "DLabel", mpanel )
		mlabel2:SetText( "Angle snap" )
		mlabel2:SizeToContents()
		mlabel2:SetTall(20)
	mlabel2:DockMargin(5,0,0,0)
	mlabel2:Dock(RIGHT)
	
	local mdraglist = vgui.Create( "DComboBox", mpanel )
		mdraglist:SetWide(150)
		mdraglist:SetTooltip("Hold CTRL to enter elements drag mode.\nHold SHIFT to enter element rotation mode.\n\n  - Hold RMB for 2D axis mode.\n  - Hold LMB and RMB for 1D axis mode.\n  - Use SCROLL WHEEL to adjust drag sensitivity.")
		mdraglist.OnSelect = function( p, index, value )
			wep.selectedModelDragMode = value
		end
		mdraglist:SetText( wep.selectedModelDragMode )
	mdraglist:DockMargin(5,0,0,0)
	mdraglist:Dock(FILL)
	
	for k, v in pairs( model_drag_modes ) do
		mdraglist:AddChoice(k)
	end
	
	local tpanel= vgui.Create( "DPanel", f )
		tpanel:SetDrawBackground(false)
		tpanel:SetTall(20)
	tpanel:DockMargin(0,0,0,5)
	tpanel:Dock(TOP)

	local tpsbonelist = vgui.Create( "DComboBox", tpanel )
		tpsbonelist:SetWide(150)
		tpsbonelist:SetTooltip("Bone to focus third person view on")
		tpsbonelist.OnSelect = function( p, index, value )
			wep.tpsfocusbone = value
		end
		tpsbonelist:SetText( wep.tpsfocusbone )
	tpsbonelist:DockMargin(5,0,0,0)
	tpsbonelist:Dock(RIGHT)

	local tlabel = vgui.Create( "DLabel", tpanel )
		tlabel:SetText( "Focus:" )
		tlabel:SizeToContents()
		tlabel:SetTall(20)
	tlabel:DockMargin(10,0,0,0)
	tlabel:Dock(RIGHT)

	PopulateBoneList( tpsbonelist, LocalPlayer() )

	local tbtn = vgui.Create( "DButton", tpanel )
		tbtn:SetText( "Toggle thirdperson" )
		tbtn.DoClick = function()
			RunConsoleCommand("swepck_togglethirdperson")
		end

	tbtn:Dock(FILL)	
	
	local lock = vgui.Create( "DCheckBoxLabel", f )
	lock:SetTall( 20 )
	lock:SetText( "Lock viewmodel in world space" )
	lock.OnChange = function(self)
		wep.LockViewmodel = self:GetChecked()
	end
	lock:SetValue(0)
	lock:DockMargin(0,0,0,5)
	lock:Dock(TOP)
	
	

	local tab = vgui.Create( "DPropertySheet", f )

		wep.ptool = vgui.Create("DScrollPanel", tab)
		wep.ptool.Paint = function() surface.SetDrawColor(70,70,70,255) surface.DrawRect(0,0,wep.ptool:GetWide(),wep.ptool:GetTall()) end
		wep.pweapon = vgui.Create("DPanel", tab)
		wep.pweapon.Paint = function() surface.SetDrawColor(70,70,70,255) surface.DrawRect(0,0,wep.pweapon:GetWide(),wep.pweapon:GetTall()) end
		wep.pironsight = vgui.Create("DPanel", tab)
		wep.pironsight.Paint = function() surface.SetDrawColor(70,70,70,255) surface.DrawRect(0,0,wep.pironsight:GetWide(),wep.pironsight:GetTall()) end
		wep.pmodels = vgui.Create("DPanel", tab)
		wep.pmodels.Paint = function() surface.SetDrawColor(70,70,70,255) surface.DrawRect(0,0,wep.pmodels:GetWide(),wep.pmodels:GetTall()) end
		wep.pwmodels = vgui.Create("DPanel", tab)
		wep.pwmodels.Paint = function() surface.SetDrawColor(70,70,70,255) surface.DrawRect(0,0,wep.pwmodels:GetWide(),wep.pwmodels:GetTall()) end

		tab:AddSheet( "Tool", wep.ptool, nil, false, false, "Modify tool settings" )
		tab:AddSheet( "Weapon", wep.pweapon, nil, false, false, "Modify weapon settings" )
		tab:AddSheet( "Ironsights", wep.pironsight, nil, false, false, "Modify ironsights" )
		tab:AddSheet( "View Models", wep.pmodels, nil, false, false, "Modify view models" )
		tab:AddSheet( "World Models", wep.pwmodels, nil, false, false, "Modify world models" )

		wep.ptool:DockPadding(5, 5, 5, 5)
		wep.pweapon:DockPadding(5, 5, 5, 5)
		wep.pironsight:DockPadding(5, 5, 5, 5)
		wep.pmodels:DockPadding(5, 5, 5, 5)
		wep.pwmodels:DockPadding(5, 5, 5, 5)

	tab:Dock(FILL)

	--[[****************
		Tool page
	****************]]
	include("weapons/"..wep:GetClass().."/menu/tool.lua")

	--[[****************
		Weapon page
	****************]]
	include("weapons/"..wep:GetClass().."/menu/weapon.lua")

	--[[********************
		Ironsights page
	********************]]
	include("weapons/"..wep:GetClass().."/menu/ironsights.lua")

	--[[***************************************
		View models and World models page
	***************************************]]
	include("weapons/"..wep:GetClass().."/menu/models.lua")

	-- finally, return the frame!
	return f

end

function SWEP:OpenMenu( preset )
	if (!self.Frame) then
		self.Frame = CreateMenu( preset )
	end

	if (IsValid(self.Frame)) then
		self.Frame:SetVisible(true)
		self.Frame:MakePopup()
	else
		self.Frame = nil
	end

end

function SWEP:OnRemove()
	self:CleanMenu()
end

function SWEP:OnDropWeapon()
	self.useThirdPerson = false
	self.LastOwner = nil
	if (!self.Frame) then return end
	self.Frame:Close()
end

function SWEP:CleanMenu()
	self:RemoveModels()
	if (!self.Frame) then return end

	self.v_modelListing = nil
	self.w_modelListing = nil
	self.v_panelCache = {}
	self.w_panelCache = {}
	self.Frame:Remove()
	self.Frame = nil
end

function SWEP:HUDShouldDraw( el )
	return el != "CHudAmmo" and el != "CHudSecondaryAmmo"
end

--[[**************************
	Third person view
**************************]]
function TPCalcView(pl, pos, angles, fov)

	local wep = pl:GetActiveWeapon()
	if (!IsValid(wep) or !wep.IsSCK or !wep.useThirdPerson) then
		wep.useThirdPerson = false
		return
	end

	local look_pos = pos
	local rhand_bone = pl:LookupBone(wep.tpsfocusbone)
	if (rhand_bone) then
		look_pos = pl:GetBonePosition( rhand_bone )
	end

	local view = {}
	view.origin = look_pos + ((pl:GetAngles()+wep.thirdPersonAngle):Forward()*wep.thirdPersonDis)
	view.angles = (look_pos - view.origin):Angle()
	view.fov = fov
	
	wep.thirdPersonAngleView = view.angles * 1

	return view
end

oldCVHooks = {}
hooksCleared = false
local function CVHookReset()

	--print("Hook reset")
	hook.Remove( "CalcView", "TPCalcView" )
	for k, v in pairs( oldCVHooks ) do
		hook.Add("CalcView", k, v)
	end
	oldCVHooks = {}
	hooksCleared = false

end

function SWEP:CalcViewHookManagement()

	if (!hooksCleared) then

		local CVHooks = hook.GetTable()["CalcView"]
		if CVHooks then

			for k, v in pairs( CVHooks ) do
				oldCVHooks[k] = v
				hook.Remove( "CalcView", k )
			end

		end

		hook.Add("CalcView", "TPCalcView", TPCalcView)
		hooksCleared = true
	else
		timer.Create("CVHookReset", 2, 1, CVHookReset)
	end

end

hook.Add("ShouldDrawLocalPlayer", "ThirdPerson", function(pl)
	local wep = pl:GetActiveWeapon()
	if (wep.useThirdPerson) then
		return true
	end
end)