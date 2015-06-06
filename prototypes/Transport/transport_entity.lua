


--Roadworks fonctions




function makeBridgePlaceableEntity(entityName, health, pictureTable, iconFile)
	local picturePrototype = {
		filename = pictureTable.filename,
		priority = pictureTable.priority,
		width = pictureTable.width,
		height = pictureTable.height,
		shift = pictureTable.shift
	}
	
	local picturePrototypeInvis = {
		filename = pictureTable.filename,
		priority = pictureTable.priority,
		width = 1,
		height = 1,
	}
	
	local picturesTable = {}
	
	picturesTable["straight_rail_horizontal"] = {}
	picturesTable["straight_rail_horizontal"]["metals"] = picturePrototype
	picturesTable["straight_rail_horizontal"]["backplates"] = picturePrototypeInvis
	picturesTable["straight_rail_horizontal"]["ties"] = picturePrototypeInvis
	picturesTable["straight_rail_horizontal"]["stone_path"] = picturePrototypeInvis
	
	picturesTable["straight_rail_vertical"] = {}
	picturesTable["straight_rail_vertical"]["metals"] = picturePrototype
	picturesTable["straight_rail_vertical"]["backplates"] = picturePrototypeInvis
	picturesTable["straight_rail_vertical"]["ties"] = picturePrototypeInvis
	picturesTable["straight_rail_vertical"]["stone_path"] = picturePrototypeInvis
	
	picturesTable["straight_rail_diagonal"] = {}
	picturesTable["straight_rail_diagonal"]["metals"] = picturePrototype
	picturesTable["straight_rail_diagonal"]["backplates"] = picturePrototypeInvis
	picturesTable["straight_rail_diagonal"]["ties"] = picturePrototypeInvis
	picturesTable["straight_rail_diagonal"]["stone_path"] = picturePrototypeInvis
	
	picturesTable["curved_rail_horizontal"] = {}
	picturesTable["curved_rail_horizontal"]["metals"] = picturePrototype
	picturesTable["curved_rail_horizontal"]["backplates"] = picturePrototypeInvis
	picturesTable["curved_rail_horizontal"]["ties"] = picturePrototypeInvis
	picturesTable["curved_rail_horizontal"]["stone_path"] = picturePrototypeInvis
	
	picturesTable["curved_rail_vertical"] = {}
	picturesTable["curved_rail_vertical"]["metals"] = picturePrototype
	picturesTable["curved_rail_vertical"]["backplates"] = picturePrototypeInvis
	picturesTable["curved_rail_vertical"]["ties"] = picturePrototypeInvis
	picturesTable["curved_rail_vertical"]["stone_path"] = picturePrototypeInvis
	
	picturesTable["rail_endings"] = {}
	picturesTable["rail_endings"]["sheet"] = picturePrototypeInvis
	
	
	data:extend
	(
		{
			{
				type = "rail",
				name = entityName,
				icon = iconFile,
				collision_mask = {"object-layer"},
				flags = {"placeable-neutral", "player-creation"},
				max_health = health,
				collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
				selection_box = {{-1, -1}, {1, 1}},
				render_layer = "floor",
				order="r[road]-r["..entityName.."]",
				bending_type = "straight",
				rail_category = "regular",
				pictures = picturesTable
			}
		}
	)
end

function makeBridgeEntity(entityName, itemName, health, pictureTable, iconFile)
		
	data:extend
	(
		{
			{
				type = "simple-entity",
				name = entityName,
				icon = iconFile,
				collision_mask = {"object-layer"},
				minable = {hardness = 0.2, mining_time = 2.0, result = itemName},
				flags = {"placeable-neutral", "player-creation"},
				max_health = health,
				collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
				selection_box = {{-1, -1}, {1, 1}},
				render_layer = "floor",
				order="r[road]-r["..itemName.."]",
				picture =
				{
					filename = pictureTable.filename,
					priority = pictureTable.priority,
					width = pictureTable.width,
					height = pictureTable.height,
					count = pictureTable.count,
					shift = pictureTable.shift
				}
			}
		}
	)
end

function makeRoadTileEntities(entityName, textureTable, iconFile, isCenter)

	isCenter = isCenter or false

	local pictureTable = {}
	
	for i = 1, textureTable.variationCount do
		pictureTable[i] = {
			filename = textureTable.filename,
			priority = "low",
			width = textureTable.width,
			height = textureTable.height,
			count = 1,
			shift = textureTable.shift,
			--x = textureTable.x + ((i - 1) * textureTable.width),
			x = (i - 1) * textureTable.width,
			y = textureTable.y
		}
	end

	local layer = "resource"
	
	if (isCenter) then
		layer = "tile-transition"
	end
	
	data:extend
	(
		{
			{
				type = "simple-entity",
				name = entityName,
				icon = iconFile,
				collision_mask = {},
				minable = {mining_time = 1},
				resistances =
				{
					{ -- this is to prevent pavement getting destroyed by flamethrowers
						type = "fire",
						percent = 100
					}
				},
				flags = {"placeable-neutral", "not-on-map", "player-creation"},
				max_health = 1,
				selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
				tile_width = 1,
				tile_height = 1,
				render_layer = layer,
				order="r[road]-r["..entityName.."]",
				selectable_in_game = false,
				pictures = pictureTable
			}
		}
	)
end

