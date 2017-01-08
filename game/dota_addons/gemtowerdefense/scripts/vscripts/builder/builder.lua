if Builder == nil then
	Builder = class({})
	
end



function Builder:Init()


	function RemoveHeroAbilities(caster)

		caster:FindAbilityByName("gem_build_tower"):SetLevel(0)
		caster:FindAbilityByName("gem_remove_tower"):SetLevel(0)

	end

	function AddTowerConfirmAbility(playerID)

    	for key, tower in pairs(self.RoundTowers[playerID]) do 

			tower:AddAbility("gem_pick_tower"):SetLevel(1)
        
    	end

	end

	function AddTowerDowngradeAbility(playerID)

		for key, tower in pairs(self.RoundTowers[playerID]) do

			if tonumber(tower.Level) == 1 then

			elseif tonumber(tower.Level) >= 2 then

				tower:AddAbility("gem_downgrade_tower"):SetLevel(1)

			end

		end

	end

	function HasBuilderPlaced(playerID)

		if Builder:TableLength(self.RoundTowers[playerID]) == 5 then

			return true

		else

			return false

		end

	end

	function CheckIfAllPicked()

		print("PlayerCount in CheckIfAllPicked", PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS))

		if self.PickCount == PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) then
			
			self.PickCount = 0
			
			Builder:WaveCheckIfMergeable()
			Builder:WaveAddTowerMergeAbility()
			
			FireGameEvent("all_placed", {state = "Something"})

		else
		end


	end

	function CheckIfMergeable(playerID)

		

    	for key, tower in pairs(self.RoundTowers[playerID]) do
    		
        	local towerName = tower:GetUnitName()

        	local pairsTest = 0
        	for i, towerPair in pairs(self.RoundTowers[playerID]) do
        		local towerNameTest = towerPair:GetUnitName()       		
        		if towerName == towerNameTest then
        			pairsTest=pairsTest+1
        		end
        	end

        	if pairsTest>1 and not tower:FindAbilityByName("gem_oneShotUpgrade") then
				tower:AddAbility("gem_oneShotUpgrade"):SetLevel(1)
			end
			if pairsTest>3 and not tower:FindAbilityByName("gem_oneShotUpgrade_2") then
				tower:AddAbility("gem_oneShotUpgrade_2"):SetLevel(1)
			end        		

			print("Tower name when checking for merge:", towerName)
        	local mergesInto =  towersKV[tostring(towerName)]["MergesInto"]


        	for k, v in pairs(mergesInto) do
        		local mergeTest =	{false,false,false}
        		local secondMerge = false
            	print("Key:", k, "value: ", v)

            	local checkTower = towersKV[tostring(v)]["Requirements"]


            	for i, j in pairs(self.RoundTowers[playerID]) do

                	local fullTower = j:GetUnitName()
                	
                    	if fullTower==checkTower["1"]  then

	                    	mergeTest[1]=true
	                    	print("True for:", fullTower)

                    	elseif fullTower==checkTower["2"] then

	                    	mergeTest[2]=true
	                    	print("True for:", fullTower)

                    	elseif fullTower==checkTower["3"] then

	                    	mergeTest[3]=true
	                    	print("True for:", fullTower)

                		else

                    	print("Is not a part of this merging")

                		end
            	end
				print("Requirement 1 ", mergeTest[1])
		    	print("Requirement 2 ", mergeTest[2])
		    	print("Requirement 3 ", mergeTest[3])
		    	if mergeTest[1] and mergeTest[2] and mergeTest[3] then

                	
                	if secondMerge then
                		tower.MergesInto2 = tostring(v)
                		secondMerge = false
                	else
                		tower.MergesInto = tostring(v)
                		secondMerge = true
                	end
					table.insert(self.TowerMergeable[playerID], tower)

		    	end
        	end
		end

	end

	
	function AddTowerMergeAbility(playerID)

		for key, value in pairs(self.TowerMergeable[playerID]) do

			print("Merge value in Builder:AddMergeAbility:", value.MergesInto)

			local mergeName = value.MergesInto
			local mergeName2 = value.MergesInto2

			if value then

				print("Merge Tower name:", mergeName)
				if value:FindAbilityByName("gem_merge_tower") then
					value:RemoveAbility("gem_merge_tower")
					value:AddAbility("gem_merge_tower_left"):SetLevel(1)
					value:AddAbility("gem_merge_tower_right"):SetLevel(1)
					local ModMaster = CreateItem("item_modifier_master", nil, nil) 
					ModMaster:ApplyDataDrivenModifier(value, value, "modifier_merge_"..mergeName2,nil)
				else
					value:AddAbility("gem_merge_tower"):SetLevel(1)
					local ModMaster2 = CreateItem("item_modifier_master", nil, nil) 
					ModMaster2:ApplyDataDrivenModifier(value, value, "modifier_merge_"..mergeName,nil)
				end
			else

				print("No towers to add!")
			end
		end
	end

	ListenToGameEvent('round_end', Dynamic_Wrap(Builder, 'OnRoundEnded'), self)


	self.PlayerCount = 0
	self.RoundTowers =
	 {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	 } 

	self.PickCount = 0
	self.GlobalTowers = {}
	self.GlobalMergeable = {}
	self.GlobalCount = 0
	self.TowerTestName = nil
	self.DummyTowers = {} 
	self.TowerMergeable = 
	{
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}
	self.StartingTrees = 
	{
		[1] = {
			[1] = { x = 1, y = 19 },
			[2] = { x = 2, y = 19 },
			[3] = { x = 3, y = 19 },
			[4] = { x = 4, y = 19 },
			[5] = { x = 37, y = 19 },
			[6] = { x = 36, y = 19 },
			[7] = { x = 35, y = 19 },
			[8] = { x = 34, y = 19 },
			[9] = { x = 19, y = 1 },
			[10] = { x = 19, y = 2 },
			[11] = { x = 19, y = 3 },
			[12] = { x = 19, y = 4 },
			[13] = { x = 19, y = 37 },
			[14] = { x = 19, y = 36 },
			[15] = { x = 19, y = 35 },
			[16] = { x = 19, y = 34 },
			[17] = { x = 6, y = 19 },
			[18] = { x = 7, y = 19 },
			[19] = { x = 8, y = 19 },
			[20] = { x = 9, y = 19 },
			[21] = { x = 32, y = 19 },
			[22] = { x = 31, y = 19 },
			[23] = { x = 30, y = 19 },
			[24] = { x = 29, y = 19 },
			[25] = { x = 19, y = 6 },
			[26] = { x = 19, y = 7 },
			[27] = { x = 19, y = 8 },
			[28] = { x = 19, y = 9 },
			[29] = { x = 19, y = 32 },
			[30] = { x = 19, y = 31 },
			[31] = { x = 19, y = 30 },
			[32] = { x = 19, y = 29 }
				},
		[2] = {
			[1] = { x = 1, y = 19 },
			[2] = { x = 2, y = 19 },
			[3] = { x = 3, y = 19 },
			[4] = { x = 4, y = 19 },
			[5] = { x = 37, y = 19 },
			[6] = { x = 36, y = 19 },
			[7] = { x = 35, y = 19 },
			[8] = { x = 34, y = 19 },
			[9] = { x = 19, y = 1 },
			[10] = { x = 19, y = 2 },
			[11] = { x = 19, y = 3 },
			[12] = { x = 19, y = 4 },
			[13] = { x = 19, y = 37 },
			[14] = { x = 19, y = 36 },
			[15] = { x = 19, y = 35 },
			[16] = { x = 19, y = 34 }
				},
		[3] = {
			[1] = { x = 1, y = 19 },
			[2] = { x = 2, y = 19 },
			[3] = { x = 37, y = 19 },
			[4] = { x = 36, y = 19 },
			[5] = { x = 19, y = 1 },
			[6] = { x = 19, y = 2 },
			[7] = { x = 19, y = 37 },
			[8] = { x = 19, y = 36 },
				},
		[4] = {}
	}

	self.State = "BUILD"
