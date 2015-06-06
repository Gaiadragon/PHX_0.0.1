require "defines"

local playerCarPointers = {}

function RWcarSpeedModifiersTick()

	if game.tick % RWcarSpeedModifiersFrequency == 0 then
	
		for k, v in pairs(game.players) do
			if game.players[k].vehicle and game.players[k].vehicle.valid and game.players[k].vehicle.type == "car" then
				if not playerCarPointers[k] then
				
					playerCarPointers[k] = game.players[k].vehicle
				end
				
				-- Check if the car is on any road and change its friction accordingly
				local frictionModifier = 1
				
				local carPosition = playerCarPointers[k].position
				
				local entities = game.findentitiesfiltered{area = {{carPosition.x - 0.75, carPosition.y - 0.75}, {carPosition.x + 0.75, carPosition.y + 0.75}}, type="simple-entity"}
				
				for k, v in pairs(entities) do
					
					--game.player.print("Found entity " .. v.name)
					
					for k2, v2 in pairs(RWroadSpeedModifierList) do
						--local surfaceName = string.sub(v.name, 1, string.len(k2))
					
						--if (k2 == surfaceName) then
						if (k2 .. "-center" == v.name) then
							frictionModifier = v2
							break
						end
					end
				end
				
				if frictionModifier ~= playerCarPointers[k].frictionmodifier then
					playerCarPointers[k].frictionmodifier = frictionModifier
					--game.players[k].print("Making friction modifier " .. frictionModifier)
				end
				
				-- Check which type of fuel the car uses and change its efficiency and consumption accordingly
				local fuelInventory = playerCarPointers[k].getinventory(1)
				
				local effectivityModifier = 1
				local consumptionModifier = 1
				
				for k, v in pairs(RWfuelSpeedModifierList) do
					if fuelInventory.getitemcount(k) > 0 then
						effectivityModifier = v[1]
						consumptionModifier = v[2]
						break
					end
				end
				
				if effectivityModifier ~= playerCarPointers[k].effectivitymodifier then
					playerCarPointers[k].effectivitymodifier = effectivityModifier
					--game.players[k].print("Making efficiency modifier " .. effectivityModifier)
				end
				
				if consumptionModifier ~= playerCarPointers[k].consumptionmodifier then
					playerCarPointers[k].consumptionmodifier = consumptionModifier
					--game.players[k].print("Making consumption modifier " .. consumptionModifier)
				end
			elseif playerCarPointers[k] then
				
				if playerCarPointers[k].valid then
				
					playerCarPointers[k].effectivitymodifier = 1
					playerCarPointers[k].consumptionmodifier = 1
					playerCarPointers[k].frictionmodifier = 1
					
					--game.players[k].print("Reverting all modifiers to 1")
				end
			
				playerCarPointers[k] = nil
			end
		end
	end
end




	