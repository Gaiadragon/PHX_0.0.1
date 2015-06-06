data:extend(
	{
		{
			type = "item",
			name = "RW_limestone",
			icon = "__PHX__/graphics/transport/icons/limestone.png",
			flags = {"goes-to-main-inventory"},
			subgroup = "raw-resource",
			order = "r[limestone]",
			stack_size = 50
		},
		{
			type = "item",
			name = "RW_quicklime",
			icon = "__PHX__/graphics/transport/icons/quicklime.png",
			flags = {"goes-to-main-inventory"},
			subgroup = "intermediate-product",
			order = "r[quicklime]",
			stack_size = 100
		},
		{
			type = "item",
			name = "RW_concrete",
			icon = "__PHX__/graphics/transport/icons/concrete.png",
			flags = {"goes-to-main-inventory"},
			subgroup = "intermediate-product",
			order = "r[concrete]",
			stack_size = 100
		},
		{
			type = "item",
			name = "RW_concrete-pavement",
			icon = "__PHX__/graphics/transport/icons/concretePavement.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "r[pavement]",
			place_result = "RW_concrete-pavement",
			stack_size = 500
		},
		{
			type = "item",
			name = "RW_asphalt",
			icon = "__PHX__/graphics/transport/icons/asphalt.png",
			flags = {"goes-to-main-inventory"},
			subgroup = "intermediate-product",
			order = "r[asphalt]",
			stack_size = 100
		},
		{
			type = "item",
			name = "RW_asphalt-road",
			icon = "__PHX__/graphics/transport/icons/asphaltRoad.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "r[asphaltroad]",
			place_result = "RW_asphalt-road",
			stack_size = 500
		},
		{
			type = "item",
			name = "RW_cobblestone-path",
			icon = "__PHX__/graphics/transport/icons/cobblestonePath.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "r[cobblestonepath]",
			place_result = "RW_cobblestone-path",
			stack_size = 500
		},
		{
			type = "item",
			name = "RW_high-octane-fuel",
			icon = "__PHX__/graphics/transport/icons/highOctaneFuel.png",
			flags = {"goes-to-main-inventory"},
			fuel_value = "30MJ",
			subgroup = "raw-resource",
			order = "r[highoctanefuel]",
			stack_size = 50
		},
		{
			type = "item",
			name = "RW_concrete-bridge",
			icon = "__PHX__/graphics/transport/icons/concreteBridge.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "r[concretebridge]",
			place_result = "RW_concrete-bridge-placeable",
			stack_size = 20
		}
	}
)