
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local player = keys.player
	local level = keys.level
	
	local hero = player:GetAssignedHero()
	hero:SetAbilityPoints(iPoints)
	
	Random:SetXPLevel(level)

end

function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()

	Players:SetPicked(playerID, true)
	Players:SetHero(playerID, hero)
	Players:CheckIfAllPicked()
	
	Players:RemoveTalents(hero)
	Players:AddLockedAbilitiesOnStart(hero)
	
	hero:SetAbilityPoints(0)

	if Players:CheckIfAllPicked() then

		Players:UnlockAbilities()


	end


end

function GemTowerDefenseReborn:OnConnectFull(keys)

	local entIndex = keys.index+1
  	local player = EntIndexToHScript(entIndex)

	print("Entity index in event is:", entIndex)

	Builder:SetPlayerCount(entIndex)
  
  	local playerID = player:GetPlayerID()


	Players:SetAmount(entIndex)
	Players:SetPicked(playerID, false)
	
	Rounds:SetPlayer(playerID)


end

function GemTowerDefenseReborn:OnEntityKilled(keys)

	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	local PlayerID = Player:GetPlayerID()

	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	Hero:AddExperience(unit.XPBounty, 0, false, false)
	PlayerResource:ModifyGold(0, unit.GoldBounty, false, 0)

	Rounds:DeleteUnit(eHandle)
	Rounds:IncrementKillNumber()

	Rounds:ResetAmountOfKilled()
	Rounds:IncrementRound()
	--CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )
	Rounds:Build()

end

function GemTowerDefenseReborn:OnStateChange(keys)

	DeepPrintTable(keys)


end
