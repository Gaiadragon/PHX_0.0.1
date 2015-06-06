require "defines"
require "script.helpFunctions"

local RWblockerDeleteList = {}
local RWtransitionQueue = {}

function RWtryPlaceSurface(argumentEntity, player)
	-- make sure the game doesn't crash if another mod deletes the entity before us
	if not argumentEntity.valid then
		return
	end
	
	local kind = argumentEntity.name
	
	for k, v in pairs(RWsurfaceList) do
		if v == kind then
			local surfacePosition = argumentEntity.position
			
			-- destroy the placeholder entity
			argumentEntity.destroy()
			
			local placed = RWplaceTileSquare(surfacePosition, kind, player)
			-- create a blocker entity to prevent placing the road every single tick
			local blocker = game.createentity
			{
				name = "RW_road-blocker",
				position = surfacePosition,
				force = game.forces.neutral
			}	
			table.insert(RWblockerDeleteList, {entity = blocker, tick = game.tick})
			
			if placed then
				RWclearDoodads(surfacePosition, 0.9)
			end
			
			break
		end
	end
end

function RWplaceTileSquare(position, surfaceType, player)

	local result = false

	local posX = position.x
	local posY = position.y
	
	local suitableTiles = {}
	
	local itemsConsumption = RWcanPlaceTiles(position, 1, surfaceType, suitableTiles) - 1
	
	if (player) then
		if game.players[player].getitemcount(surfaceType) < itemsConsumption then
			game.players[player].print("You need at least " .. itemsConsumption + 1 .. " items of this kind to place the surface here")
			RWcursorstackInsert(surfaceType, 1, player)
			return
		end
	end
	
	if #suitableTiles > 0 then
		-- place the tiles first
		for k, v in pairs(suitableTiles) do
			game.createentity
			{
				name = surfaceType .. "-center",
				position = suitableTiles[k],
				force = game.forces.neutral
			}
		end
		
		-- then handle the tile transitions
		for k, v in pairs(suitableTiles) do
			RWhandleTileTransitions(suitableTiles[k], surfaceType)
			--RWcreateTileTransition(suitableTiles[k], surfaceType)
		end
		
		result = true
	end
	
	if (player) then
		RWcursorstackInsert(surfaceType, -itemsConsumption, player)
	end
	
	return result
end

