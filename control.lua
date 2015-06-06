require "defines"
require "interfaces"




local seedTypeLookUpTable = {}
function populateSeedTypeLookUpTable()
  for seedTypeName, seedType in pairs(glob.tf.seedPrototypes) do
    for _, stateName in pairs(seedType.states) do
      seedTypeLookUpTable[stateName] = seedTypeName
    end
  end
end



game.oninit(function()

  if glob.tf == nil then
    glob.tf = {}
    glob.tf.fieldList = {}
    glob.tf.seedPrototypes = {}
      defineStandardSeedPrototypes()
    populateSeedTypeLookUpTable()
    glob.tf.growing = {}
    glob.tf.playersData = {}
    for pIndex, player in ipairs(game.players) do
      if glob.tf.playersData[pIndex] == nil then
        glob.tf.playersData[pIndex] = {}
        glob.tf.playersData[pIndex].guiOpened = false
        glob.tf.playersData[pIndex].overlayStack = {}
      end
    end
  end
end)



game.onevent(defines.events.onplayercreated, function(event)
  if glob.tf.playersData[event.playerindex] == nil then
    glob.tf.playersData[event.playerindex] = {}
    glob.tf.playersData[event.playerindex].guiOpened = false
    glob.tf.playersData[event.playerindex].overlayStack = {}
  end
end)



game.onload(function()
  for _, plantTypes in pairs(glob.tf.seedPrototypes) do
    if plantTypes.efficiency.other == 0 then
      plantTypes.efficiency.other = 0.01
    end
  end

  for seedTypeName, seedPrototype in pairs (glob.tf.seedPrototypes) do
    if game.itemprototypes[seedPrototype.states[1]] == nil then
      glob.tf.seedPrototypes[seedTypeName] = nil
    end
  end

  if seedTypeLookUpTable ~= nil then
    seedTypeLookUpTable = {}
  end
  populateSeedTypeLookUpTable()
end)



game.onevent(defines.events.onguiclick, function(event)
  local index = -1

  for k,field in ipairs(glob.tf.fieldList) do
    if (glob.tf.playersData[event.element.playerindex].guiOpened ~= false) and (glob.tf.playersData[event.element.playerindex].guiOpened.equals(field.entity)) then
      index = k
      break
    end
  end
  if index == -1 then return end
  local player = game.players[event.element.playerindex]
  if event.element.name == "okButton" then
    if player.gui.center.fieldmk2Root ~= nil then
      destroyOverlay(event.element.playerindex)
      glob.tf.playersData[event.element.playerindex].guiOpened = false
      player.gui.center.fieldmk2Root.destroy()
    end
  elseif event.element.name == "toggleActiveBut" then
    if glob.tf.fieldList[index].active == true then
      glob.tf.fieldList[index].active = false
      mk2CancelDecontruction(glob.tf.fieldList[index])
      player.gui.center.fieldmk2Root.fieldmk2Table.colLabel2.caption = "not active"
    else
      glob.tf.fieldList[index].active = true
      mk2MarkDeconstruction(glob.tf.fieldList[index])
      player.gui.center.fieldmk2Root.fieldmk2Table.colLabel2.caption = "active"
    end
    destroyOverlay(event.element.playerindex)
    createOverlay(event.element.playerindex, glob.tf.fieldList[index])
  elseif event.element.name == "incAreaBut" then
    if glob.tf.fieldList[index].areaRadius < 9 then
      glob.tf.fieldList[index].areaRadius = glob.tf.fieldList[index].areaRadius + 1
      destroyOverlay(event.element.playerindex)
      createOverlay(event.element.playerindex, glob.tf.fieldList[index])
    end
    player.gui.center.fieldmk2Root.fieldmk2Table.areaLabel2.caption = glob.tf.fieldList[index].areaRadius
  elseif event.element.name == "decAreaBut" then
    if glob.tf.fieldList[index].areaRadius > 1 then
      glob.tf.fieldList[index].areaRadius = glob.tf.fieldList[index].areaRadius - 1
      destroyOverlay(event.element.playerindex)
      createOverlay(event.element.playerindex, glob.tf.fieldList[index])
    end
    player.gui.center.fieldmk2Root.fieldmk2Table.areaLabel2.caption = glob.tf.fieldList[index].areaRadius
  end

end)



