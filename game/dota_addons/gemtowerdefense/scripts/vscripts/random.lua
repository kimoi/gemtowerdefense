
if Random == nil then
	Random = class({})
	
end

--local unitName 			= wavesKV[tostring(self.RoundNumber)]["Creep"]

function Random:Init()

	self.XPLevel 		= 1


end

function Random:SetXPLevel(level)

	self.XPLevel = level

end

function Random:GetXPLevel()

	return self.XPLevel

end

--ToRemake
--[[
  "DowngradeChances"
    {
        "2"
        {
            "1" "100"

        }
        "3"
        {
            "1" "40"
            "2" "100"

        }
        "4"
        {
            "1" "20"
            "2" "50"
            "3" "100"

        }
        "5"
        {
            "1" "15"
            "2" "30"
            "3" "50"
            "4" "100"
        }	
]]--
function Random:SpawnElite()

	local value = RandomInt(1,50)

		if value == 1 then

			return true

		else

			return false

		end

end

function Random:Downgrade(level)

	local downgradeTable = randomKV.DowngradeChances
	local value = RandomInt(1,100)

	print("Random Downgrade Called!")

	if level == 2 then

		print("Im here!")

		local nLevel = 1
		return nLevel

	elseif level == 3 then

		if value <= downgradeTable[level]["1"] then

			local nLevel = 2
			return nLevel

		else

			local nLevel = 1
			return nLevel

		end

	elseif level == 4 then

		if value <= downgradeTable.level["1"] then

			local nLevel = 1
			return nLevel

		elseif value > downgradeTable.level["1"] and value <= downgradeTable.level["2"] then

			local nLevel = 2
			return nLevel

		else

			nLevel = 3
			return nLevel

		end

	elseif level == 5 then

		if value <= downgradeTable.level["1"] then

			newLevel = 1
		
		elseif value > downgradeTable.level["1"] and value <= downgradeTable.level["2"] then

			newLevel = 2


		elseif value > downgradeTable.level["2"] and randomValue <= downgradeTable.level["3"] then

			newLevel = 3

		else

			newLevel = 4

		end

	end
end

function Random:GenerateWardLevel()

	local levelTable = randomKV.Chances

	if self.XPLevel == 1 then

		local level = 1
		return level

	elseif self.XPLevel == 2 then

		local value = RandomInt(1,100)

		if value <= levelTable[tostring(self.XPLevel)]["1"] then

			local level = 1
			return level

		else
			
			local level = 2
			return level
		
		end
	
	elseif self.XPLevel == 3 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.XPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["2"] and value <= levelTable[tostring(self.XPLevel)]["3"] then

			local level = 2
			return level

		else

			local level = 3
			return level

		end

	

	elseif self.XPLevel == 4 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.XPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["2"] and value <= levelTable[tostring(self.XPLevel)]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["3"] and value <= levelTable[tostring(self.XPLevel)]["4"] then

			local level = 3
			return level

		else

			local level = 4
			return level

		end



	elseif self.XPLevel == 5 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.XPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["2"] and value <= levelTable[tostring(self.XPLevel)]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["3"] and value <= levelTable[tostring(self.XPLevel)]["4"] then

			local level = 3
			return level

		elseif value >= levelTable[tostring(self.XPLevel)]["4"] and value <= levelTable[tostring(self.XPLevel)]["5"] then

			local level = 4
			return level

		else

			local level = 5
			return level

		end

	end
end


function Random:GenerateWardName()

	local nameTable = randomKV.Base
	local name = nameTable[tostring(RandomInt(1, 8))]
	--local name = nameTable[tostring(RandomInt(3, 5))]
	return name

end


