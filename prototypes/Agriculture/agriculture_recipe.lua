data:extend
({

-- Treefarm lite
	
  {
    type = "recipe",
    name = "tf-field",
    ingredients = {{"stone",20},{"wooden-chest",1},{"burner-inserter",1}},
    result = "tf-field",
    result_count = 1,
    enabled = "true"
  },
  
  {
    type = "recipe-category",
    name = "treefarm-mod-dummy"
  },
  
  {
    type = "recipe",
    name = "tf-fieldmk2",
    ingredients = {{"advanced-circuit",20},{"red-wire",20},{"steel-plate",20}},
    result = "tf-fieldmk2",
    result_count = 1,
    enabled = "false"
  },
  
  {
    type = "recipe",
    name = "tf-coral-seed",
    ingredients = {{"raw-wood",1}},
    result = "tf-coral-seed",
    result_count = 1
  },
  
   {
    type = "recipe",
    name = "tf-germling",
    ingredients = {{"raw-wood",1}},
    result = "tf-germling",
    result_count = 1
  },
  
-- Arbres Dytech

  {
    type = "recipe",
    name = "sulfur-seed",
    energy_required = 1,
    ingredients = 
	{
	  {"sulfur-wood", 1},
	},
    result = "sulfur-seed"
  },
  {
    type = "recipe",
    name = "sulfur-from-wood",
    energy_required = 1,
    ingredients = 
	{
	  {"sulfur-wood", 1},
	},
    result = "sulfur",
	result_count = 2
  },

{
    type = "recipe",
    name = "rubber-seed",
    energy_required = 1,
    ingredients = 
	{
	  {"resin", 1}
	},
    result = "rubber-seed"
  },

 {
    type = "recipe",
    name = "raw-wood-centrifuge",
    icon = "__base__/graphics/icons/raw-wood.png",
    category = "centrifuge",
    energy_required = 7.5,
    subgroup = "raw-material",
	enabled = false,
    ingredients =
    {
	  {type="item", name="raw-wood", amount=1},
    },
    results = 
    {
      {type="item", name="wood", amount_min=2, amount_max=2, probability=0.5},
      {type="item", name="sulfur-seed", amount_min=1, amount_max=1, probability=0.2},
      {type="item", name="rubber-seed", amount_min=1, amount_max=2, probability=0.2},
	}
  },  
  
  -- Produits Dytech
  
   {
    type = "recipe",
    name = "rubber",
    category = "smelting",
    energy_required = 3.5,
    ingredients = 
	{
	  {"resin", 1}
	},
    result = "rubber"
  },
  
  -- Centrifugeuse Dytech
  
    {
   	type = "recipe",
   	name = "centrifuge",
	energy_required = 10,
    enabled = false,
	ingredients = 
	{ 
	  {"iron-plate", 25},
	  {"steel-plate", 10},
	  {"iron-gear-wheel", 25},
	  {"copper-cable", 10}
	},
   	result = "centrifuge",
  },
  
})