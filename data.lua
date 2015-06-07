-- fonctionne 07 juin 2015

-- Agriculture (Treefarm lite)

require("prototypes.Agriculture.agriculture_entity")
require("prototypes.Agriculture.agriculture_recipe")
require("prototypes.Agriculture.agriculture_item")
require("prototypes.Agriculture.agriculture_technology")
require("prototypes.groupe.item-group-agriculture")

-- Transport (roadworks)
require("prototypes.Transport.autoplace-controls")

require("prototypes.Transport.transport_entity")
require("prototypes.Transport.transport_recipes")
require("prototypes.Transport.transport_item")
require("prototypes.Transport.transport_technologie")

require("prototypes.Transport.tiles")
require("prototypes.Transport.resources")
require("prototypes.Transport.noise-layers")

         -- Productivity module fix Roadwork

					for k, v in pairs(data.raw.module) do
							if v.name:find("productivity%-module") and v.limitation then
									table.insert(v.limitation, "RW_quicklime")
									table.insert(v.limitation, "RW_concrete")
									table.insert(v.limitation, "RW_asphalt")
									table.insert(v.limitation, "RW_high-octane-fuel")
							end
					end
