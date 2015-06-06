data:extend
({

-- TreeFarm lite

  -- Field MK1
  {
    type = "item",
    name = "tf-field",
    icon = "__PHX__/graphics/agriculture/icons/field.png",
    flags = {"goes-to-quickbar"},
    subgroup = "tf-buildings",
    order = "a[field]",
    place_result = "tf-field",
    stack_size = 100
  },
  
   -- Field MK2
  {
    type = "item",
    name = "tf-fieldmk2",
    icon = "__PHX__/graphics/agriculture/icons/fieldmk2.png",
    flags = {"goes-to-quickbar"},
    subgroup = "tf-buildings",
    order = "b[fieldmk2]",
    place_result = "tf-fieldmk2Overlay",
    stack_size = 100
  },
  
  -- Graines TF
  
   {
    type = "item",
    name = "tf-coral-seed",
    icon = "__PHX__/graphics/agriculture/icons/coral-seed.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-seeds",
    order = "b[coral]",
    place_result = "tf-coral-seed",
    fuel_value = "1MJ",
    stack_size = 500
  },
  
  {
    type = "item",
    name = "tf-germling",
    icon = "__PHX__/graphics/agriculture/icons/germling.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-seeds",
    order = "a[germling]",
    place_result = "tf-germling",
    fuel_value = "1MJ",
    stack_size = 50
  },
  

-- arbres Dytech

	
	 {
    type = "item",
    name = "rubber-seed",
    icon = "__PHX__/graphics/agriculture/rubber-tree/icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-seeds",
    order = "rubber-seed",
    place_result = "rubber-seed",
    fuel_value = "1MJ",
    stack_size = 5000
     },
	 
	  {
    type = "item",
    name = "sulfur-seed",
    icon = "__PHX__/graphics/agriculture/sulfur-tree/icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-seeds",
    order = "sulfur-seed",
    place_result = "sulfur-seed",
    fuel_value = "1MJ",
    stack_size = 500
  },
  
  {
    type = "item",
    name = "sulfur-wood",
    icon = "__PHX__/graphics/agriculture/sulfur-tree/wood.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-buildings",
    order = "sulfur-wood",
    fuel_value = "5MJ",
    stack_size = 5000
  },
  
 -- produits Dytech
 
  {
    type = "item",
    name = "rubber",
    icon = "__PHX__/agriculture/graphics/intermediates/rubber.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-buildings",
    order = "[z]rubber",
    stack_size = 2000
  },
  {
    type = "item",
    name = "resin",
    icon = "__PHX__/graphics/agriculture/intermediates/resin.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-buildings",
    order = "[z]resin",
    stack_size = 500
  },
  
  -- centrifugeuse Dytech
  
    {
	type= "item",
	name= "centrifuge",
	icon = "__CORE-DyTech-Core__/graphics/metallurgy/icons/centrifuge.png",
	flags= {"goes-to-quickbar"},
	order= "a[centrifuge-mk1]",
	subgroup = "tf-buildings",
	place_result= "centrifuge",
	stack_size= 10,
  },
  
 })