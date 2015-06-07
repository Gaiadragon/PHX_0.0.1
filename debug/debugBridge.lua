-- fonctionne 07 juin 2015
-- Change this to true to see the underlying special tiles under bridges
local bridgeXRay = true

if bridgeXRay then
	data.raw.tile["RW_deepwater-walkable"].variants.main[1].picture = "__base__/graphics/terrain/dirt/dirt1.png"
	data.raw.tile["RW_deepwater-walkable"].variants.main[1].count = 22
	data.raw.tile["RW_deepwater-walkable"].variants.main[2].picture = "__base__/graphics/terrain/dirt/dirt2.png"
	data.raw.tile["RW_deepwater-walkable"].variants.main[2].count = 30
	data.raw.tile["RW_deepwater-walkable"].variants.main[3].picture = "__base__/graphics/terrain/dirt/dirt4.png"
	data.raw.tile["RW_deepwater-walkable"].variants.main[3].count = 21
	data.raw.tile["RW_deepwater-walkable"].variants.main[3].line_length = 11

	data.raw.tile["RW_deepwater-walkable"].variants["inner_corner"].picture = "__base__/graphics/terrain/dirt/dirt-inner-corner.png"
	data.raw.tile["RW_deepwater-walkable"].variants["inner_corner"].count = 8
	data.raw.tile["RW_deepwater-walkable"].variants["outer_corner"].picture = "__base__/graphics/terrain/dirt/dirt-outer-corner.png"
	data.raw.tile["RW_deepwater-walkable"].variants["outer_corner"].count = 8
	data.raw.tile["RW_deepwater-walkable"].variants.side.picture = "__base__/graphics/terrain/dirt/dirt-side.png"
	data.raw.tile["RW_deepwater-walkable"].variants.side.count = 8

	-- ###

	data.raw.tile["RW_deepwater-green-walkable"].variants.main[1].picture = "__base__/graphics/terrain/dirt/dirt1.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[1].count = 22
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[2].picture = "__base__/graphics/terrain/dirt/dirt2.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[2].count = 30
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[3].picture = "__base__/graphics/terrain/dirt/dirt4.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[3].count = 21
	data.raw.tile["RW_deepwater-green-walkable"].variants.main[3].line_length = 11

	data.raw.tile["RW_deepwater-green-walkable"].variants["inner_corner"].picture = "__base__/graphics/terrain/dirt/dirt-inner-corner.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants["inner_corner"].count = 8
	data.raw.tile["RW_deepwater-green-walkable"].variants["outer_corner"].picture = "__base__/graphics/terrain/dirt/dirt-outer-corner.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants["outer_corner"].count = 8
	data.raw.tile["RW_deepwater-green-walkable"].variants.side.picture = "__base__/graphics/terrain/dirt/dirt-side.png"
	data.raw.tile["RW_deepwater-green-walkable"].variants.side.count = 8

	-- ### ###

	data.raw.tile["RW_water-walkable"].variants.main[1].picture = "__base__/graphics/terrain/sand/sand1.png"
	data.raw.tile["RW_water-walkable"].variants.main[1].count = 16
	data.raw.tile["RW_water-walkable"].variants.main[2].picture = "__base__/graphics/terrain/sand/sand2.png"
	data.raw.tile["RW_water-walkable"].variants.main[2].count = 16
	data.raw.tile["RW_water-walkable"].variants.main[3].picture = "__base__/graphics/terrain/sand/sand4.png"
	data.raw.tile["RW_water-walkable"].variants.main[3].count = 22
	data.raw.tile["RW_water-walkable"].variants.main[3].line_length = 11

	data.raw.tile["RW_water-walkable"].variants["inner_corner"].picture = "__base__/graphics/terrain/sand/sand-inner-corner.png"
	data.raw.tile["RW_water-walkable"].variants["inner_corner"].count = 8
	data.raw.tile["RW_water-walkable"].variants["outer_corner"].picture = "__base__/graphics/terrain/sand/sand-outer-corner.png"
	data.raw.tile["RW_water-walkable"].variants["outer_corner"].count = 8
	data.raw.tile["RW_water-walkable"].variants.side.picture = "__base__/graphics/terrain/sand/sand-side.png"
	data.raw.tile["RW_water-walkable"].variants.side.count = 8

	-- ###

	data.raw.tile["RW_water-green-walkable"].variants.main[1].picture = "__base__/graphics/terrain/sand/sand1.png"
	data.raw.tile["RW_water-green-walkable"].variants.main[1].count = 16
	data.raw.tile["RW_water-green-walkable"].variants.main[2].picture = "__base__/graphics/terrain/sand/sand2.png"
	data.raw.tile["RW_water-green-walkable"].variants.main[2].count = 16
	data.raw.tile["RW_water-green-walkable"].variants.main[3].picture = "__base__/graphics/terrain/sand/sand4.png"
	data.raw.tile["RW_water-green-walkable"].variants.main[3].count = 22
	data.raw.tile["RW_water-green-walkable"].variants.main[3].line_length = 11

	data.raw.tile["RW_water-green-walkable"].variants["inner_corner"].picture = "__base__/graphics/terrain/sand/sand-inner-corner.png"
	data.raw.tile["RW_water-green-walkable"].variants["inner_corner"].count = 8
	data.raw.tile["RW_water-green-walkable"].variants["outer_corner"].picture = "__base__/graphics/terrain/sand/sand-outer-corner.png"
	data.raw.tile["RW_water-green-walkable"].variants["outer_corner"].count = 8
	data.raw.tile["RW_water-green-walkable"].variants.side.picture = "__base__/graphics/terrain/sand/sand-side.png"
	data.raw.tile["RW_water-green-walkable"].variants.side.count = 8
	
	-- Make bridges transparent
	data.raw["simple-entity"]["RW_concrete-bridge"].picture.filename = "__RoadWorks__/debug/graphics/debugBridge.png"
	data.raw["simple-entity"]["RW_concrete-bridge"].picture.width = 64
	data.raw["simple-entity"]["RW_concrete-bridge"].picture.height = 64
	data.raw["simple-entity"]["RW_concrete-bridge"].picture.shift = {0, 0}
end











