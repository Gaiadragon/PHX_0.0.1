data:extend
({

-- Treefarm lite

{
    type = "technology",
    name = "tf-advanced-treefarming",
    icon = "__PHX__/graphics/icons/fieldmk2.png",
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



})