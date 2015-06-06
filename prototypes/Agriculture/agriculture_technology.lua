data:extend
({

-- Treefarm lite

{
    type = "technology",
    name = "tf-advanced-treefarming",
    icon = "__PHX__/graphics/agriculture/icons/fieldmk2.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tf-fieldmk2"
      }
    },
    prerequisites =
    {
      "construction-robotics",
      "logistic-robotics"
    },
    unit =
    {
      count = 100,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 2}
      },
      time = 30
    }
  },

-- Dytech

 {
    type = "technology",
    name = "centrifuge",
    icon = "__CORE-DyTech-Core__/graphics/metallurgy/technology/centrifuge.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "centrifuge"
      },
      {
        type = "unlock-recipe",
        recipe = "raw-wood-centrifuge"
      },
    },
    prerequisites = {"oil-processing"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 30
    },
    order = "centrifuge",
  },

})