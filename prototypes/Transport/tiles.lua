data:extend(
{
	-- Water tiles used for bridges
	{
    type = "tile",
    name = "RW_deepwater-walkable",
    collision_mask = {"ground-tile"},
    layer = 49,
	autoplace = {influence = -1000},
	order = "x[water]-d[deep]",
    variants =
    {
		main =
		{
			{
				picture = "__base__/graphics/terrain/deepwater/deepwater1.png",
				count = 8,
				size = 1
			},
			{
				picture = "__base__/graphics/terrain/deepwater/deepwater2.png",
				count = 8,
				size = 2
			},
			{
				picture = "__base__/graphics/terrain/deepwater/deepwater4.png",
				count = 6,
				size = 4
			}
		},
		inner_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-inner-corner.png",
			count = 6
		},
		outer_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-outer-corner.png",
			count = 6
		},
		side =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-side.png",
			count = 8
		}
	},
    allowed_neighbors = { "RW_water-walkable", "grass" },
	--allowed_neighbors = { "RW_water-walkable" },
    map_color={r=0.0941, g=0.2823, b=0.345}
  },

  {
    type = "tile",
    name = "RW_deepwater-green-walkable",
    collision_mask = {"ground-tile"},
    layer = 49,
	autoplace = {influence = -1000},
	order = "x[water]-d[deep]",
    variants =
    {
		main =
		{
			{
				picture = "__base__/graphics/terrain/deepwater-green/deepwater-green1.png",
				count = 8,
				size = 1
			},
			{
				picture = "__base__/graphics/terrain/deepwater-green/deepwater-green2.png",
				count = 8,
				size = 2
			},
			{
				picture = "__base__/graphics/terrain/deepwater-green/deepwater-green4.png",
				count = 6,
				size = 4
			}
		},
		inner_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-green-inner-corner.png",
			count = 6
		},
		outer_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-green-outer-corner.png",
			count = 6
		},
		side =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/deepwater-green-side.png",
			count = 8
		}
    },
    allowed_neighbors = { "RW_water-green-walkable", "grass" },
	--allowed_neighbors = { "RW_water-green-walkable" },
    map_color={r=0.0941, g=0.149, b=0.066}
  },

  {
    type = "tile",
    name = "RW_water-walkable",
    collision_mask = {"ground-tile"},
    layer = 48,
	autoplace = {influence = -1000},
	order = "x[water]-s[shallow]",
    variants =
    {
		main =
		{
			{
				picture = "__base__/graphics/terrain/water/water1.png",
				count = 8,
				size = 1
			},
			{
				picture = "__base__/graphics/terrain/water/water2.png",
				count = 8,
				size = 2
			},
			{
				picture = "__base__/graphics/terrain/water/water4.png",
				count = 6,
				size = 4
			}
		},
		inner_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-inner-corner.png",
			count = 6
		},
		outer_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-outer-corner.png",
			count = 6
		},
		side =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-side.png",
			count = 8
		}
    },
    allowed_neighbors = { "grass" },
    map_color={r=0.0941, g=0.3568, b=0.4196}
  },

  {
    type = "tile",
    name = "RW_water-green-walkable",
    collision_mask = {"ground-tile"},
    layer = 48,
	autoplace = {influence = -1000},
	order = "x[water]-s[shallow]",
    variants =
    {
		main =
		{
			{
				picture = "__base__/graphics/terrain/water-green/water-green1.png",
				count = 8,
				size = 1
			},
			{
				picture = "__base__/graphics/terrain/water-green/water-green2.png",
				count = 8,
				size = 2
			},
			{
				picture = "__base__/graphics/terrain/water-green/water-green4.png",
				count = 6,
				size = 4
			}
		},
		inner_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-green-inner-corner.png",
			count = 6
		},
		outer_corner =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-green-outer-corner.png",
			count = 6
		},
		side =
		{
			picture = "__PHX__/graphics/transport/terrain/walkableWater/water-green-side.png",
			count = 8
		}
    },
	allowed_neighbors = { "grass" },
    map_color={r=31, g=48, b=18}
  }
}
)

data.raw.tile["deepwater"].allowed_neighbors = { "RW_deepwater-walkable", "RW_water-walkable", "water"}
data.raw.tile["deepwater-green"].allowed_neighbors = { "RW_deepwater-green-walkable", "RW_water-green-walkable", "water-green" }
data.raw.tile["water"].allowed_neighbors = { "RW_deepwater-walkable", "RW_water-walkable", "grass" }
data.raw.tile["water-green"].allowed_neighbors = { "RW_deepwater-green-walkable", "RW_water-green-walkable", "grass" }