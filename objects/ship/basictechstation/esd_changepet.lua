local origInit = init or function() end

function init()
	origInit()
	
	message.setHandler("esdChangePet", function(_, _, pet)
		object.setConfigParameter("shipPetType", pet)
		self.monsterType = config.getParameter("shipPetType", "petcat")
		world.callScriptedEntity(self.petId, "status.setResource", "health", 0)
		self.petParams = {}
	end)
end