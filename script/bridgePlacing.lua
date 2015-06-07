-- fonctionne 07 juin 2015

require "defines"
require "script.helpFunctions"

function RWtryPlaceBridge(argumentEntity, playerIndex)

	-- make sure the game doesn't crash when the entity placed is already deleted (ie when placing pavement)
	if not argumentEntity.valid then
		return
	end

	local kind = argumentEntity.name
	
	for k,v in pairs(RWwalkableBridgeList) do
		local desiredName = v .. "-placeable"
		
		if kind == desiredName then
			local position = argumentEntity.position
		
			game.createentity
			{
				name = v,
				position = position,
				force = game.forces.player
			}
		
			argumentEntity.destroy()
			
			RWplaceBridgeWalkabilityTiles(position)
		end
	end
end

function RWplaceBridgeWalkabilityTiles(position)

	local posX = position.x
	local posY = position.y
	
	local tilesToPlace = {}
	local centreTilesToPlace = {}
	
	-- For a 3x3 grid of 2x2 tile squares
	for sX = -1, 1, 1 do
		for sY = -1, 1, 1 do
			local tileReplacement = nil
			local tileReplacementPriority = 9999
			
			--local tilesFound = {}
			
			-- For each tile in a 2x2 square
			for tX = 0, -1, -1 do
				for tY = 0, -1, -1 do
				
					local posTX = (posX + tX) + (sX * 2)
					local posTY = (posY + tY) + (sY * 2)
					
					local tileName = game.gettile(posTX, posTY).name
					
					--tilesFound[#tilesFound + 1] = tileName
					
					-- the centre 2x2 square must be made walkable
					if (sX == 0) and (sY == 0) then
						for k,v in pairs(RWbridgeTerrainConversionList) do
							if (tileName == v[1]) and (k < tileReplacementPriority) then
								tileReplacement = v[2]
								tileReplacementPriority = k
								break
							end
						end
					-- all other squares will merely get checked and possibly changed
					else
						for k,v in pairs(RWbridgeTerrainSafetyList) do
							if (tileName == v) and (k < tileReplacementPriority) then
								tileReplacement = v
								tileReplacementPriority = k
								break
							end
						end
					end
				end
			end
			
			if (tileReplacement) then
				--local index = 1
			
				for tX = 0, -1, -1 do
					for tY = 0, -1, -1 do
						local posTX = (posX + tX) + (sX * 2)
						local posTY = (posY + tY) + (sY * 2)
						
						--tilesToPlace[#tilesToPlace+1] = {name=tileReplacement, position={x = posTX, y = posTY}}
						
						--[[if (tilesFound[index] ~= tileReplacement) then
							
							if not (glob.RWbridgeTileRestoreList[posTX]) then
								glob.RWbridgeTileRestoreList[posTX] = {}
							end
								
							glob.RWbridgeTileRestoreList[posTX][posTY] = tilesFound[index]
						end]]
						
						--index = index + 1
						
						if (sX == 0) and (sY == 0) then
							centreTilesToPlace[#centreTilesToPlace+1] = {name=tileReplacement, position={x = posTX, y = posTY}}
						else
							tilesToPlace[#tilesToPlace+1] = {name=tileReplacement, position={x = posTX, y = posTY}}
						end
					end
				end
			end
		end
	end
	
	local tilesTemp = {}
	
	for k, v in pairs(centreTilesToPlace) do
		tilesTemp[#tilesTemp + 1] = v
	end
	
	for k, v in pairs(tilesToPlace) do
		tilesTemp[#tilesTemp + 1] = v
	end
	
	if next(tilesTemp) ~= nil then
		game.settiles(tilesTemp)
	end
	
	-- if there are tiles to replace (ie if the bridge is not placed far inland)
	--if next(tilesToPlace) ~= nil then
	--	game.settiles(tilesToPlace)
	--end
	
	-- and once again, place our most important tiles just to be extra sure (yes, this is actually needed to prevent some bugs...)
	--if next(centreTilesToPlace) ~= nil then
	--	game.settiles(centreTilesToPlace)
	--end
end

function RWtryDestroyBridge(argumentEntity)

	-- make sure the game doesn't crash if another mod (or us) deletes the entity before we do
	if not argumentEntity.valid then
		return
	end

	local kind = argumentEntity.name
	
	for k,v in pairs(RWwalkableBridgeList) do
		if string.find(kind, v, nil, true)  then
		
			RWdeleteBridgeWalkabilityTiles(argumentEntity.position, v)
			break
		end
	end
end

function RWdeleteBridgeWalkabilityTiles(position, bridgeName)
	
end


-- Roadworks 1.06 code below

-- Bugged, kept only as backup
--[[function RWplaceBridgeTiles(pos)

	local posX = pos.x
	local posY = pos.y
	
	local squareTypes = {}
	
	for tX = 0, -1, -1 do
		for tY = 0, -1, -1 do
			local posKey = (posX + tX) .. "_" .. (posY + tY)
			squareTypes[posKey] = game.gettile(posX + tX, posY + tY).name
		end
	end
	
	local keyNum = nil
	
	for k, v in pairs(squareTypes) do
		for k2, v2 in ipairs(RWbridgeTileList) do
			if v == v2 then
				if (not keyNum) or keyNum > k2 then
					keyNum = k2
				end
				break
			end
		end
	end
	--]]
	--local tileToPlace = RWbridgeWaterList[RWbridgeTileList[keyNum]] -- Oh Lua, you've got to be kidding me
	--[[
	local originalTile = RWbridgeWaterListInverted[tileToPlace]
	
	if not tileToPlace then
		tileToPlace = RWbridgeTileList[keyNum]
	end
	
	if tileToPlace then
	
		if originalTile then
			for k, v in pairs(squareTypes) do
				if v ~= originalTile then
					glob.RWbridgeTileRestoreList[k] = v
				end
			end
		end
	
		local squareTable = {}
	
		for tX = 0, -1, -1 do
			for tY = 0, -1, -1 do
				table.insert(squareTable,{name=tileToPlace, position={x = posX + tX, y = posY + tY}})
			end
		end
	
		game.settiles(squareTable)
	end
end]]

-- Appears not to be needed anymore
function RWcanPlaceBridgeHere(pos, kind)
	local bridges = game.findentitiesfiltered{area = {{pos.x - 3, pos.y - 3}, {pos.x + 3, pos.y + 3}}, name = kind}
	
	for k,v in pairs(bridges) do
		if((v.position.x == pos.x) and (v.position.y == pos.y)) then
			-- ignore, we have found the piece we just placed
		else
			if (math.abs(v.position.x - pos.x) > 2) or (math.abs(v.position.y - pos.y) > 2) then
				game.player.print("Bridges need to be placed either adjacent or at least 2 tiles away from each other")
				return false
			end
		end
	end
	
	return true
end

function RWplaceBridgeTiles(pos)

	local posX = pos.x
	local posY = pos.y
	
	local replaceTiles = {}
	local originalTiles = {}
	
	-- For each square of a 3x3 2-tile grid
	for sX = -1, 1, 1 do
		for sY = -1, 1, 1 do
			-- For each tile of a square
			local replaceNum = nil
			local lastNum = nil
			local foundTwo = false
			local tileCache = {}
			
			for tX = 0, -1, -1 do
				for tY = 0, -1, -1 do
					
					local xPos = (posX + tX) + (sX * 2)
					local yPos = (posY + tY) + (sY * 2)
					
					local posKey = xPos .. "_" .. yPos
					local tileName = game.gettile(xPos, yPos).name
					
					tileCache[posKey] = {xPos, yPos, game.gettile(xPos, yPos).name}
					
					for k, v in ipairs(RWbridgeTileList) do
						if tileName == v then
							if not lastNum then
								lastNum = k
							elseif k ~= lastNum then
								foundTwo = true
							end
							
							if (not replaceNum) or replaceNum > k then
								replaceNum = k
							end
						end
					end
				end
			end
			
			local replaceTileType = nil
			
			if (replaceNum) then
				if (sX == 0) and (sY == 0) then
				
					replaceTileType = RWbridgeWaterList[RWbridgeTileList[replaceNum]]
					
					for k, v in pairs(tileCache) do
						glob.RWbridgeTileRestoreList[k] = v
						replaceTiles[k] = {v[1], v[2], replaceTileType}
					end
				elseif foundTwo then
				
					replaceTileType = RWbridgeTileList[replaceNum]
					
					for k, v in pairs(tileCache) do
						glob.RWbridgeTileRestoreList[k] = v
						replaceTiles[k] = {v[1], v[2], replaceTileType}
					end
				end
			end
		end
	end
	
	local tilesToPlace = {}
	
	for k, v in pairs(replaceTiles) do
		table.insert(tilesToPlace,{name=v[3], position={x = v[1], y = v[2]}})
	end
	
	game.settiles(tilesToPlace)
end

-- Bridge destruction code begins here

function RWdestroyBridge(argumentEntity)

	local kind = argumentEntity.name
	
	for k,v in pairs(RWbridgeList) do
		if string.find(kind, v[2], nil, true)  then
		--if kind == v then
		
			RWdestroyBridgeTiles(argumentEntity.position, v[1])
			break
		end
	end
end

function RWdestroyBridgeTiles(pos, kind)

	local posX = pos.x
	local posY = pos.y

	local squareRestore = {}
	
	local nearBridges = game.findentitiesfiltered{area = {{posX - 5, posY - 5}, {posX + 5, posY + 5}}, name=kind}
	
	--game.player.print("Bridge position: " .. pos.x .. "/" .. pos.y)
	
	--game.player.print("Found " .. #nearBridges .. " bridges")
	
	for sX = -1, 1, 1 do
		for sY = -1, 1, 1 do
			
			local posSX = posX + (2 * sX)
			local posSY = posY + (2 * sY)
			
			-- Check if there are any tiles to restore in this square
			local tileCheck = glob.RWbridgeTileRestoreList[posSX .. "_" .. posSY]
			
			if tileCheck then
				-- Now check if there are no bridges nearby
				local allowed = true
				local centerCounter = 0
				
				for k, v in pairs(nearBridges) do
					local bridgePos = v.position
					
					local xDist = math.abs(bridgePos.x - posSX)
					local yDist = math.abs(bridgePos.y - posSY)
					
					if (xDist <= 2) and (yDist <= 2) then
						if ((sX == 0) and (sY == 0)) then
							centerCounter = centerCounter + 1
						else
							if not ((bridgePos.x == posX) and (bridgePos.y == posY)) then
							--if  (bridgePos.x == posX) and (bridgePos.y == posY) then -- BUG HERE D:
								-- do nothing
							--else
								game.player.print(posSX .. "/" .. posSY .. ": Not allowed :(")
								allowed = false
								break
							end
						end
					end
				end
				
				if allowed then
					for tX = 0, -1, -1 do
						for tY = 0, -1, -1 do
							local xPos = posSX + tX
							local yPos = posSY + tY
							
							-- If no bridge is around, restore everything, otherwise keep it until other bridge pieces are destroyed
							if centerCounter > 1 then
								game.player.print("Replacing myself with correct floor")
								local tileType = game.gettile(xPos, yPos).name
								
								table.insert(squareRestore,{name=RWbridgeWaterListInverted[tileType], position={x = xPos, y = yPos}})
							else
								local tileKey = xPos .. "_" .. yPos
							
								local originalTile = glob.RWbridgeTileRestoreList[tileKey]
								
								-- Just a safety check, if originalTile is nil, something has gone wrong.
								if originalTile then
									table.insert(squareRestore,{name=originalTile[3], position={x = xPos, y = yPos}})
								
									glob.RWbridgeTileRestoreList[tileKey] = nil
								else
									game.player.print("Whoops, trouble!")
								end
							end
						end
					end
				end
			end
		end
	end
	
	if #squareRestore > 0 then
		game.settiles(squareRestore)
	end
end

--[[function RWdestroyBridgeTiles(pos, kind)

	local posX = pos.x
	local posY = pos.y

	local squareRestore = {}
	
	local nearBridges = game.findentities{{posX - RWbridgeCorrectionDistance - 2, posY - RWbridgeCorrectionDistance - 2}, {posX + RWbridgeCorrectionDistance + 1, posY + RWbridgeCorrectionDistance + 1}}
	
	for tX = RWbridgeCorrectionDistance, -RWbridgeCorrectionDistance - 1, -1 do
		for tY = RWbridgeCorrectionDistance, -RWbridgeCorrectionDistance - 1, -1 do
			local posKey = (posX + tX) .. "_" .. (posY + tY)
			
			if ((tX == 0 or tX == -1) and (tY == 0 or tY == -1)) and glob.RWbridgeTileRestoreList[posKey] then
				local kPos = {}
				for v in string.gmatch(posKey, "([^_]+)") do
					table.insert(kPos, v)
				end
				table.insert(squareRestore, {name=glob.RWbridgeTileRestoreList[posKey], position = {x = kPos[1], y = kPos[2]}})
				glob.RWbridgeTileRestoreList[posKey] = nil
			else
				local check = true
				
				for k, v in pairs(nearBridges) do
					if string.find(v.name, kind, nil, true) then
						local bridgePos = v.position
						
						if not ((bridgePos.x == pos.x) and (bridgePos.y == pos.y)) then
							if ((posX + tX) == bridgePos.x or (posX + tX) == bridgePos.x - 1) and ((posY + tY) == bridgePos.y or (posY + tY) == bridgePos.y - 1) then
								check = false
								break
							end
						end
					end
				end
				
				if check then
					local tileName = game.gettile(posX + tX, posY + tY).name
					
					for k, v in pairs(RWbridgeWaterList) do
						if tileName == v then
							table.insert(squareRestore, {name=k, position={x = posX + tX, y = posY + tY}})
							break
						end
					end
				end
			end
		end
	end
	
	if #squareRestore > 0 then
		game.settiles(squareRestore)
	end
end]]