function makeRoadTileEntitySet(entityNameBase, textureTableHub, iconFile, hasInnerCorners)

	makeRoadTileEntities(entityNameBase .. "-center", textureTableHub.pictureCenter, iconFile, true)
	makeRoadTileEntities(entityNameBase .. "-left-side", textureTableHub.pictureLeftSide, iconFile)
	makeRoadTileEntities(entityNameBase .. "-right-side", textureTableHub.pictureRightSide, iconFile)
	makeRoadTileEntities(entityNameBase .. "-top-side", textureTableHub.pictureTopSide, iconFile)
	makeRoadTileEntities(entityNameBase .. "-bottom-side", textureTableHub.pictureBottomSide, iconFile)

	makeRoadTileEntities(entityNameBase .. "-bottom-left-corner", textureTableHub.pictureBottomLeftCorner, iconFile)
	makeRoadTileEntities(entityNameBase .. "-bottom-right-corner", textureTableHub.pictureBottomRightCorner, iconFile)
	makeRoadTileEntities(entityNameBase .. "-top-left-corner", textureTableHub.pictureTopLeftCorner, iconFile)
	makeRoadTileEntities(entityNameBase .. "-top-right-corner", textureTableHub.pictureTopRightCorner, iconFile)

	if hasInnerCorners then
		makeRoadTileEntities(entityNameBase .. "-bottom-left-inner-corner", textureTableHub.pictureBottomLeftInnerCorner, iconFile)
		makeRoadTileEntities(entityNameBase .. "-bottom-right-inner-corner", textureTableHub.pictureBottomRightInnerCorner, iconFile)
		makeRoadTileEntities(entityNameBase .. "-top-left-inner-corner", textureTableHub.pictureTopLeftInnerCorner, iconFile)
		makeRoadTileEntities(entityNameBase .. "-top-right-inner-corner", textureTableHub.pictureTopRightInnerCorner, iconFile)
	end
	
end

-----

data:extend
(
	{
		{
			type = "simple-entity",
			name = "RW_concrete-pavement",
			icon = "__PHX__/graphics/transport/icons/concretePavement.png",
			collision_mask = {"resource-layer"},
			flags = {"placeable-neutral", "player-creation"},
			max_health = 50,
			collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
			selection_box = {{-1, -1}, {1, 1}},
			--selectable_in_game = false,
			render_layer = "floor",
			picture =
			{
				filename = "__PHX__/graphics/transport/entity/concretePavement/concretePavementPlaceable.png",
				priority = "medium",
				width = 64,
				height = 64,
				count = 1,
			}
		},
		{
			type = "simple-entity",
			name = "RW_asphalt-road",
			icon = "__PHX__/graphics/transport/icons/asphaltRoad.png",
			collision_mask = {"resource-layer"},
			flags = {"placeable-neutral", "player-creation"},
			max_health = 50,
			collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
			selection_box = {{-1, -1}, {1, 1}},
			--selectable_in_game = false,
			render_layer = "floor",
			picture =
			{
				filename = "__PHX__/graphics/transport/entity/asphaltRoad/asphaltRoadPlaceable.png",
				priority = "medium",
				width = 64,
				height = 64,
				count = 1,
			}
		},
		{
			type = "simple-entity",
			name = "RW_cobblestone-path",
			icon = "__PHX__/graphics/transport/icons/cobblestonePath.png",
			collision_mask = {"resource-layer"},
			flags = {"placeable-neutral", "player-creation"},
			max_health = 50,
			collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
			selection_box = {{-1, -1}, {1, 1}},
			--selectable_in_game = false,
			render_layer = "floor",
			picture =
			{
				filename = "__PHX__/graphics/transport/entity/cobblestonePath/cobblestonePathPlaceable.png",
				priority = "medium",
				width = 64,
				height = 64,
				count = 1,
				--shift = {0.25, 0 }
			},
		},
		{
			type = "simple-entity",
			name = "RW_road-blocker",
			icon = "__base__/graphics/icons/stone-furnace.png",
			collision_mask = {"resource-layer"},
			order="r[road]-r[misc]",
			resistances =
			{
				{ -- this is to prevent pavement getting destroyed by flamer fire
					type = "fire",
					percent = 100
				}
			},
			max_health = 1000,
			collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
			selection_box = {{-1, -1}, {1, 1}},
			selectable_in_game = false,
			render_layer = "floor",
			picture =
			{
				filename = "__base__/graphics/entity/stone-furnace/stone-furnace.png",
				priority = "medium",
				width = 1,
				height = 1,
				count = 1,
			}
		}
	}
)

---

local concreteBridgeHorCenter = 
{
	filename = "__PHX__/graphics/transport/entity/concreteBridge/concreteBridge_HorCenter.png",
	width = 64,
	height = 82,
	count = 1,
	shift = {0, 0}
}

-- The only one placeable by player
makeBridgePlaceableEntity("RW_concrete-bridge-placeable", 250, concreteBridgeHorCenter, "__PHX__/graphics/transport/icons/concreteBridge.png")
-- These ones are there for scripts
makeBridgeEntity("RW_concrete-bridge", "RW_concrete-bridge", 250, concreteBridgeHorCenter, "__PHX__/graphics/transport/icons/concreteBridge.png")

require("graphicTables.concretePavementGraphics")
require("graphicTables.cobblestonePathGraphics")
require("graphicTables.asphaltRoadGraphics")

makeRoadTileEntitySet("RW_concrete-pavement", concretePictureHub, "__PHX__/graphics/transport/icons/concretePavement.png", false)
makeRoadTileEntitySet("RW_cobblestone-path", cobblestonePictureHub, "__PHX__/graphics/transport/icons/concretePavement.png", false)
makeRoadTileEntitySet("RW_asphalt-road", asphaltPictureHub, "__PHX__/graphics/transport/icons/concretePavement.png", true)