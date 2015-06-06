data:extend
({

-- TreeFarm lite

  -- Field MK1
  {
    type = "item",
    name = "tf-field",
    icon = "__PHX__/graphics/icons/field.png",
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
    icon = "__PHX__/graphics/icons/fieldmk2.png",
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
    icon = "__PHX__/graphics/icons/coral-seed.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "tf-seeds",
    order = "b[coral]",
    place_result = "tf-coral-seed",
    fuel_value = "1MJ",
    stack_size = 500
  },
  
 })