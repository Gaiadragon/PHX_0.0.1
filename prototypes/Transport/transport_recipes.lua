data:extend(
	{
		{
			type = "recipe",
			name = "RW_concrete-pavement",
			enabled = "false",
			ingredients = {{"RW_concrete", 4}},
			result = "RW_concrete-pavement",
			result_count = 4
		},
		{
			type = "recipe",
			name = "RW_quicklime",
			category = "smelting",
			enabled = "false",
			energy_required = 3.5,
			ingredients = {{"RW_limestone", 1}},
			result = "RW_quicklime"
		},
		{
			type = "recipe",
			name = "RW_concrete",
			category = "chemistry",
			energy_required = 1,
			enabled = "false",
			ingredients =
			{
				{type="item", name="RW_quicklime", amount=4},
				{type="item", name="stone", amount=1},
				{type="fluid", name="water", amount=4}
			},
			result = "RW_concrete",
			result_count = 4
		},
		{
			type = "recipe",
			name = "RW_asphalt",
			category = "chemistry",
			energy_required = 3,
			enabled = "false",
			ingredients =
			{
				{type="fluid", name="heavy-oil", amount=1}
			},
			result = "RW_asphalt",
			result_count = 2
		},
		{
			type = "recipe",
			name = "RW_asphalt-road",
			enabled = "false",
			ingredients = {{"RW_asphalt", 4}},
			result = "RW_asphalt-road",
			result_count = 4
		},
		{
			type = "recipe",
			name = "RW_cobblestone-path",
			ingredients = {{"stone-brick", 2}},
			result = "RW_cobblestone-path",
			result_count = 4
		},
		{
			type = "recipe",
			name = "RW_high-octane-fuel",
			category = "chemistry",
			energy_required = 10,
			enabled = "false",
			ingredients =
			{
				{type="item", name="solid-fuel", amount=4},
				{type="item", name="sulfur", amount=1},
			},
			result = "RW_high-octane-fuel",
			result_count = 2
		},
		{
			type = "recipe",
			name = "RW_concrete-bridge",
			ingredients = {{"RW_concrete", 1}},
			result = "RW_concrete-bridge",
			enabled = "false", -- disabled
		}
	}
)