end

function Builder:SetPlayerCount(count)

	self.PlayerCount = count

end

function Builder:IncrementPlayerCount()

	self.PlayerCount = self.PlayerCount + 1

end

function Builder:InitBuild()

	Builder:ClearWaveAbilities()
	Builder:AddHeroAbilitiesOnRound()
	GameRules:SetTimeOfDay(0.3)
end

function Builder:CreateTower(playerID, owner, position, caster)

	CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )

	local generatedName = tostring(Random:GenerateWardName())	
	local generatedLevel = tostring(Random:GenerateWardLevel())
	local mergedName = tostring(generatedName..generatedLevel)
	if self.TowerTestName ~=nil then
		mergedName = self.TowerTestName
		self.TowerTestName = nil
	end

    local tower = CreateUnitByName(mergedName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
	local eHandle = tower:GetEntityHandle()
	print(playerID)
	local ModMaster = CreateItem("item_modifier_master", nil, nil) 
	ModMaster:ApplyDataDrivenModifier(tower, tower, "modifier_tower_pick_player_"..tostring(playerID),nil)
	tower:SetOwner(owner)
    tower:SetControllableByPlayer(playerID, true)
	
	tower.Level = generatedLevel
	tower.Name = mergedName
	
	self.RoundTowers[playerID][eHandle] = tower
	
	if HasBuilderPlaced(playerID) then

		RemoveHeroAbilities(caster)
		AddTowerConfirmAbility(playerID)
		AddTowerDowngradeAbility(playerID)

		CheckIfMergeable(playerID)
		AddTowerMergeAbility(playerID)

	end
	
end

function Builder:RemoveTower(caster, target, position)
	
	if target:GetUnitName() == "gem_dummy" then
	
		target:Destroy()
		
		Grid:FreeNavigationSquare(position, "odd")
		Grid:FindPath()
		
	else

	end

end

function Builder:ConfirmTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local entityName = caster:GetUnitName()

	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[self.GlobalCount] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(position)

			--tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			--Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	CheckIfAllPicked()

end

function Builder:OneShotUpgradeTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = towerCurrentLevel+1
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)

	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			self.GlobalTowers[self.GlobalCount] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(position)

			--tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			--Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	CheckIfAllPicked()
