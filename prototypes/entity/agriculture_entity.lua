data:extend
({

-- Treefarm lite

	-- Champ MK 1

 {
    type = "furnace",
    name = "tf-field",
    max_health = 100,
    icon = "__PHX__/graphics/icons/field.png",
    flags = {"placeable-neutral", "player-creation"},
    crafting_categories = {"treefarm-mod-dummy"},
    minable = {mining_time = 1,result = "tf-field"},
    collision_box = {{-0.5,-0.5},{0.5,0.5}},
    selection_box = {{0.75,-0.50},{9.0,7.50}},
    result_inventory_size = 1,
    energy_usage = "180kW",
    crafting_speed = 1,
    source_inventory_size = 1,
    energy_source =
    {
      type = "burner",
      effectivity = 1,
      fuel_inventory_size = 1
    },
    animation =
    {
      filename = "__PHX__/graphics/entities/field/field.png",
      priority = "extra-high",
      width = 512,
      height = 512,
      frame_count = 1,
      shift = {1.20, -0.30}
    },
    working_visualisations =
    {
      filename = "__PHX__/graphics/icons/empty.png",
      priority = "extra-high",
      width = 32,
      height = 32,
      frame_count = 1,
      shift = {0.0, 0.0}
    }
  },
  
	-- Champ MK 2
	
 {
    type = "container",
    name = "tf-fieldmk2Overlay",
    max_health = 100,
    icon = "__PHX__/graphics/icons/fieldmk2.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1,result = "tf-fieldmk2"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    inventory_size = 1,
    picture =
    {
      filename = "__PHX__/graphics/entities/fieldmk2/fieldmk2Overlay.png",
      priority = "extra-high",
      width = 640,
      height = 640,
      shift = {0.0, 0.0}
    }
  },

  {
    type = "logistic-container",
    name = "tf-fieldmk2",
    logistic_mode = "requester",
    order = "c[fieldmk2]",
    max_health = 100,
    icon = "__PHX__/graphics/icons/fieldmk2.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1,result = "tf-fieldmk2"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    drawing_box = {{-2.8, -0.5}, {0.5, 0.5}},
    inventory_size = 2,
    picture =
    {
      filename = "__PHX__/graphics/entities/fieldmk2/fieldmk2.png",
      priority = "extra-high",
      width = 70,
      height = 170,
      shift = {0.0, -1.5}
    }
  },
  
  -- Corail 
  
  {
		type = "tree",
		name = "tf-coral-seed",
		icon = "__PHX__/graphics/icons/coral-seed.png",
		flags = {"placeable-neutral", "breaths-air"},
		emissions_per_tick = -0.0001,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.1,
			result = "tf-coral-seed"
		},
		max_health = 10,
		collision_box = {{-0.01, -0.01}, {0.01, 0.01}},
		selection_box = {{-0.1, -0.1}, {0.1, 0.1}},
		drawing_box = {{0.0, 0.0}, {1.0, 1.0}},
		pictures =
		{
			{
				filename = "__PHX__/graphics/entities/coral/coral-seed.png",
				priority = "extra-high",
				width = 9,
				height = 12,
				shift = {0.0, 0.0}
			}
		}
	},

	{
		type = "tree",
		name = "tf-small-coral",
		icon = "__PHX__/graphics/icons/coral-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0002,
		minable =
		{
			count = 1,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "raw-wood"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__PHX__/graphics/entities/coral/small-coral-01.png",
				priority = "extra-high",
				width = 19,
        height = 23,
        shift = {0.4 / 4.5, -0.4 / 4.5}
			},
			{
				filename = "__PHX__/graphics/entities/coral/small-coral-02.png",
				priority = "extra-high",
				width = 26,
        height = 32,
        shift = {0.7 / 4.5, -0.05 / 4.5}
			},
			{
				filename = "__PHX__/graphics/entities/coral/small-coral-03.png",
				priority = "extra-high",
				width = 14,
        height = 18,
        shift = {0.2 / 4.5, 0 / 4.5}
			}
		}
	},

	{
		type = "tree",
		name = "tf-medium-coral",
		icon = "__PHX__/graphics/icons/coral-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0003,
		minable =
		{
			count = 2,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "raw-wood"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__PHX__/graphics/entities/coral/medium-coral-01.png",
				priority = "extra-high",
				width = 29,
        height = 35,
        shift = {0.4 / 3.0, -0.4 / 3.0}
			},
			{
				filename = "__PHX__/graphics/entities/coral/medium-coral-02.png",
				priority = "extra-high",
				width = 39,
        height = 49,
        shift = {0.7 / 3.0, -0.05 / 3.0}
			},
			{
				filename = "__PHX__/graphics/entities/coral/medium-coral-03.png",
				priority = "extra-high",
				width = 21,
        height = 27,
        shift = {0.2 / 3.0, 0 / 3.0}
			}
		}
	},

	{
		type = "tree",
		name = "tf-mature-coral",
		icon = "__PHX__/graphics/icons/coral-seed.png",
		order="b-b-g",
		flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"},
		emissions_per_tick = -0.0003,
		minable =
		{
			count = 3,
			mining_particle = "wooden-particle",
			mining_time = 0.2,
			result = "raw-wood"
		},
		max_health = 20,
		collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
		selection_box = {{-0.2, -0.55}, {0.2, 0.2}},
		drawing_box = {{-0.2, -0.7}, {0.2, 0.2}},
		pictures =
		{
			{
				filename = "__PHX__/graphics/entities/coral/mature-coral-01.png",
				priority = "extra-high",
				width = 58,
        height = 69,
        shift = {0.4 / 2.0, -0.4 / 2.0}
			},
			{
				filename = "__PHX__/graphics/entities/coral/mature-coral-02.png",
				priority = "extra-high",
				width = 77,
        height = 97,
        shift = {0.7 / 2.0, -0.05 / 2.0}
			},
			{
				filename = "__PHX__/graphics/entities/coral/mature-coral-03.png",
				priority = "extra-high",
				width = 41,
        height = 54,
        shift = {0.2 / 2.0, 0 / 2.0}
			}
		}
	}
  
  })