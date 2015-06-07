-- fonctionne 07 juin 2015

-- BASIC SETTINGS

-- list of pavement entities
RWsurfaceList = {"RW_cobblestone-path", "RW_concrete-pavement", "RW_asphalt-road"}

-- list of bridge entities
RWwalkableBridgeList = {"RW_concrete-bridge"}

-- how much is effectivity and total consumption modified by different fuels
RWfuelSpeedModifierList = {
	["RW_high-octane-fuel"] = {0.675, 2}, -- 200% consumption * 67.5% efficiency = 135% original speed (35% speed boost)
}

-- how much is friction modified by different surfaces
RWroadSpeedModifierList = {
	["RW_cobblestone-path"] = 0.85, -- 15% friction reduction
	["RW_concrete-pavement"] = 0.7, -- 30% friction reduction
	["RW_asphalt-road"] = 0.55, 	-- 45% friction reduction
}





-- ADVANCED SETTINGS, MODIFY ONLY IF YOU KNOW WHAT YOU ARE DOING!

-- terrain on which roads may not be placed
RWroadProhibitedTerrainList = {"RW_water-walkable", "RW_deepwater-walkable", "RW_water-green-walkable", "RW_deepwater-green-walkable"}

-- terrain tiles which are to be changed to walkable tiles (in order of priority)
RWbridgeTerrainConversionList = {
	{"grass", "grass"},
	{"deepwater", "RW_deepwater-walkable"},
	{"water", "RW_water-walkable"},
	{"deepwater-green", "RW_deepwater-green-walkable"},
	{"water-green", "RW_water-green-walkable"}
}

-- terrain tiles around placed bridges which are manipulated to prevent bugs (in order of priority)
RWbridgeTerrainSafetyList = { "water", "water-green", "deepwater", "deepwater-green"}

RWblockerDestroyDelay = 40 -- destroy placement-blocker objects after they are older than this many ticks
RWblockerDestroyFrequency = 30 -- only check placement-blocker objects to destroy this often

RWcarSpeedModifiersFrequency = 25 -- how often to check the surface a car is on and its type of fuel

RWtransitionQueueFrequency = 5 -- how often to add tile transitions (can't be done all at once due to lag)

-- Roadworks tile placing definitions. Visualisation below:
--
-- 9 8 7
-- 6 5 4
-- 3 2 1

RW_TILE_TOP = 8
RW_TILE_BOTTOM = 2
RW_TILE_LEFT = 6
RW_TILE_RIGHT = 4

RW_TILE_TOPLEFT = 9
RW_TILE_TOPRIGHT = 7
RW_TILE_BOTTOMLEFT = 3
RW_TILE_BOTTOMRIGHT = 1

RW_TILE_CENTER = 5

-- index of edges

RW_TOP_EDGE = 1
RW_BOTTOM_EDGE = 2
RW_LEFT_EDGE = 3
RW_RIGHT_EDGE = 4

RW_BOTTOM_RIGHT_EDGE = 5
RW_BOTTOM_LEFT_EDGE = 6
RW_TOP_RIGHT_EDGE = 7
RW_TOP_LEFT_EDGE = 8

RW_BOTTOM_RIGHT_INNER_EDGE = 9
RW_BOTTOM_LEFT_INNER_EDGE = 10
RW_TOP_RIGHT_INNER_EDGE = 11
RW_TOP_LEFT_INNER_EDGE = 12