end

function Builder:OneShotUpgradeTower_2(caster, owner, playerID)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = towerCurrentLevel+2
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)
	print(entityNewName)
	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			self.GlobalTowers[self.GlobalCount] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(position)

			--tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			--Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	CheckIfAllPicked()
end


function Builder:DowngradeTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = Random:Downgrade(tonumber(towerCurrentLevel))
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)
	print(entityNewName)
	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then


			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle=tower:GetEntityHandle() 			
			value:Destroy()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[self.GlobalCount] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)

			value:Destroy()

			--tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(position)

			--Builder:CallibrateTreePosition(position)

		end

	end
	
	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end
	
	CheckIfAllPicked()

end

function Builder:CallibrateTreePosition(Vector)

	Vector.z = Vector.z - 90

	return Vector

end

function Builder:CheckTowerCount(caster, playerID)

	print("Table count: ", Builder:TableLength(self.RoundTowers[playerID]))

    if Builder:TableLength(self.RoundTowers[playerID]) == 5 then

		caster:AddSpeechBubble(1, "Select a Gem!", 1,0, -15)
		
		Builder:RemoveBuildAbility(caster)
		Builder:AbilityAddPick(playerID, table1)
		Builder:AddDowngradeAbility(playerID, table1)

		Builder:CheckIfMergeable(playerID)
		Builder:AddMergeAbility(playerID)

		
		
	end

end

