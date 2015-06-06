require "defines"

function RWcursorstackInsert(itemName, itemCount, player)

	local cursorstack = game.players[player].cursorstack
	
	if cursorstack and cursorstack.name == itemName then
		if itemCount > 0 then
			local stackSize = game.itemprototypes[itemName].stacksize
		
			if (cursorstack.count + itemCount) <= stackSize then
				cursorstack.count = cursorstack.count + itemCount
			
				game.players[player].cursorstack = cursorstack
			else
				itemCount = itemCount - (stackSize - cursorstack.count)

				cursorstack.count = stackSize
			
				game.players[player].cursorstack = cursorstack

				game.players[player].insert({name=itemName, count=itemCount})
			end
		elseif itemCount < 0 then
			itemCount = -itemCount
			
			if cursorstack.count > itemCount then
				cursorstack.count = cursorstack.count - itemCount
			
				game.players[player].cursorstack = cursorstack
			else
				itemCount = itemCount - cursorstack.count

				game.players[player].cursorstack = nil

				if itemCount > 0 then
					game.players[player].removeitem({name=itemName, count=itemCount})
				end
			end
		end
	else
		if itemCount > 0 then
			game.players[player].insert({name=itemName, count=itemCount})
		elseif itemCount < 0 then
			itemCount = -itemCount
			game.players[player].removeitem({name=itemName, count=itemCount})
		end
	end
end

function RWtwoDeepCheck(tab, firstKey, secondKey)
	if (tab[firstKey]) then
		if (tab[firstKey][secondKey]) then
			return true
		end
	end
	
	return false
end