game.onevent(defines.events.onputitem, function(event)
  for playerIndex,player in pairs(game.players) do
    if (player ~= nil) and (player.selected ~= nil) then
      if player.selected.name == "tf-fieldmk2" then
        for index, entInfo in ipairs(glob.tf.fieldList) do
          if entInfo.entity.equals(player.selected) then
            showFieldmk2GUI(index, playerIndex)
            glob.tf.playersData[playerIndex].guiOpened = entInfo.entity
          end
        end
      end
    end
  end
end)



game.onevent(defines.events.onbuiltentity, function(event)
  local player = game.players[event.playerindex]
  if event.createdentity.type == "tree" then
    local currentSeedTypeName = seedTypeLookUpTable[event.createdentity.name]
    if currentSeedTypeName ~= nil then
      local newEfficiency = calcEfficiency(event.createdentity, false)
      local deltaTime = math.ceil((math.random() * glob.tf.seedPrototypes[currentSeedTypeName].randomGrowingTime + glob.tf.seedPrototypes[currentSeedTypeName].basicGrowingTime) / newEfficiency)
      local nextUpdateIn = event.tick + deltaTime
      local entInfo =
      {
        entity = event.createdentity,
        state = 1,
        efficiency = newEfficiency,
        nextUpdate = nextUpdateIn
      }
      placeSeedIntoList(entInfo)
      return
    end
  elseif event.createdentity.name == "tf-field" then
    if canPlaceField(event.createdentity) ~= true then
      player.insert{name = "tf-field", count = 1}
      event.createdentity.destroy()
      player.print({"msg_buildingFail"})
      return
    else
      local entInfo =
      {
        entity = event.createdentity,
        fertAmount = 0,
        lastSeedPos = {x = 2, y = 0}, -- 2;1
        nextUpdate = event.tick + 60
      }
      table.insert(glob.tf.fieldList, entInfo)
      return
    end
  elseif event.createdentity.name == "tf-fieldmk2Overlay" then
    local ent = game.createentity{name = "tf-fieldmk2",
                    position = event.createdentity.position,
                    force = player.force}
    local entInfo =
    {
      entity = ent,
      active = true,
      areaRadius = 9,
      fertAmount = 0,
      lastSeedPos = {x = -9, y = -9},
      toBeHarvested = {},
      nextUpdate = event.tick + 60
    }
    table.insert(glob.tf.fieldList, entInfo)
    showFieldmk2GUI(#glob.tf.fieldList, event.playerindex)
    glob.tf.playersData[event.playerindex].guiOpened = entInfo.entity
    event.createdentity.destroy()
    return
  end
end)


game.onevent(defines.events.onrobotbuiltentity, function(event)
  local player = game.players[event.playerindex]
  if event.createdentity.type == "tree" then
    local currentSeedTypeName = seedTypeLookUpTable[event.createdentity.name]
    if currentSeedTypeName ~= nil then
      local newEfficiency = calcEfficiency(event.createdentity, false)
      local deltaTime = math.ceil((math.random() * glob.tf.seedPrototypes[currentSeedTypeName].randomGrowingTime + glob.tf.seedPrototypes[currentSeedTypeName].basicGrowingTime) / newEfficiency)
      local nextUpdateIn = event.tick + deltaTime
      local entInfo =
      {
        entity = event.createdentity,
        state = 1,
        efficiency = newEfficiency,
        nextUpdate = nextUpdateIn
      }
      placeSeedIntoList(entInfo)
      return
    end
  elseif event.createdentity.name == "tf-field" then
    if canPlaceField(event.createdentity) ~= true then
      game.createentity{name = "item-on-ground", position = event.createdentity.position, stack = {name = "tf-field", count = 1}}
      event.createdentity.destroy()
      return
    else
      local entInfo =
      {
        entity = event.createdentity,
        fertAmount = 0,
        lastSeedPos = {x = 2, y = 0}, -- 2;1
        nextUpdate = event.tick + 60
      }
      table.insert(glob.tf.fieldList, entInfo)
      return
    end
  elseif event.createdentity.name == "tf-fieldmk2Overlay" then
    local ent = game.createentity{name = "tf-fieldmk2",
                    position = event.createdentity.position,
                    force = player.force}
    local entInfo =
    {
      entity = ent,
      active = true,
      areaRadius = 9,
      fertAmount = 0,
      lastSeedPos = {x = -9, y = -9},
      toBeHarvested = {},
      nextUpdate = event.tick + 60
    }
    table.insert(glob.tf.fieldList, entInfo)

    --glob.treefarm.tmpData.fieldmk2Index = #glob.treefarm.fieldmk2
    --showFieldmk2GUI(#glob.treefarm.fieldmk2, event.playerindex)
    event.createdentity.destroy()
    return
  end
end)



game.onevent(defines.events.ontick, function(event)
  while ((glob.tf.fieldList[1] ~= nil) and (event.tick >= glob.tf.fieldList[1].nextUpdate)) do
    local fieldEnt = glob.tf.fieldList[1].entity
    if fieldEnt.valid then
      if fieldEnt.name == "tf-field" then
        fieldMaintainer(event.tick)
      elseif fieldEnt.name == "tf-fieldmk2" then
        fieldmk2Maintainer(event.tick)
      end
    else
      table.remove(glob.tf.fieldList, 1)
    end
  end

  while ((glob.tf.growing[1] ~= nil) and (event.tick >= glob.tf.growing[1].nextUpdate)) do
    local removedEntity = table.remove(glob.tf.growing, 1)
    local seedTypeName
    local newState
    if removedEntity.entity.valid then
      seedTypeName = seedTypeLookUpTable[removedEntity.entity.name]
      newState = removedEntity.state + 1
      if newState <= #glob.tf.seedPrototypes[seedTypeName].states then
        local tmpPos = removedEntity.entity.position
        local newEnt = game.createentity{name = glob.tf.seedPrototypes[seedTypeLookUpTable[removedEntity.entity.name]].states[newState], position = tmpPos}
        removedEntity.entity.destroy()
        local deltaTime = math.ceil((math.random() * glob.tf.seedPrototypes[seedTypeName].randomGrowingTime + glob.tf.seedPrototypes[seedTypeName].basicGrowingTime) / removedEntity.efficiency)
        local updatedEntry =
        {
          entity = newEnt,
          state = newState,
          efficiency = removedEntity.efficiency,
          nextUpdate = event.tick + deltaTime
        }
        placeSeedIntoList(updatedEntry)
      elseif (isInMk2Range(removedEntity.entity.position)) then
        removedEntity.entity.orderdeconstruction(game.forces.player)
      end
    end
  end
end)




function canPlaceField(field)
  local fPosX, fPosY = field.position.x, field.position.y
  for x = 1, 9 do
    for y = 0, 7 do
      if not game.canplaceentity{name="wooden-chest", position = {fPosX + x, fPosY + y}} then
        local playerEnt = game.findentitiesfiltered{area = {{fPosX + x - 1, fPosY + y - 1},{fPosX + x + 1, fPosY + y + 1}}, name="player"}
        if not (#playerEnt > 0) then return false end
      end
    end
  end

  local blockingField = game.findentitiesfiltered{area = {{x = fPosX - 9, y = fPosY - 8}, {fPosX + 8, fPosY + 8}}, name="tf-field"}
  if #blockingField > 1 then return false end
  return true
end



function defineStandardSeedPrototypes()
  glob.tf.seedPrototypes.basicTree =
  {
    states =
    {
      "tf-germling",
      "tf-very-small-tree",
      "tf-small-tree",
      "tf-medium-tree",
      "tf-mature-tree"
    },
    output = {"raw-wood", 5},
    efficiency = 
    {
      ["grass"] = 1.00,
      ["grass-medium"] = 1.00,
      ["grass-dry"] = 0.90,
      ["dirt"] = 0.75,
      ["dirt-dark"] = 0.75,
      ["hills"] = 0.50,
      ["sand"] = 0.30,
      ["sand-dark"] = 0.30,

      ["other"] = 0.01
    },
    basicGrowingTime = 18000,
    randomGrowingTime = 9000,
    fertilizerBoost = 1.00
  }

  glob.tf.seedPrototypes.basicCoral =
  {
    states =
    {
      "tf-coral-seed",
      "tf-small-coral",
      "tf-medium-coral",
      "tf-mature-coral"
    },
    output = {"raw-wood", 3},
    efficiency = 
    {
      ["grass"] = 0.50,
      ["grass-medium"] = 0.50,
      ["grass-dry"] = 0.70,
      ["dirt"] = 0.75,
      ["dirt-dark"] = 0.75,
      ["hills"] = 0.75,
      ["sand"] = 1.00,
      ["sand-dark"] = 1.00,

      ["other"] = 0.01
    },
    basicGrowingTime = 1000,
    randomGrowingTime = 1000,
    fertilizerBoost = 2.00
  }
end



function calcEfficiency(entity, fertilizerApplied)
  local seedType = seedTypeLookUpTable[entity.name]
  local currentTilename = game.gettile(entity.position.x, entity.position.y).name

  local efficiency
  if glob.tf.seedPrototypes[seedType].efficiency[currentTilename] == nil then
    return glob.tf.seedPrototypes[seedType].efficiency.other
  else
    efficiency = glob.tf.seedPrototypes[seedType].efficiency[currentTilename]
    if fertilizerApplied then
      return efficiency + glob.tf.seedPrototypes[seedType].fertilizerBoost
    else
      return efficiency
    end
  end
end



function placeSeedIntoList(entInfo)
  if #glob.tf.growing > 1 then
    for i = #glob.tf.growing, 1, -1 do
      if glob.tf.growing[i].nextUpdate <= entInfo.nextUpdate then
        table.insert(glob.tf.growing, i + 1, entInfo)
        return
      end
    end
    table.insert(glob.tf.growing, 1, entInfo)
  elseif #glob.tf.growing == 1 then
    if glob.tf.growing[1].nextUpdate > entInfo.nextUpdate then
      table.insert(glob.tf.growing, 1, entInfo)
    else
      table.insert(glob.tf.growing, entInfo)
    end
  else
    table.insert(glob.tf.growing, entInfo)
  end
end



function isInMk2Range(plantPos)
  for _, field in ipairs(glob.tf.fieldList) do
    if (field.entity.valid) and (field.entity.name == "tf-fieldmk2") and (field.active == true) then
      local fieldPos = field.entity.position
      local areaPosMin = {x = fieldPos.x - field.areaRadius - 1, y = fieldPos.y - field.areaRadius - 1}
      local areaPosMax = {x = fieldPos.x + field.areaRadius + 1, y = fieldPos.y + field.areaRadius + 1}
      if (plantPos.x >= areaPosMin.x) and
         (plantPos.x <= areaPosMax.x) and
         (plantPos.y >= areaPosMin.y) and
         (plantPos.y <= areaPosMax.y) then
        return true
      end
    end
  end
  return false
end



function fieldMaintainer(tick)
  -- SEEDPLANTING --
  local seedInInv = {name ="DUMMY", amount = "DUMMY"}
  local fieldObj = glob.tf.fieldList[1]
  for _,seedType in pairs(glob.tf.seedPrototypes) do
    local newAmount = fieldObj.entity.getinventory(1).getitemcount(seedType.states[1])
    if newAmount > 0 then
      seedInInv =
      {
        name = seedType.states[1],
        amount = newAmount
      }
      break
    end
  end

  local seedPos = false
  if seedInInv.name ~= "DUMMY" then
    local fieldPos = fieldObj.entity.position
    local placed = false
    local lastPos = fieldObj.lastSeedPos

    for dx = lastPos.x, 8 do
      for dy = 0, 6 do
        if (game.canplaceentity{name = "tf-germling", position = {fieldPos.x + dx - 0.5, fieldPos.y + dy - 0.5}}) then
          seedPos = {x = fieldPos.x + dx - 0.5, y = fieldPos.y + dy - 0.5}
          placed = true
          fieldObj.lastSeedPos = {x = dx, y = dy}
          break
        end
      end
      if placed == true then
        break
      end
    end

    if (placed == false) and (lastPos.x ~= 2) then
      for dx = 2, lastPos.x - 1 do
        for dy = 0, 6 do
          if (game.canplaceentity{name = "tf-germling", position = {fieldPos.x + dx - 0.5, fieldPos.y + dy - 0.5}}) then
            seedPos = {x = fieldPos.x + dx - 0.5, y = fieldPos.y + dy - 0.5}
            placed = true
            fieldObj.lastSeedPos = {x = dx, y = dy}
            break
          end
        end
        if placed == true then
          break
        end
      end
    end

    if seedPos ~= false then

      local seedTypeName = seedTypeLookUpTable[seedInInv.name]
      local newPlant = game.createentity{name = seedInInv.name, position = seedPos}
      local newFertilized = false

      if (fieldObj.fertAmount < 0.1) and (game.itemprototypes["tf-fertilizer"] ~= nil) and (fieldObj.entity.getinventory(2).getitemcount("tf-fertilizer") > 0) then
        fieldObj.fertAmount = 1
        fieldObj.entity.getinventory(2).remove{name = "tf-fertilizer", count = 1}
      end

      if fieldObj.fertAmount >= 0.1 then
        fieldObj.fertAmount = fieldObj.fertAmount - 0.1
        newFertilized = true
      end
 
      local newEfficiency = calcEfficiency(newPlant, newFertilized)
      local entInfo =
      {
        entity = newPlant,
        state = 1,
        efficiency = newEfficiency,
        nextUpdate = tick + math.ceil((math.random() * glob.tf.seedPrototypes[seedTypeName].randomGrowingTime + glob.tf.seedPrototypes[seedTypeName].basicGrowingTime) / newEfficiency)
      }
      fieldObj.entity.getinventory(1).remove{name = seedInInv.name, count = 1}
      placeSeedIntoList(entInfo)
    end
  end

  -- HARVESTING --
  local fieldPos = fieldObj.entity.position
  local grownEntities = game.findentitiesfiltered{area = {fieldPos, {fieldPos.x + 9, fieldPos.y + 8}}, type = "tree"}
  for _,entity in ipairs(grownEntities) do
    for _,seedType in pairs(glob.tf.seedPrototypes) do
      if entity.name == seedType.states[#seedType.states] then
        local output = {name = seedType.output[1], amount = seedType.output[2]}
        local stackSize = game.itemprototypes[output.name].stacksize
        if (fieldObj.entity.getinventory(3).caninsert{name = output.name, count = output.amount}) and (stackSize - fieldObj.entity.getinventory(3).getitemcount(output.name) >= output.amount) then
          fieldObj.entity.getinventory(3).insert{name = output.name, count = output.amount}
          entity.destroy()
        end
        fieldObj.nextUpdate = tick + 60
        table.remove(glob.tf.fieldList, 1)
        table.insert(glob.tf.fieldList, fieldObj)
        return
      end
    end
  end
  glob.tf.fieldList[1].nextUpdate = tick + 60
  local field = table.remove(glob.tf.fieldList, 1)
  table.insert(glob.tf.fieldList, field)
end



function fieldmk2Maintainer(tick)
  -- SEEDPLANTING --
  local seedInInv = {name ="DUMMY", amount = "DUMMY"}
  local fieldObj = glob.tf.fieldList[1]
  for _,seedType in pairs(glob.tf.seedPrototypes) do
    local newAmount = fieldObj.entity.getitemcount(seedType.states[1])
    if newAmount > 0 then
      seedInInv =
      {
        name = seedType.states[1],
        amount = newAmount
      }
      break
    end
  end
  local seedPos = false
  if seedInInv.name ~= "DUMMY" then
    local fieldPos = fieldObj.entity.position
    local placed = false
    local lastPos = fieldObj.lastSeedPos
    if lastPos.x < -fieldObj.areaRadius then
      lastPos.x = -fieldObj.areaRadius
    elseif lastPos.x > fieldObj.areaRadius then
      lastPos.x = fieldObj.areaRadius
    end
    if lastPos.y < -fieldObj.areaRadius then
      lastPos.y = -fieldObj.areaRadius
    elseif lastPos.y > fieldObj.areaRadius then
      lastPos.y = fieldObj.areaRadius
    end
    for dx = lastPos.x, fieldObj.areaRadius do
      for dy = -fieldObj.areaRadius, fieldObj.areaRadius do
        if (game.canplaceentity{name = "tf-germling", position = {fieldPos.x + dx - 0.5, fieldPos.y + dy - 0.5}}) then
          seedPos = {x = fieldPos.x + dx - 0.5, y = fieldPos.y + dy - 0.5}
          placed = true
          fieldObj.lastSeedPos = {x = dx, y = dy}
          break
        end
      end
      if placed == true then
        break
      end
    end
    if (placed == false) and (lastPos.x ~= -fieldObj.areaRadius) then
      for dx = -fieldObj.areaRadius, lastPos.x - 1 do
        for dy = -fieldObj.areaRadius, fieldObj.areaRadius do
          if (game.canplaceentity{name = "tf-germling", position = {fieldPos.x + dx - 0.5, fieldPos.y + dy - 0.5}}) then
            seedPos = {x = fieldPos.x + dx - 0.5, y = fieldPos.y + dy - 0.5}
            placed = true
            fieldObj.lastSeedPos = {x = dx, y = dy}
            break
          end
        end
        if placed == true then
          break
        end
      end
    end
    if seedPos ~= false then
      local seedTypeName = seedTypeLookUpTable[seedInInv.name]
      local newEntity = game.createentity{name = seedInInv.name, position = seedPos}
      local newFertilized = false
      if (fieldObj.fertAmount < 0.1) and (game.itemprototypes["tf-fertilizer"] ~= nil) and (fieldObj.entity.getinventory(1).getitemcount("tf-fertilizer") > 0) then
        fieldObj.fertAmount = 1
        fieldObj.entity.getinventory(1).remove{name = "tf-fertilizer", count = 1}
      end
      if fieldObj.fertAmount >= 0.1 then
        fieldObj.fertAmount = fieldObj.fertAmount - 0.1
        newFertilized = true
      end
      local newEfficiency = calcEfficiency(newEntity, newFertilized)
      local entInfo =
      {
        entity = newEntity,
        state = 1,
        efficiency = newEfficiency,
        nextUpdate = tick + math.ceil((math.random() * glob.tf.seedPrototypes[seedTypeName].randomGrowingTime + glob.tf.seedPrototypes[seedTypeName].basicGrowingTime) / newEfficiency)
      }
      fieldObj.entity.getinventory(1).remove{name = seedInInv.name, count = 1}
      placeSeedIntoList(entInfo)
    end
  end
  -- HARVESTING --
  -- is done in tree-growing function --
  fieldObj.nextUpdate = tick + 60
  table.remove(glob.tf.fieldList, 1)
  table.insert(glob.tf.fieldList, fieldObj)
end





function showFieldmk2GUI(index, playerIndex)
  local player = game.players[playerIndex]
  if player.gui.center.fieldmk2Root == nil then
    local rootFrame = player.gui.center.add{type = "frame", name = "fieldmk2Root", caption = game.getlocalisedentityname("tf-fieldmk2"), direction = "vertical"}
      local rootTable = rootFrame.add{type ="table", name = "fieldmk2Table", colspan = 4}
        rootTable.add{type = "label", name = "colLabel1", caption = {"thisFieldIs"}}
        local status = "active / not active"
        if glob.tf.fieldList[index].active == true then
          status = {"active"}
        else
          status = {"notActive"}
        end
        rootTable.add{type = "label", name = "colLabel2", caption = status}
        rootTable.add{type = "button", name = "toggleActiveBut", caption = {"toggleButtonCaption"}, style = "tf_smallerButtonFont"}
        rootTable.add{type = "label", name = "colLabel4", caption = ""}

        rootTable.add{type = "label", name = "areaLabel1", caption = {"usedArea"}}
        rootTable.add{type = "label", name = "areaLabel2", caption = glob.tf.fieldList[index].areaRadius}
        rootTable.add{type = "button", name = "incAreaBut", caption = "+", style = "tf_smallerButtonFont"}
        rootTable.add{type = "button", name = "decAreaBut", caption = "-", style = "tf_smallerButtonFont"}
      rootFrame.add{type = "button", name = "okButton", caption = {"okButtonCaption"}, style = "tf_smallerButtonFont"}

    if (glob.tf.playersData[playerIndex].overlayStack == nil) or (#glob.tf.playersData[playerIndex].overlayStack == 0) then
      createOverlay(playerIndex, glob.tf.fieldList[index])
    end
  end
end



function createOverlay(playerIndex, fieldTable)
  local radius = fieldTable.areaRadius
  local startPos = {x = fieldTable.entity.position.x - radius,
                    y = fieldTable.entity.position.y - radius}

  if fieldTable.active == true then
    for i = 0, 2 * radius + 1 do
      for j = 0, 2 * radius + 1 do
        local overlay = game.createentity{name = "tf-overlay-green", position ={x = startPos.x + i, y = startPos.y + j}, force = game.forces.player}
        table.insert(glob.tf.playersData[playerIndex].overlayStack, overlay)
      end
    end
  else
    for i = 0, 2 * radius + 1 do
      for j = 0, 2 * radius + 1 do
        local overlay = game.createentity{name = "tf-overlay-red", position ={x = startPos.x + i, y = startPos.y + j}, force = game.forces.player}
        table.insert(glob.tf.playersData[playerIndex].overlayStack, overlay)
      end
    end
  end
end



function destroyOverlay(playerIndex)
  for _, overlay in ipairs(glob.tf.playersData[playerIndex].overlayStack) do
    if overlay.valid then
      overlay.destroy()
    end
  end
  glob.tf.playersData[playerIndex].overlayStack = {}
end



function mk2CancelDecontruction(field)
  local fieldPos = {x = field.entity.position.x, y = field.entity.position.y}
  local areaPosMin = {x = fieldPos.x - field.areaRadius - 1, y = fieldPos.y - field.areaRadius - 1}
  local areaPosMax = {x = fieldPos.x + field.areaRadius + 1, y = fieldPos.y + field.areaRadius + 1}
  local tmpEntities = game.findentitiesfiltered{area = {areaPosMin, areaPosMax}, type = "tree"}

  if #tmpEntities > 0 then
    for i = 1, #tmpEntities do
      for _, seedType in pairs(glob.tf.seedPrototypes) do
        if (tmpEntities[i].name == seedType.states[#seedType.states]) and (tmpEntities[i].tobedeconstructed(game.forces.player) == true) then
          tmpEntities[i].canceldeconstruction(game.forces.player)
        end
      end
    end
  end
end



function mk2MarkDeconstruction(field)
  local fieldPos = {x = field.entity.position.x, y = field.entity.position.y}
  local areaPosMin = {x = fieldPos.x - field.areaRadius - 1, y = fieldPos.y - field.areaRadius - 1}
  local areaPosMax = {x = fieldPos.x + field.areaRadius + 1, y = fieldPos.y + field.areaRadius + 1}
  local tmpEntities = game.findentitiesfiltered{area = {areaPosMin, areaPosMax}, type = "tree"}

  if #tmpEntities > 0 then
    for i = 1, #tmpEntities do
      for _, seedType in pairs(glob.tf.seedPrototypes) do
        if (tmpEntities[i].name == seedType.states[#seedType.states]) and (tmpEntities[i].tobedeconstructed(game.forces.player) == false) then
          tmpEntities[i].orderdeconstruction(game.forces.player)
        end
      end
    end
  end
end