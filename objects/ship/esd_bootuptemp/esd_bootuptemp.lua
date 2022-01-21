function init()
	universeServer = root.assetJson("/universe_server.config")
end

function update()
	-- Get the players race if it hasn't already been gotten (this assumes the owner is the only player on the ship when the object is first loaded)
	if not storage.race then
		local playerId = world.playerQuery(entity.position(), 100)[1]
		if not playerId then
			return
		end
		storage.race = world.entitySpecies(playerId)
	end
	
	-- Set the ship pet if it hasn't been done yet
	if not storage.petSet then
		local objects = world.objectQuery(entity.position(), 100)
		local techstation
		-- Find which object is the techstation
		for _, object in ipairs(objects) do
			if world.entityName(object) == "basictechstation" then
				techstation = object
				break
			end
		end
		if techstation then
			local pet = universeServer.esdShipPetList[storage.race] or universeServer.esdShipPetList.default
			-- Change the ship pet
			world.sendEntityMessage(techstation, "esdChangePet", pet)
			storage.petSet = true
		end
	end
	
	-- Give the starter treasure if it hasn't been done yet and the ship isn't tier 0
	if not storage.treasureGiven and world.getProperty("ship.level", 0) > 0 then
		local objects = world.objectQuery(entity.position(), 100)
		local shiplocker
		-- Find which object is the shiplocker
		for _, object in ipairs(objects) do
			if world.entityName(object) == "basicshiplocker" then
				shiplocker = object
				break
			end
		end
		if shiplocker then
			local treasurePool = universeServer.esdShipTreasureList[storage.race] or universeServer.esdShipTreasureList.default
			local treasure = root.createTreasure(treasurePool, 0)
			for _, item in ipairs (treasure) do
				world.containerAddItems(shiplocker, item)
			end
			storage.treasureGiven = true
		end
	end
	
	-- Destroy the object if it has completed its jobs
	if storage.petSet and storage.treasureGiven then
		object.smash()
	end
end