function Builder:CreateMergeableTower(playerID, caster, owner)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityIndex = caster:GetEntityIndex()

	for key, value in pairs(self.TowerMergeable[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(value.MergesInto, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[self.GlobalCount] = tower

			value:Destroy()

		else

			local position = value:GetAbsOrigin()


			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			value:Destroy()

			--tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(position)

			Builder:CallibrateTreePosition(position)

		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		if not value:IsNull() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(position)

			--tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			--Builder:CallibrateTreePosition(position)
		end

	end
	
	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil
	end

	print(Rounds.State)
	
	CheckIfAllPicked()

end

function Builder:CreateMergeableTower_2(playerID, caster, owner)

	self.PickCount = self.PickCount + 1
	self.GlobalCount = self.GlobalCount + 1
	local entityIndex = caster:GetEntityIndex()

	for key, value in pairs(self.TowerMergeable[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(value.MergesInto2, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[self.GlobalCount] = tower

			value:Destroy()

		else

			local position = value:GetAbsOrigin()


			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			value:Destroy()

			--tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(position)

		--	Builder:CallibrateTreePosition(position)

		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		if not value:IsNull() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(position)

			--tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			--Builder:CallibrateTreePosition(position)
		end

	end
	
	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil
	end

	CheckIfAllPicked()

end


function Builder:AddHeroAbilitiesOnRound()
	
	for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do

		local Player = PlayerResource:GetPlayer(i)
		local Hero = Player:GetAssignedHero()
	
		Hero:FindAbilityByName("gem_build_tower"):SetLevel(1)
		Hero:FindAbilityByName("gem_remove_tower"):SetLevel(1)

	end

end

function Builder:AddAbilitiesOnStart(hero)

    hero:AddAbility("gem_build_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_build_tower"):SetAbilityIndex(0)
	hero:AddAbility("gem_remove_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_remove_tower"):SetAbilityIndex(1)

end

function Builder:RemoveBuildAbility(caster)

	caster:FindAbilityByName("gem_build_tower"):SetLevel(0)
	caster:FindAbilityByName("gem_remove_tower"):SetLevel(0)
	
end


function Builder:TableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end


function Builder:WaveCheckIfMergeable()


	for key, tower in pairs(self.GlobalTowers) do
		

    	local towerName = tower:GetUnitName()
		print("Tower name when checking for merge:", towerName)
    	local mergesInto =  towersKV[tostring(towerName)]["MergesInto"]


    	for k, v in pairs(mergesInto) do
    	local mergeTest =	{false,false,false}
 		local secondMerge = false
        	print("Key:", k, "value: ", v)

        	local checkTower = towersKV[tostring(v)]["Requirements"]


        	for i, j in pairs(self.GlobalTowers) do

            	local fullTower = j:GetUnitName()
            	
                	if fullTower==checkTower["1"]  then

                    	mergeTest[1]=true
                    	print("True for:", fullTower)

                	elseif fullTower==checkTower["2"] then

                    	mergeTest[2]=true
                    	print("True for:", fullTower)

                	elseif fullTower==checkTower["3"] then

                    	mergeTest[3]=true
                    	print("True for:", fullTower)

            		else

                	print("Is not a part of this merging")

            		end
        	end
			print("Requirement 1 ", mergeTest[1])
	    	print("Requirement 2 ", mergeTest[2])
	    	print("Requirement 3 ", mergeTest[3])
	    	if mergeTest[1] and mergeTest[2] and mergeTest[3] then

				if secondMerge then
					tower.MergesInto2 = tostring(v)
					secondMerge = false
				else
					tower.MergesInto = tostring(v)
					secondMerge = true
				end
				table.insert(self.GlobalMergeable, tower)

	    	end
    	end
	end

end


function Builder:WaveAddTowerMergeAbility()

	for key, value in pairs(self.GlobalMergeable) do

		print("Merge value in Builder:WaveAddTowerMergeAbility:", value.MergesInto)

		local mergeName = value.MergesInto
		local mergeName2 = value.MergesInto2
		if value then

			print("Merge Tower name:", mergeName)
			if value:FindAbilityByName("gem_merge_tower") then
				value:RemoveAbility("gem_merge_tower")
				value:AddAbility("gem_merge_tower_left"):SetLevel(1)
				value:AddAbility("gem_merge_tower_right"):SetLevel(1)
				local ModMaster = CreateItem("item_modifier_master", nil, nil) 
				ModMaster:ApplyDataDrivenModifier(value, value, "modifier_merge_"..mergeName2,nil)
			else
				value:AddAbility("gem_merge_tower"):SetLevel(1)
				local ModMaster2 = CreateItem("item_modifier_master", nil, nil) 
				ModMaster2:ApplyDataDrivenModifier(value, value, "modifier_merge_"..mergeName,nil)
			end
		else

			print("No towers to add!")
		end
	end
end

function Builder:WaveCreateMergedTower(playerID, caster, owner)

	local entityIndex = caster:GetEntityIndex()

	local fullTower = caster:GetUnitName()
	local mergeTest = {false,false,false}
	local checkTower = towersKV[caster.MergesInto]["Requirements"]
	local towersDestroy = 
	{
		[1] = {},
		[2] = {},
		[3] = {}
	}
	local towerPicked = caster
	for m1, n1 in pairs(self.GlobalTowers) do
		print("GlobalTowers before ",m1," ",n1:GetUnitName())
	end


	for key, value in pairs(self.GlobalMergeable) do

		if entityIndex == value:GetEntityIndex() then
			towerPicked = value
			local position = value:GetAbsOrigin()
			local mergedtower = CreateUnitByName(value.MergesInto, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandlemerge = mergedtower:GetEntityHandle()

			mergedtower:SetControllableByPlayer(playerID, true)
			mergedtower:SetOwner(owner)
			mergedtower:SetHullRadius(TOWER_HULL_RADIUS)
			
			for i, j in pairs(self.GlobalTowers) do
				if j:GetEntityIndex()==entityIndex then
					self.GlobalTowers[i] = nil
					self.GlobalCount=self.GlobalCount+1
					self.GlobalTowers[self.GlobalCount]=mergedtower
				end
			end

			--value:Destroy()
			--self.GlobalCount = self.GlobalCount-1
			self.GlobalMergeable[key]=nil
		end
	end

	if fullTower==checkTower["1"]  then
			mergeTest[1]=true
			towersDestroy[1]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto)
		elseif fullTower==checkTower["2"] then
			mergeTest[2]=true
			towersDestroy[2]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto)
		elseif fullTower==checkTower["3"] then
			mergeTest[3]=true
			towersDestroy[3]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto)
		else
			print("Is not a part of this merging")
	end

	for key, value in pairs(self.GlobalTowers) do
		print("GlobalTowers between ",key," ",value:GetUnitName())
	end
	local globalTest = {}
	local newIt = 1

	for key, value in pairs(self.GlobalTowers) do

		local towerName = value:GetUnitName()
		local mergeSkip = true

		print("the towerName is ", towerName)
		if mergeTest[1] and mergeTest[2] and mergeTest[3] then
				print("Done merging")
		else
			if towerName==checkTower["1"] and not mergeTest[1] then
				mergeTest[1]=true
				towersDestroy[1]=value
				print(towerName," merges into ",caster.MergesInto)
				mergeSkip = false
			end

			if towerName==checkTower["2"] and not mergeTest[2] then
				mergeTest[2]=true
				towersDestroy[2]=value
				print(towerName," merges into ",caster.MergesInto)
				mergeSkip = false
			end
			if towerName==checkTower["3"] and not mergeTest[3] then
				mergeTest[3]=true
				towersDestroy[3]=value
				print(towerName," merges into ",caster.MergesInto)
				mergeSkip=false
			end
		end


		if mergeSkip then
			globalTest[newIt]=value
			newIt=newIt+1
		end
		for n2, m2 in pairs(globalTest) do
			print("globalTest during ",n2," ",m2:GetUnitName())
		end
		print("Loop")
	end

	for key, value in pairs(towersDestroy) do
		if entityIndex == value:GetEntityIndex() then 
			value:Destroy()
			self.GlobalCount = self.GlobalCount-1
		else
			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()
			self.DummyTowers[eHandle] = tower
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(position)
			value:Destroy()
			self.GlobalCount = self.GlobalCount-1
		end
	end

	self.GlobalTowers = globalTest
	for key, value in pairs(self.GlobalMergeable) do
		self.GlobalMergeable[key] = nil
	end
	for key, value in pairs(self.GlobalTowers) do
		print("GlobalTowers after",key," ",value:GetUnitName())
	end
	--CheckIfAllPicked()
	Builder:ClearWaveAbilities()
	Builder:WaveCheckIfMergeable()
	Builder:WaveAddTowerMergeAbility()
end

function Builder:WaveCreateMergedTower_2(playerID, caster, owner)

	local entityIndex = caster:GetEntityIndex()

	local fullTower = caster:GetUnitName()
	local mergeTest = {false,false,false}
	local checkTower = towersKV[caster.MergesInto2]["Requirements"]
	local towersDestroy = 
	{
		[1] = {},
		[2] = {},
		[3] = {}
	}
	local towerPicked = caster
	for m1, n1 in pairs(self.GlobalTowers) do
		print("GlobalTowers before ",m1," ",n1:GetUnitName())
	end


	for key, value in pairs(self.GlobalMergeable) do

		if entityIndex == value:GetEntityIndex() then
			towerPicked = value
			local position = value:GetAbsOrigin()
			local mergedtower = CreateUnitByName(value.MergesInto2, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandlemerge = mergedtower:GetEntityHandle()

			mergedtower:SetControllableByPlayer(playerID, true)
			mergedtower:SetOwner(owner)
			mergedtower:SetHullRadius(TOWER_HULL_RADIUS)
			
			for i, j in pairs(self.GlobalTowers) do
				if j:GetEntityIndex()==entityIndex then
					self.GlobalTowers[i] = nil
					self.GlobalCount=self.GlobalCount+1
					self.GlobalTowers[self.GlobalCount]=mergedtower
				end
			end

			--value:Destroy()
			--self.GlobalCount = self.GlobalCount-1
			self.GlobalMergeable[key]=nil
		end
	end

	if fullTower==checkTower["1"]  then
			mergeTest[1]=true
			towersDestroy[1]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto2)
		elseif fullTower==checkTower["2"] then
			mergeTest[2]=true
			towersDestroy[2]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto2)
		elseif fullTower==checkTower["3"] then
			mergeTest[3]=true
			towersDestroy[3]= towerPicked
			print(towerPicked:GetUnitName()," chosen to change into ",caster.MergesInto2)
		else
			print("Is not a part of this merging")
	end

	for key, value in pairs(self.GlobalTowers) do
		print("GlobalTowers between ",key," ",value:GetUnitName())
	end
	local globalTest = {}
	local newIt = 1

	for key, value in pairs(self.GlobalTowers) do

		local towerName = value:GetUnitName()
		local mergeSkip = true

		print("the towerName is ", towerName)
		if mergeTest[1] and mergeTest[2] and mergeTest[3] then
				print("Done merging")
		else
			if towerName==checkTower["1"] and not mergeTest[1] then
				mergeTest[1]=true
				towersDestroy[1]=value
				print(towerName," merges into ",caster.MergesInto2)
				mergeSkip = false
			end

			if towerName==checkTower["2"] and not mergeTest[2] then
				mergeTest[2]=true
				towersDestroy[2]=value
				print(towerName," merges into ",caster.MergesInto2)
				mergeSkip = false
			end
			if towerName==checkTower["3"] and not mergeTest[3] then
				mergeTest[3]=true
				towersDestroy[3]=value
				print(towerName," merges into ",caster.MergesInto2)
				mergeSkip=false
			end
		end


		if mergeSkip then
			globalTest[newIt]=value
			newIt=newIt+1
		end
		for n2, m2 in pairs(globalTest) do
			print("globalTest during ",n2," ",m2:GetUnitName())
		end
		print("Loop")
	end

	for key, value in pairs(towersDestroy) do
		if entityIndex == value:GetEntityIndex() then 
			value:Destroy()
			self.GlobalCount = self.GlobalCount-1
		else
			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()
			self.DummyTowers[eHandle] = tower
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(position)
			value:Destroy()
			self.GlobalCount = self.GlobalCount-1
		end
	end

	self.GlobalTowers = globalTest
	for key, value in pairs(self.GlobalMergeable) do
		self.GlobalMergeable[key] = nil
	end
	for key, value in pairs(self.GlobalTowers) do
		print("GlobalTowers after",key," ",value:GetUnitName())
	end
	--CheckIfAllPicked()
	Builder:ClearWaveAbilities()
	Builder:WaveCheckIfMergeable()
	Builder:WaveAddTowerMergeAbility()
end

function Builder:ClearWaveAbilities()
	if ModMaster then
		ModMaster:Destroy()
	elseif ModMaster2 then
		ModMaster2:Destroy()
	end

	for key, value in pairs(self.GlobalTowers) do
		if value:FindAbilityByName("gem_merge_tower") then
			value:RemoveAbility("gem_merge_tower")
		end
		if value:FindAbilityByName("gem_merge_tower_2") then
			value:RemoveAbility("gem_merge_tower_2")
		end
		for i=0,value:GetModifierCount() do
			if value:GetModifierNameByIndex(i) then
				local modTest = value:GetModifierNameByIndex(i)
				if string.sub(modTest, 1,14)=="modifier_merge" then
					value:RemoveModifierByName(modTest)
				end
			end
		end
	end

	for key, value in pairs(self.GlobalMergeable) do
		self.GlobalMergeable[key] = nil
	end

end


function Builder:OnRoundEnded(keys)

	
	self.State = keys.state
	Builder:InitBuild()


end