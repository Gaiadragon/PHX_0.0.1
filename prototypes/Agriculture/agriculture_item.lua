data:extend
({
--fonctionnel 06 juin 2015
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
  
  -- Graines
  
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
  
 })