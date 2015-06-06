-- Roadworks


data:extend(
{
	{
		type = "technology",
		name = "RW_hydraulic-cement",
		icon = "__PHX__/graphics/transport/technology/hydraulicCement.png",
		prerequisites = {"logistics"},
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "RW_quicklime"
			},
			{
				type = "unlock-recipe",
				recipe = "RW_concrete"
			},
			{
				type = "unlock-recipe",
				recipe = "RW_concrete-pavement"
			},
			{
				type = "unlock-recipe",
				recipe = "chemical-plant"
			}
		},
		unit =
		{
			count = 25,
			ingredients = {{"science-pack-1", 1}},
			time = 30
		},
		order = "r-a-a"
	},
	{
		type = "technology",
		name = "RW_road-networks",
		icon = "__PHX__/graphics/transport/technology/roadNetworks.png",
		prerequisites = {"automobilism", "RW_hydraulic-cement", "oil-processing"},
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "RW_asphalt"
			},
			{
				type = "unlock-recipe",
				recipe = "RW_asphalt-road"
			}
		},
		unit =
		{
			count = 50,
			ingredients = {{"science-pack-1", 1}, {"science-pack-2", 1}},
			time = 30
		},
		order = "r-a-b"
	},
	{
		type = "technology",
		name = "RW_advanced-automobilism",
		icon = "__PHX__/graphics/transport/technology/advancedAutomobilism.png",
		prerequisites = {"automobilism", "sulfur-processing"},
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "RW_high-octane-fuel"
			}
		},
		unit =
		{
			count = 125,
			ingredients = {{"science-pack-1", 2}, {"science-pack-2", 1}},
			time = 25
		},
		order = "r-a-c"
	}
}
)
