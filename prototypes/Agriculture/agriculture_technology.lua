data:extend
({
--fonctionnel 06 juin 2015
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



})