function RWcanPlaceTiles(position, radius, surfaceType, tileTablePointer)

	local posX = position.x
	local posY = position.y
	
	local itemsConsumption = 0
	
	for tX = 0, radius, 1 do
		for tY = 0, radius, 1 do
			local tfX = posX - tX
			local tfY = posY - tY
		
			local tile = game.gettile(tfX, tfY)
			
			if not (tile.collideswith("water-tile")) then
				local allowed = true
				
				local tileName = tile.name
				
				for k, v in pairs(RWroadProhibitedTerrainList) do
					if v == tileName then
						allowed = false
						break
					end
				end
				
				local existingTiles = game.findentitiesfiltered{area = {{tfX, tfY}, {tfX + 1, tfY + 1}}, type="simple-entity"}
				
				local breakLoop = false
				
				for k, v in pairs(existingTiles) do
					-- we have to check if it is valid in case it's been deleted already
					if v.valid then
						if v.name == (surfaceType .. "-center") then
							allowed = false
							break
						end
					
						for k2, v2 in pairs(RWsurfaceList) do
							if v.valid then
								if v.name == (v2 .. "-center") then
									v.destroy()
								end
							end
						end
					end
				end
				
				if allowed then
					tileTablePointer[#tileTablePointer + 1] = {x = tfX, y = tfY}
					itemsConsumption = itemsConsumption + 1
				end
			end
		end
	end
	
	return itemsConsumption
end

function RWhandleTileTransitions(position, surfaceType)

	-- destroy any preexisting edges where we are placing our tiles
	local possibleEdges = game.findentitiesfiltered{area = {{position.x, position.y}, {position.x + 1, position.y + 1}}, type="simple-entity"}
				
	for k,v in pairs(possibleEdges) do
		for k2,v2 in pairs(RWsurfaceList) do
			if v.valid then
				local nameBase = string.sub(v.name, 1, string.len(v2))
			
				if (nameBase == v2) and ((nameBase .. "-center") ~= v.name) then
					v.destroy()
				end
			end
		end
	end

	for tX = -1, 1, 1 do
		for tY = -1, 1, 1 do
			if not (tX == 0 and tY == 0) then
				local tilePosition = {x = position.x + tX, y = position.y + tY}
			
				-- create new tile edges around our new tiles
				--RWcreateTileTransition(tilePosition, surfaceType)
				--RWcreateTileTransition(tilePosition)
				
				--RWtransitionQueue[#RWtransitionQueue+1] = {tilePosition, surfaceType}
				RWtransitionQueue[#RWtransitionQueue+1] = tilePosition
			end
		end
	end
end

function RWtransitionQueueTick()
	if game.tick % RWtransitionQueueFrequency == 0 then
	
		local queueLength = #RWtransitionQueue
	
		--game.player.print(queueLength)
	
		if queueLength > 0 then
			RWcreateTileTransition(RWtransitionQueue[queueLength])
			
			RWtransitionQueue[queueLength] = nil
		end
	end
end

--[[function RWcreateTileTransition(checkPosition, surfaceType)

	local entities = game.findentitiesfiltered{area = {{checkPosition.x - 1, checkPosition.y - 1}, {checkPosition.x + 2, checkPosition.y + 2}}, type="simple-entity"}
	
	local tileCenterList = {} --- store tile centre positions
	local tileEdgesList = {} --- store tile edge entities
	
	-- at first, find all tile centres and edges around
	for k,v in pairs(entities) do
		-- first we need to check if the entity is still valid
		if v.valid then
			if v.name == surfaceType .. "-center" then
				tileCenterList[#tileCenterList+1] = v.position -- we don't want to delete the entity later, so we just need to store a position
			else
				-- check any nearby tile edges
				if (((v.position.x - 0.5) == checkPosition.x) and ((v.position.y - 0.5) == checkPosition.y)) then
					if not (string.match(v.name, "-center")) then
						local nameBase = string.sub(v.name, 1, string.len(surfaceType))
				
						-- if this is an edge belonging to the surface type we are placing, we might want to keep it
						if (nameBase == surfaceType) then
							tileEdgesList[#tileEdgesList+1] = v
						
						-- all other edges get deleted
						else 
							for k2,v2 in pairs(RWsurfaceList) do	
								if not (surfaceType == v2) then
									local base = string.sub(v.name, 1, string.len(v2))
									
									if (base == v2) then
										--otherEdgesList[#otherEdgesList+1] = v
										tileEdgesList[#tileEdgesList+1] = v
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	local tilePositionList = {}
	
	for k,v in pairs(tileCenterList) do
		local tilePosition = {v.x - checkPosition.x + 0.5, v.y - checkPosition.y + 0.5}
		local tileIndex = (tilePosition[2] * 3) + tilePosition[1] + 1
		
		tilePositionList[tileIndex] = true
	end
	
	local existingEdgesList = {}
	local otherEdgesList = {} --- store tile edge entities of other surface types
	
	-- and finally, look at which tile edges are already in place and adjust our index table appropriately
	for k,v in pairs(tileEdgesList) do
		local nameBase = surfaceType
		
		for k2,v2 in pairs(RWsurfaceList) do	
			if not (surfaceType == v2) then
				local base = string.sub(v.name, 1, string.len(v2))
				
				if (base == v2) then
					nameBase = v2
					break
				end
			end
		end
		
		local edgeIndex
		
		if (v.name == nameBase .. "-bottom-side") then
			edgeIndex = RW_BOTTOM_EDGE
		elseif (v.name == nameBase .. "-top-side") then
			edgeIndex = RW_TOP_EDGE
		elseif (v.name == nameBase .. "-left-side") then
			edgeIndex = RW_LEFT_EDGE
		elseif (v.name == nameBase .. "-right-side") then
			edgeIndex = RW_RIGHT_EDGE
		end
		
		if (v.name == nameBase .. "-bottom-right-corner") then
			edgeIndex = RW_BOTTOM_RIGHT_EDGE
		elseif (v.name == nameBase .. "-bottom-left-corner") then
			edgeIndex = RW_BOTTOM_LEFT_EDGE
		elseif (v.name == nameBase .. "-top-right-corner") then
			edgeIndex = RW_TOP_RIGHT_EDGE
		elseif (v.name == nameBase .. "-top-left-corner") then
			edgeIndex = RW_TOP_LEFT_EDGE
		end
		
		if (v.name == nameBase .. "-bottom-right-inner-corner") then
			edgeIndex = RW_BOTTOM_RIGHT_INNER_EDGE
		elseif (v.name == nameBase .. "-bottom-left-inner-corner") then
			edgeIndex = RW_BOTTOM_LEFT_INNER_EDGE
		elseif (v.name == nameBase .. "-top-right-inner-corner") then
			edgeIndex = RW_TOP_RIGHT_INNER_EDGE
		elseif (v.name == nameBase .. "-top-left-inner-corner") then
			edgeIndex = RW_TOP_LEFT_INNER_EDGE
		end
		
		if (edgeIndex) then
			if (nameBase == surfaceType) then
				if not existingEdgesList[edgeIndex] then
					existingEdgesList[edgeIndex] = v
				else
					v.destroy() -- destroy all duplicate edges
				end
			else
				game.player.print("Placing " .. v.name .. " at index " .. edgeIndex)
				otherEdgesList[edgeIndex] = v
			end
		else
			game.player.print("Missing edgeIndex in " .. v.name)
		end
		tileEdgesList[k] = nil
	end

	-- Possible centre tile positions... yeah, this is the 'handy table' I described above. Yeah, I know, quiet you >:/
	-- (this 'handy table' is not actually needed anymore, but I don't have the heart to delete it..)
	--
	-- 9 8 7
	-- 6 5 4
	-- 3 2 1
	--
	-- Rules:
	-- if 8 exists, place straight bottom edge
	-- if 6 exists, place straight right edge
	-- if 4	exists, place straight left edge
	-- if 2 exists, place straight top edge
	----
	-- if 6 and 8 exist, place bottom right inner corner
	-- if 4 and 8 exist, place bottom left inner corner
	-- if 6 and 2 exist, place top right inner corner
	-- if 4 and 2 exist, place top left inner corner
	----
	-- if 9 exists and 6+8 don't exist, place bottom right outer corner
	-- if 7 exists and 4+8 don't exist, place bottom left outer corner
	-- if 3 exists and 6+2 don't exist, place top right outer corner
	-- if 1 exists and 4+2 don't exist, place top left outer corner
	--
	-- 5 is the position where edges are placed and thus blocks them
	
	local placementCondition
	
	if (not tilePositionList[RW_TILE_CENTER]) then
		-- place straight edges
		if tilePositionList[RW_TILE_BOTTOM] and (not existingEdgesList[RW_BOTTOM_EDGE]) then
			game.createentity {	name = surfaceType .. "-bottom-side", position = checkPosition, force = game.forces.neutral }
			if (otherEdgesList[RW_BOTTOM_EDGE]) then otherEdgesList[RW_BOTTOM_EDGE].destroy() end
		elseif (not tilePositionList[RW_TILE_BOTTOM]) and existingEdgesList[RW_BOTTOM_EDGE] then
			existingEdgesList[RW_BOTTOM_EDGE].destroy()
		end
		
		if tilePositionList[RW_TILE_RIGHT] and (not existingEdgesList[RW_RIGHT_EDGE]) then	
			game.createentity {	name = surfaceType .. "-right-side", position = checkPosition, force = game.forces.neutral }
			if (otherEdgesList[RW_RIGHT_EDGE]) then otherEdgesList[RW_RIGHT_EDGE].destroy() end
		elseif (not tilePositionList[RW_TILE_RIGHT]) and existingEdgesList[RW_RIGHT_EDGE] then
			existingEdgesList[RW_RIGHT_EDGE].destroy()
		end
		
		if tilePositionList[RW_TILE_LEFT] and (not existingEdgesList[RW_LEFT_EDGE]) then	
			game.createentity {	name = surfaceType .. "-left-side", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_LEFT_EDGE]) then otherEdgesList[RW_LEFT_EDGE].destroy() end
		elseif (not tilePositionList[RW_TILE_LEFT]) and existingEdgesList[RW_LEFT_EDGE] then
			existingEdgesList[RW_LEFT_EDGE].destroy()
		end
		
		if tilePositionList[RW_TILE_TOP] and (not existingEdgesList[RW_TOP_EDGE]) then	
			game.createentity {	name = surfaceType .. "-top-side", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_TOP_EDGE]) then otherEdgesList[RW_TOP_EDGE].destroy() end
		elseif (not tilePositionList[RW_TILE_TOP]) and existingEdgesList[RW_TOP_EDGE] then
			existingEdgesList[RW_TOP_EDGE].destroy()
		end
		
		-- place outer corners
		placementCondition = tilePositionList[RW_TILE_TOPLEFT] and (not tilePositionList[RW_TILE_TOP]) and (not tilePositionList[RW_TILE_LEFT])
		
		if placementCondition and (not existingEdgesList[RW_TOP_LEFT_EDGE])then	
			game.createentity {	name = surfaceType .. "-top-left-corner", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_TOP_LEFT_EDGE]) then otherEdgesList[RW_TOP_LEFT_EDGE].destroy() end
		elseif (not placementCondition) and existingEdgesList[RW_TOP_LEFT_EDGE] then
			existingEdgesList[RW_TOP_LEFT_EDGE].destroy()
		end
		
		placementCondition = tilePositionList[RW_TILE_TOPRIGHT] and (not tilePositionList[RW_TILE_TOP]) and (not tilePositionList[RW_TILE_RIGHT])
		
		if placementCondition and (not existingEdgesList[RW_TOP_RIGHT_EDGE])then	
			game.createentity {	name = surfaceType .. "-top-right-corner", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_TOP_RIGHT_EDGE]) then otherEdgesList[RW_TOP_RIGHT_EDGE].destroy() end
		elseif (not placementCondition) and existingEdgesList[RW_TOP_RIGHT_EDGE] then
			existingEdgesList[RW_TOP_RIGHT_EDGE].destroy()
		end
		
		placementCondition = tilePositionList[RW_TILE_BOTTOMLEFT] and (not tilePositionList[RW_TILE_BOTTOM]) and (not tilePositionList[RW_TILE_LEFT])
		
		if placementCondition and (not existingEdgesList[RW_BOTTOM_LEFT_EDGE])then	
			game.createentity {	name = surfaceType .. "-bottom-left-corner", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_BOTTOM_LEFT_EDGE]) then otherEdgesList[RW_BOTTOM_LEFT_EDGE].destroy() end
		elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_LEFT_EDGE] then
			existingEdgesList[RW_BOTTOM_LEFT_EDGE].destroy()
		end
		
		placementCondition = tilePositionList[RW_TILE_BOTTOMRIGHT] and (not tilePositionList[RW_TILE_BOTTOM]) and (not tilePositionList[RW_TILE_RIGHT])
		
		if placementCondition and (not existingEdgesList[RW_BOTTOM_RIGHT_EDGE])then	
			game.createentity {	name = surfaceType .. "-bottom-right-corner", position = checkPosition, force = game.forces.neutral }	
			if (otherEdgesList[RW_BOTTOM_RIGHT_EDGE]) then otherEdgesList[RW_BOTTOM_RIGHT_EDGE].destroy() end
		elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_RIGHT_EDGE] then
			existingEdgesList[RW_BOTTOM_RIGHT_EDGE].destroy()
		end
		
		-- place inner corners, if they exist
		if game.entityprototypes[surfaceType .. "-bottom-left-inner-corner"] then
			placementCondition = tilePositionList[RW_TILE_BOTTOM] and tilePositionList[RW_TILE_LEFT]
			
			if placementCondition and (not existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE])then	
				game.createentity {	name = surfaceType .. "-bottom-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				if (otherEdgesList[RW_BOTTOM_LEFT_INNER_EDGE]) then otherEdgesList[RW_BOTTOM_LEFT_INNER_EDGE].destroy() end
			elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE] then
				existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[RW_TILE_BOTTOM] and tilePositionList[RW_TILE_RIGHT]
			
			if placementCondition and (not existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE])then	
				game.createentity {	name = surfaceType .. "-bottom-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				if (otherEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE]) then otherEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE].destroy() end
			elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE] then
				existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[RW_TILE_TOP] and tilePositionList[RW_TILE_LEFT]
			
			if placementCondition and (not existingEdgesList[RW_TOP_LEFT_INNER_EDGE])then	
				game.createentity {	name = surfaceType .. "-top-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				if (otherEdgesList[RW_TOP_LEFT_INNER_EDGE]) then otherEdgesList[RW_TOP_LEFT_INNER_EDGE].destroy() end
			elseif (not placementCondition) and existingEdgesList[RW_TOP_LEFT_INNER_EDGE] then
				existingEdgesList[RW_TOP_LEFT_INNER_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[RW_TILE_TOP] and tilePositionList[RW_TILE_RIGHT]
			
			if placementCondition and (not existingEdgesList[RW_TOP_RIGHT_INNER_EDGE])then	
				game.createentity {	name = surfaceType .. "-top-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				if (otherEdgesList[RW_TOP_RIGHT_INNER_EDGE]) then otherEdgesList[RW_TOP_RIGHT_INNER_EDGE].destroy() end
			elseif (not placementCondition) and existingEdgesList[RW_TOP_RIGHT_INNER_EDGE] then
				existingEdgesList[RW_TOP_RIGHT_INNER_EDGE].destroy()
			end
		end
	else
		-- delete possible remaining edges of other surface types
		for k,v in pairs(otherEdgesList) do
			v.destroy()
		end
	end
end ]]

-- V2
function RWcreateTileTransition(checkPosition)

	-- priority #1: Increase performance
	-- this should be done by using only a single pairs(surfaceList) loop
	
	local entities = game.findentitiesfiltered{area = {{checkPosition.x - 1, checkPosition.y - 1}, {checkPosition.x + 2, checkPosition.y + 2}}, type="simple-entity"}
	
	local tileCenterList = {} --- store tile centre positions
	local tileEdgesList = {} --- store tile edge entities
	
	local surfaceList = RWsurfaceList
	
	local foundSurfaceList = {}
	
	-- at first, find all tile centres and edges around
	for k,v in pairs(entities) do
		-- first we need to check if the entity is still valid
		if v.valid then
			local entityName = v.name
			
			for k2,v2 in pairs(surfaceList) do
			
				if (not foundSurfaceList[v2]) then
					foundSurfaceList[k2] = v2
				end
			
				if entityName == v2 .. "-center" then
					tileCenterList[#tileCenterList+1] = {v.position, k2} -- store position and priority of the tile
					break
				else
					-- only look at edges at our own position
					if (((v.position.x - 0.5) == checkPosition.x) and ((v.position.y - 0.5) == checkPosition.y)) then
						local nameBase = string.sub(entityName, 1, string.len(v2))
						
						if (nameBase == v2) then
							tileEdgesList[#tileEdgesList+1] = {v, k2} -- store the edge entity and its priority
						end
					end
				end
			end
		end
	end
	
	local tilePositionList = {}
	
	for k,v in pairs(surfaceList) do	
		tilePositionList[k] = {}
	end
	
	for k,v in pairs(tileCenterList) do
		local pos = v[1]
	
		local tilePosition = {pos.x - checkPosition.x + 0.5, pos.y - checkPosition.y + 0.5}
		local tileIndex = (tilePosition[2] * 3) + tilePosition[1] + 1
		
		if not tilePositionList[v[2]] then
			tilePositionList[v[2]] = {}
		end
		
		if (tileIndex == RW_TILE_CENTER) then
			return -- abort abort abort
		end
		
		tilePositionList[v[2]][tileIndex] = true

	end
	
	local existingEdgesList = {}
	
	for k,v in pairs(surfaceList) do	
		existingEdgesList[k] = {}
	end
	
	-- and finally, look at which tile edges are already in place and adjust our index table appropriately
	for k,v in pairs(tileEdgesList) do
		local edge = v[1]
		
		local edgeName = edge.name
		
		local nameBase
		local nameIndex
		
		for k2,v2 in pairs(foundSurfaceList) do	
			local base = string.sub(edgeName, 1, string.len(v2))
				
			if (base == v2) then
				nameBase = v2
				nameIndex = k2
				break
			end
		end
		
		if not nameBase then
			--game.player.print("Missing nameBase for " .. edgeName)
			break
		end
		
		local edgeIndex
		
		if (edgeName == nameBase .. "-bottom-side") then
			edgeIndex = RW_BOTTOM_EDGE
		elseif (edgeName == nameBase .. "-top-side") then
			edgeIndex = RW_TOP_EDGE
		elseif (edgeName == nameBase .. "-left-side") then
			edgeIndex = RW_LEFT_EDGE
		elseif (edgeName == nameBase .. "-right-side") then
			edgeIndex = RW_RIGHT_EDGE
		end
		
		if (edgeName == nameBase .. "-bottom-right-corner") then
			edgeIndex = RW_BOTTOM_RIGHT_EDGE
		elseif (edgeName == nameBase .. "-bottom-left-corner") then
			edgeIndex = RW_BOTTOM_LEFT_EDGE
		elseif (edgeName == nameBase .. "-top-right-corner") then
			edgeIndex = RW_TOP_RIGHT_EDGE
		elseif (edgeName == nameBase .. "-top-left-corner") then
			edgeIndex = RW_TOP_LEFT_EDGE
		end
		
		if (edgeName == nameBase .. "-bottom-right-inner-corner") then
			edgeIndex = RW_BOTTOM_RIGHT_INNER_EDGE
		elseif (edgeName == nameBase .. "-bottom-left-inner-corner") then
			edgeIndex = RW_BOTTOM_LEFT_INNER_EDGE
		elseif (edgeName == nameBase .. "-top-right-inner-corner") then
			edgeIndex = RW_TOP_RIGHT_INNER_EDGE
		elseif (edgeName == nameBase .. "-top-left-inner-corner") then
			edgeIndex = RW_TOP_LEFT_INNER_EDGE
		end
		
		if not edgeIndex then
			--game.player.print("Missing edgeIndex for " .. edgeName)
			break
		end
		
		if not existingEdgesList[nameIndex] then
			existingEdgesList[nameIndex] = {}
		end
		
		if not existingEdgesList[nameIndex][edgeIndex] then
			existingEdgesList[nameIndex][edgeIndex] = edge
		else
			edge.destroy() -- destroy all duplicate edges
		end
			
		tileEdgesList[k] = nil
	end

	-- Possible centre tile positions... yeah, this is the 'handy table' I described above. Yeah, I know, quiet you >:/
	-- (this 'handy table' is not actually needed anymore, but I don't have the heart to delete it..)
	--
	-- 9 8 7
	-- 6 5 4
	-- 3 2 1
	--
	-- Rules:
	-- if 8 exists, place straight bottom edge
	-- if 6 exists, place straight right edge
	-- if 4	exists, place straight left edge
	-- if 2 exists, place straight top edge
	----
	-- if 6 and 8 exist, place bottom right inner corner
	-- if 4 and 8 exist, place bottom left inner corner
	-- if 6 and 2 exist, place top right inner corner
	-- if 4 and 2 exist, place top left inner corner
	----
	-- if 9 exists and 6+8 don't exist, place bottom right outer corner
	-- if 7 exists and 4+8 don't exist, place bottom left outer corner
	-- if 3 exists and 6+2 don't exist, place top right outer corner
	-- if 1 exists and 4+2 don't exist, place top left outer corner
	--
	-- 5 is the position where edges are placed and thus blocks them
	
	for k2,v2 in pairs(foundSurfaceList) do
		if (not tilePositionList[k2][RW_TILE_CENTER]) then
			-- place straight edges
			if tilePositionList[k2][RW_TILE_BOTTOM] and (not existingEdgesList[k2][RW_BOTTOM_EDGE]) then
				game.createentity {	name = v2 .. "-bottom-side", position = checkPosition, force = game.forces.neutral }
			elseif (not tilePositionList[k2][RW_TILE_BOTTOM]) and existingEdgesList[k2][RW_BOTTOM_EDGE] then
				existingEdgesList[k2][RW_BOTTOM_EDGE].destroy()
			end
			
			if tilePositionList[k2][RW_TILE_RIGHT] and (not existingEdgesList[k2][RW_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-right-side", position = checkPosition, force = game.forces.neutral }
			elseif (not tilePositionList[k2][RW_TILE_RIGHT]) and existingEdgesList[k2][RW_RIGHT_EDGE] then
				existingEdgesList[k2][RW_RIGHT_EDGE].destroy()
			end
			
			if tilePositionList[k2][RW_TILE_LEFT] and (not existingEdgesList[k2][RW_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-left-side", position = checkPosition, force = game.forces.neutral }	
			elseif (not tilePositionList[k2][RW_TILE_LEFT]) and existingEdgesList[k2][RW_LEFT_EDGE] then
				existingEdgesList[k2][RW_LEFT_EDGE].destroy()
			end
			
			if tilePositionList[k2][RW_TILE_TOP] and (not existingEdgesList[k2][RW_TOP_EDGE]) then	
				game.createentity {	name = v2 .. "-top-side", position = checkPosition, force = game.forces.neutral }	
			elseif (not tilePositionList[k2][RW_TILE_TOP]) and existingEdgesList[k2][RW_TOP_EDGE] then
				existingEdgesList[k2][RW_TOP_EDGE].destroy()
			end
			
			-- place outer corners
			local placementCondition
			
			placementCondition = tilePositionList[k2][RW_TILE_TOPLEFT] and (not tilePositionList[k2][RW_TILE_TOP]) and (not tilePositionList[k2][RW_TILE_LEFT])
			
			if placementCondition and (not existingEdgesList[k2][RW_TOP_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-top-left-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[k2][RW_TOP_LEFT_EDGE] then
				existingEdgesList[k2][RW_TOP_LEFT_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[k2][RW_TILE_TOPRIGHT] and (not tilePositionList[k2][RW_TILE_TOP]) and (not tilePositionList[k2][RW_TILE_RIGHT])
			
			if placementCondition and (not existingEdgesList[k2][RW_TOP_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-top-right-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[k2][RW_TOP_RIGHT_EDGE] then
				existingEdgesList[k2][RW_TOP_RIGHT_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[k2][RW_TILE_BOTTOMLEFT] and (not tilePositionList[k2][RW_TILE_BOTTOM]) and (not tilePositionList[k2][RW_TILE_LEFT])
			
			if placementCondition and (not existingEdgesList[k2][RW_BOTTOM_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-bottom-left-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[k2][RW_BOTTOM_LEFT_EDGE] then
				existingEdgesList[k2][RW_BOTTOM_LEFT_EDGE].destroy()
			end
			
			placementCondition = tilePositionList[k2][RW_TILE_BOTTOMRIGHT] and (not tilePositionList[k2][RW_TILE_BOTTOM]) and (not tilePositionList[k2][RW_TILE_RIGHT])
			
			if placementCondition and (not existingEdgesList[k2][RW_BOTTOM_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-bottom-right-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[k2][RW_BOTTOM_RIGHT_EDGE] then
				existingEdgesList[k2][RW_BOTTOM_RIGHT_EDGE].destroy()
			end
			
			-- place inner corners, if they exist
			if game.entityprototypes[v2 .. "-bottom-left-inner-corner"] then
				placementCondition = tilePositionList[k2][RW_TILE_BOTTOM] and tilePositionList[k2][RW_TILE_LEFT]
				
				if placementCondition and (not existingEdgesList[k2][RW_BOTTOM_LEFT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-bottom-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[k2][RW_BOTTOM_LEFT_INNER_EDGE] then
					existingEdgesList[k2][RW_BOTTOM_LEFT_INNER_EDGE].destroy()
				end
				
				placementCondition = tilePositionList[k2][RW_TILE_BOTTOM] and tilePositionList[k2][RW_TILE_RIGHT]
				
				if placementCondition and (not existingEdgesList[k2][RW_BOTTOM_RIGHT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-bottom-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[k2][RW_BOTTOM_RIGHT_INNER_EDGE] then
					existingEdgesList[k2][RW_BOTTOM_RIGHT_INNER_EDGE].destroy()
				end
				
				placementCondition = tilePositionList[k2][RW_TILE_TOP] and tilePositionList[k2][RW_TILE_LEFT]
				
				if placementCondition and (not existingEdgesList[k2][RW_TOP_LEFT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-top-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[k2][RW_TOP_LEFT_INNER_EDGE] then
					existingEdgesList[k2][RW_TOP_LEFT_INNER_EDGE].destroy()
				end
				
				placementCondition = tilePositionList[k2][RW_TILE_TOP] and tilePositionList[k2][RW_TILE_RIGHT]
				
				if placementCondition and (not existingEdgesList[k2][RW_TOP_RIGHT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-top-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[k2][RW_TOP_RIGHT_INNER_EDGE] then
					existingEdgesList[k2][RW_TOP_RIGHT_INNER_EDGE].destroy()
				end
			end
		end
	--else
		-- delete possible remaining edges of other surface types
	--	for k,v in pairs(otherEdgesList) do
	--		v.destroy()
	--	end
	end
end

--[[function RWcreateTileTransition(checkPosition)

	-- priority #1: Increase performance
	-- this should be done by using only a single pairs(surfaceList) loop

	local entities = game.findentitiesfiltered{area = {{checkPosition.x - 1, checkPosition.y - 1}, {checkPosition.x + 2, checkPosition.y + 2}}, type="simple-entity"}
	
	local tileCenterList = {} -- store tile centre positions
	local tileEdgesList = {} -- store tile edge entities
	
	local surfaceList = RWsurfaceList
	
	for k2,v2 in pairs(surfaceList) do
	
		tileCenterList = {}
		tileEdgesList = {}
	
		-- at first, find all tile centres and edges around
		for k,v in pairs(entities) do
			-- first we need to check if the entity is still valid
			if v.valid then
				local entityName = v.name
					
				if entityName == v2 .. "-center" then
					tileCenterList[#tileCenterList+1] = v.position -- store position and priority of the tile
					break
				else
					-- only look at edges at our own position
					if (((v.position.x - 0.5) == checkPosition.x) and ((v.position.y - 0.5) == checkPosition.y)) then
						local nameBase = string.sub(entityName, 1, string.len(v2))
						
						if (nameBase == v2) then
							tileEdgesList[#tileEdgesList+1] = v -- store the edge entity and its priority
						end
					end
				end
			end
		end
		
		local tilePositionList = {}
		
		for k,v in pairs(tileCenterList) do
			local pos = v
		
			local tilePosition = {pos.x - checkPosition.x + 0.5, pos.y - checkPosition.y + 0.5}
			local tileIndex = (tilePosition[2] * 3) + tilePosition[1] + 1
			
			tilePositionList[tileIndex] = true
		end
		
		local existingEdgesList = {}
		
		-- and finally, look at which tile edges are already in place and adjust our index table appropriately
		for k,v in pairs(tileEdgesList) do
			local edge = v
			
			local edgeName = edge.name
			
			local nameBase = v2
			local nameIndex = k2
			
			if not nameBase then
				game.player.print("Missing nameBase for " .. edgeName)
				break
			end
			
			local edgeIndex
			
			if (edgeName == nameBase .. "-bottom-side") then
				edgeIndex = RW_BOTTOM_EDGE
			elseif (edgeName == nameBase .. "-top-side") then
				edgeIndex = RW_TOP_EDGE
			elseif (edgeName == nameBase .. "-left-side") then
				edgeIndex = RW_LEFT_EDGE
			elseif (edgeName == nameBase .. "-right-side") then
				edgeIndex = RW_RIGHT_EDGE
			end
			
			if (edgeName == nameBase .. "-bottom-right-corner") then
				edgeIndex = RW_BOTTOM_RIGHT_EDGE
			elseif (edgeName == nameBase .. "-bottom-left-corner") then
				edgeIndex = RW_BOTTOM_LEFT_EDGE
			elseif (edgeName == nameBase .. "-top-right-corner") then
				edgeIndex = RW_TOP_RIGHT_EDGE
			elseif (edgeName == nameBase .. "-top-left-corner") then
				edgeIndex = RW_TOP_LEFT_EDGE
			end
			
			if (edgeName == nameBase .. "-bottom-right-inner-corner") then
				edgeIndex = RW_BOTTOM_RIGHT_INNER_EDGE
			elseif (edgeName == nameBase .. "-bottom-left-inner-corner") then
				edgeIndex = RW_BOTTOM_LEFT_INNER_EDGE
			elseif (edgeName == nameBase .. "-top-right-inner-corner") then
				edgeIndex = RW_TOP_RIGHT_INNER_EDGE
			elseif (edgeName == nameBase .. "-top-left-inner-corner") then
				edgeIndex = RW_TOP_LEFT_INNER_EDGE
			end
			
			if not edgeIndex then
				game.player.print("Missing edgeIndex for " .. edgeName)
				break
			end
			
			if not existingEdgesList[edgeIndex] then
				existingEdgesList[edgeIndex] = edge
			else
				edge.destroy() -- destroy all duplicate edges
			end
				
			tileEdgesList[k] = nil
		end

		-- Possible centre tile positions... yeah, this is the 'handy table' I described above. Yeah, I know, quiet you >:/
		-- (this 'handy table' is not actually needed anymore, but I don't have the heart to delete it..)
		--
		-- 9 8 7
		-- 6 5 4
		-- 3 2 1
		--
		-- Rules:
		-- if 8 exists, place straight bottom edge
		-- if 6 exists, place straight right edge
		-- if 4	exists, place straight left edge
		-- if 2 exists, place straight top edge
		----
		-- if 6 and 8 exist, place bottom right inner corner
		-- if 4 and 8 exist, place bottom left inner corner
		-- if 6 and 2 exist, place top right inner corner
		-- if 4 and 2 exist, place top left inner corner
		----
		-- if 9 exists and 6+8 don't exist, place bottom right outer corner
		-- if 7 exists and 4+8 don't exist, place bottom left outer corner
		-- if 3 exists and 6+2 don't exist, place top right outer corner
		-- if 1 exists and 4+2 don't exist, place top left outer corner
		--
		-- 5 is the position where edges are placed and thus blocks them
		
		if (not tilePositionList[RW_TILE_CENTER]) then
			-- place straight edges
			if tilePositionList[RW_TILE_BOTTOM] and (not existingEdgesList[RW_BOTTOM_EDGE]) then
				game.createentity {	name = v2 .. "-bottom-side", position = checkPosition, force = game.forces.neutral }
			elseif (not tilePositionList[RW_TILE_BOTTOM]) and existingEdgesList[RW_BOTTOM_EDGE] then
				existingEdgesList[RW_BOTTOM_EDGE].destroy()
			end
				
			if tilePositionList[RW_TILE_RIGHT] and (not existingEdgesList[RW_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-right-side", position = checkPosition, force = game.forces.neutral }
			elseif (not tilePositionList[RW_TILE_RIGHT]) and existingEdgesList[RW_RIGHT_EDGE] then
				existingEdgesList[RW_RIGHT_EDGE].destroy()
			end
				
			if tilePositionList[RW_TILE_LEFT] and (not existingEdgesList[RW_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-left-side", position = checkPosition, force = game.forces.neutral }	
			elseif (not tilePositionList[RW_TILE_LEFT]) and existingEdgesList[RW_LEFT_EDGE] then
				existingEdgesList[RW_LEFT_EDGE].destroy()
			end
				
			if tilePositionList[RW_TILE_TOP] and (not existingEdgesList[RW_TOP_EDGE]) then	
				game.createentity {	name = v2 .. "-top-side", position = checkPosition, force = game.forces.neutral }	
			elseif (not tilePositionList[RW_TILE_TOP]) and existingEdgesList[RW_TOP_EDGE] then
				existingEdgesList[RW_TOP_EDGE].destroy()
			end
				
			-- place outer corners
			local placementCondition
				
			placementCondition = tilePositionList[RW_TILE_TOPLEFT] and (not tilePositionList[RW_TILE_TOP]) and (not tilePositionList[RW_TILE_LEFT])
				
			if placementCondition and (not existingEdgesList[RW_TOP_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-top-left-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[RW_TOP_LEFT_EDGE] then
				existingEdgesList[RW_TOP_LEFT_EDGE].destroy()
			end
				
			placementCondition = tilePositionList[RW_TILE_TOPRIGHT] and (not tilePositionList[RW_TILE_TOP]) and (not tilePositionList[RW_TILE_RIGHT])
				
			if placementCondition and (not existingEdgesList[RW_TOP_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-top-right-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[RW_TOP_RIGHT_EDGE] then
				existingEdgesList[RW_TOP_RIGHT_EDGE].destroy()
			end
				
			placementCondition = tilePositionList[RW_TILE_BOTTOMLEFT] and (not tilePositionList[RW_TILE_BOTTOM]) and (not tilePositionList[RW_TILE_LEFT])
				
			if placementCondition and (not existingEdgesList[RW_BOTTOM_LEFT_EDGE]) then	
				game.createentity {	name = v2 .. "-bottom-left-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_LEFT_EDGE] then
				existingEdgesList[RW_BOTTOM_LEFT_EDGE].destroy()
			end
				
			placementCondition = tilePositionList[RW_TILE_BOTTOMRIGHT] and (not tilePositionList[RW_TILE_BOTTOM]) and (not tilePositionList[RW_TILE_RIGHT])
				
			if placementCondition and (not existingEdgesList[RW_BOTTOM_RIGHT_EDGE]) then	
				game.createentity {	name = v2 .. "-bottom-right-corner", position = checkPosition, force = game.forces.neutral }	
			elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_RIGHT_EDGE] then
				existingEdgesList[RW_BOTTOM_RIGHT_EDGE].destroy()
			end
				
			-- place inner corners, if they exist
			if game.entityprototypes[v2 .. "-bottom-left-inner-corner"] then
				placementCondition = tilePositionList[RW_TILE_BOTTOM] and tilePositionList[RW_TILE_LEFT]
					
				if placementCondition and (not existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-bottom-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE] then
					existingEdgesList[RW_BOTTOM_LEFT_INNER_EDGE].destroy()
				end
					
				placementCondition = tilePositionList[RW_TILE_BOTTOM] and tilePositionList[RW_TILE_RIGHT]
					
				if placementCondition and (not existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-bottom-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE] then
					existingEdgesList[RW_BOTTOM_RIGHT_INNER_EDGE].destroy()
				end
					
				placementCondition = tilePositionList[RW_TILE_TOP] and tilePositionList[RW_TILE_LEFT]
					
				if placementCondition and (not existingEdgesList[RW_TOP_LEFT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-top-left-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[RW_TOP_LEFT_INNER_EDGE] then
					existingEdgesList[RW_TOP_LEFT_INNER_EDGE].destroy()
				end
					
				placementCondition = tilePositionList[RW_TILE_TOP] and tilePositionList[RW_TILE_RIGHT]
				
				if placementCondition and (not existingEdgesList[RW_TOP_RIGHT_INNER_EDGE]) then	
					game.createentity {	name = v2 .. "-top-right-inner-corner", position = checkPosition, force = game.forces.neutral }	
				elseif (not placementCondition) and existingEdgesList[RW_TOP_RIGHT_INNER_EDGE] then
					existingEdgesList[RW_TOP_RIGHT_INNER_EDGE].destroy()
				end
			end
		--else
			-- delete possible remaining edges of other surface types
		--	for k,v in pairs(otherEdgesList) do
		--		v.destroy()
		--	end
		end
	end
end]]

function RWclearDoodads(position, radius)

	local doodads = game.findentitiesfiltered{area = {{position.x - radius, position.y - radius}, {position.x + radius, position.y + radius}}, type="decorative"}
	
	for k,v in pairs(doodads) do
		v.destroy()
	end
end

function RWsurfacePlaceTick()

	if game.tick % RWblockerDestroyFrequency == 0 then
		for k, v in pairs(RWblockerDeleteList) do
			if game.tick > v.tick + RWblockerDestroyDelay then
				v.entity.destroy()
				RWblockerDeleteList[k] = nil
			end
		end
	end
end