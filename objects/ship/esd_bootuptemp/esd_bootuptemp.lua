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
		for object in ipairs(objects) do
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
end