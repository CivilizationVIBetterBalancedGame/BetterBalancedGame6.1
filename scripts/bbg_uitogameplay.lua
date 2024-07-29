------------------------------------------------------------------------------
--	FILE:	 bbg_uitogameplay.lua
--	AUTHOR:  FlashyFeeds
--	PURPOSE: UI to Gameplay script. Raises synchronized GameEvents from Events
------------------------------------------------------------------------------
local tBufferedParams = {}
tBufferedParams["CSBufferedParams"] = {}
UIEvents = ExposedMembers.LuaEvents
print("BBG UI to Gameplay Script started")
--- Inca Scrits
-- Constants: populating the table of features from which we remove inca bug yields
tRemoveIncaYieldsFromFeatures = {}
--5.2. Disable: local qQuery = "SELECT WonderType FROM WonderTerrainFeature_BBG WHERE TerrainClassType<>'TERRAIN_CLASS_MOUNTAIN' OR TerrainClassType IS NULL"
--5.2. Disable: tRemoveIncaYieldsFromFeatures=DB.Query(qQuery)
--for i, row in ipairs(tRemoveIncaYieldsFromFeatures) do
	--print(i, row.WonderType)
--end
--Exp bug
function OnPromotionFixExp(iUnitPlayerID: number, iUnitID : number)
	local kParameters = {}
	kParameters.OnStart = "GameplayPromotionFixExp"
	kParameters["iUnitPlayerID"] = iUnitPlayerID
	kParameters["iUnitID"] = iUnitID
	UI.RequestPlayerOperation(iUnitPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIPromotionFixExp(iUnitPlayerID, iUnitID)
end

function OnUnitAddedToMap(iPlayerID, iUnitID)
	--print("OnUnitAddedToMap called", iPlayerID, iUnitID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return print("nil player")
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return print("nil unit")
	end
	--print(pUnit)
	--print("Get Moves Remaining",  pUnit:GetMovesRemaining())
	--print("GetMovementMovesRemaining", pUnit:GetMovementMovesRemaining())
	--print("GetMaxMoves", pUnit:GetMaxMoves())
	--print("IsReadyToMove", pUnit:IsReadyToMove())
	--if pUnit:GetMovesRemaining()>0 then
		--print("has moves => restore if incomplete")
		local kParameters = {}
		kParameters.OnStart = "GameplayMovementBugFix"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iUnitID"] = iUnitID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--end
end

function OnUnitUpgraded(iPlayerID, iUnitID)
	--print("OnUnitUpgraded called", iPlayerID, iUnitID)
	local kParameters = {}
	kParameters.OnStart = "GameplayMovementBugFixUpgrade"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	--print(pUnit:GetMaxMoves())
	kParameters["nBaseMoves"] = pUnit:GetMaxMoves() 
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end
--Inca bug
function OnIncaPlotYieldChanged(iX, iY)
	--print("OnIncaPlotYieldChanged started for", iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		--print("No Owner -> Exit")
		return
	end
	local sCivilizationType = PlayerConfigurations[iOwnerId]:GetCivilizationTypeName()
	--do nothing if not inca
	if sCivilizationType ~= "CIVILIZATION_INCA" then
		--print("Not Owned by Inca -> Exit")
		return
	end
	--do nothing if not impassible
	if not pPlot:IsImpassable() then
		return
	end

	local iFeatureId = pPlot:GetFeatureType()
	if iFeatureId ~= -1 then
		--print(GameInfo.Features[iFeatureId].FeatureType)
		if IDToPos(tRemoveIncaYieldsFromFeatures, GameInfo.Features[iFeatureId].FeatureType, "WonderType")==false then
			--print("No Match -> Exit")
			return
		end
		--print(GameInfo.Features[iFeatureId].FeatureType.." feature detected at: ", iX, iY)
		local kParameters = {}
		kParameters.OnStart = "GameplayFixIncaBug"
		kParameters["iOwnerId"] = iOwnerId
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		kParameters.Yields = {}
		for i =0,5 do
			local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
			if nControlProp == nil then
				kParameters.Yields[i] = pPlot:GetYield(i)
			else
				kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
			end
			--kParameters.Yields[i] = pPlot:GetYield(i)
		end
		UI.RequestPlayerOperation(iOwnerId, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetPlotProperty(iOwnerId, kParameters)	
	end
end
--BCY no rng remove disaster yields
function OnBCYPlotYieldChanged(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iOwnerId = pPlot:GetOwner()
	--do nothing if unowned
	if iOwnerId == -1 or iOwnerId == nil then
		return
	end
	local pCity = CityManager.GetCityAt(iX, iY)
	if pCity == nil then
		return
	end
	if CityManager.GetCity(iOwnerId, pCity:GetID()) == nil then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayBCYAdjustCityYield"
	kParameters["iOwnerId"] = iOwnerId
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iOwnerId, PlayerOperations.EXECUTE_SCRIPT, kParameters);	
	--kParameters.Yields = {}
	--for i =0,5 do
		--local nControlProp = pPlot:GetProperty(ExtraYieldPropertyDictionary(i))
		--if nControlProp == nil then
			--kParameters.Yields[i] = pPlot:GetYield(i) -- food
		--else
			--kParameters.Yields[i] = nControlProp + pPlot:GetYield(i)
		--end
	--end
	--UIEvents.UIBCYAdjustCityYield(iOwnerId, kParameters)
end
--Communism
function OnCityWorkerChanged(iPlayerID, iCityID, iX, iY)
	local pPlayer = Players[iPlayerID]
	--print("OnCityWorkerChanged: Citizen Changed")
	--print("parameters", iPlayerID, iCityID, iX, iY)
	local pPlayerCulture = pPlayer:GetCulture()
	local iGovID = pPlayerCulture:GetCurrentGovernment()
	if iGovID == 8 or pPlayerCulture:IsPolicyActive(105) then
		local kParameters = {}
		kParameters.OnStart = "GameplayBBGWorkersChanged"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iCityID"] = iCityID
		kParameters["iX"] = iX
		kParameters["iY"] = iY
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);	
		--UIEvents.UIBBGWorkersChanged(iPlayerID, iCityID, iX, iY)
	end
end

function OnGovernmentChanged(iPlayerID, iGovID)
	local kParameters = {}
	kParameters.OnStart = "GameplayBBGGovChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iGovID"] = iGovID 
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

--Amani
function OnGovernorAssigned(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	--print("OnGovernorAssigned")
	--print(iCityOwnerID, iCityID, iGovernorOwnerID, iGovernorType)
	if iGovernorType ~= 1 then -- not amani
		return
	end
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iCityOwnerID, iCityID)
	if pTargetCity == nil then
		return
	end
	--above all mandatory checks that amani is assigned
	--set player property
	local tAmani = {}
	tAmani["iCityID"] = iCityID
	tAmani["iMinorID"] = iCityOwnerID
	tAmani["Status"] = 0 
	--0: establishing, 1: established, -1 not assigned
	local kParameters = {}
	kParameters.OnStart = "GameplaySetAmaniProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	kParameters["tAmani"] = tAmani
	UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UISetAmaniProperty(iGovernorOwnerID, tAmani)
end

function OnTradeRouteActivityChanged(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	print("OnTradeRouteActivityChanged", iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	print(iPlayerID, iOriginPlayerID, iOriginCityID, iTargetPlayerID, iTargetCityID)
	local pOriginPlayer = Players[iOriginPlayerID]
	if pOriginPlayer == nil then
		return
	end
	local pTargetPlayer = Players[iTargetPlayerID]
	if pTargetPlayer == nil then
		return
	end
	local pOriginCity = CityManager.GetCity(iOriginPlayerID, iOriginCityID)
	if pOriginCity == nil then
		return
	end
	local pTargetCity = CityManager.GetCity(iTargetPlayerID, iTargetCityID)
	if pTargetCity == nil then
		return
	end
	--above mandatory checks
	if pTargetPlayer:IsMajor() then -- script only works for CS
		return
	end
	--recalculate trade plot properties
	
	print("Recalculating plot properties")
	--local tAmani = pOriginPlayer:GetProperty("AMANI")
	--local tOCityTraders = pOriginCity:GetProperty("CS_TRADERS")
	--local iMyTargetPlayerID = -1
	--for i, iCSCityOwnerID in ipairs(tOCityTraders) do
		--if tAmani["iMinorID"] == iCSCityOwnerID then
			--iMyTargetPlayerID = tAmani["iMinorID"]
		--end
	--end
	local pCityOutTrade = pOriginCity:GetTrade():GetOutgoingRoutes()
	local bControl = false
	--print("Checking for Amani Trader property iMyTargetPlayerID", iMyTargetPlayerID)
	--if iMyTargetPlayerID ~= -1 then
		print("Amani Trader Property Found => Is Trader to Amani Active Checks")
		if pCityOutTrade ~= nil then
			for _, route in ipairs(pCityOutTrade) do
				if route.DestinationCityPlayer == iTargetPlayerID then
					bControl = true
				end
				print("City Owner", iTargetPlayerID, "bControl", bControl)
			end
		end
	--end
	print("bControl Final", bControl)
	local kParameters = {}
	kParameters.OnStart = "GameplaySetCSTrader"
	kParameters["iOriginPlayerID"] = iOriginPlayerID
	kParameters["iOriginCityID"] = iOriginCityID
	if bControl == true then
		print("Sending Add trader req")
		kParameters["iTargetPlayerID"] = iTargetPlayerID
		UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, iTargetPlayerID)
	else
		kParameters["iTargetPlayerID"] = 0 - iTargetPlayerID
		print("Sending Remove trader req")
		if not pOriginPlayer:CanUnreadyTurn() then

			--UI.IsTurnTimerElapsed(Game.GetLocalPlayer()) then
			print("Player Turn Ended => Adding to buffer")
			table.insert(tBufferedParams["CSBufferedParams"], kParameters)
		else
			print("PlayerTurnActive")
			tBufferedParams["CSBufferedParams"] = {}	
			UI.RequestPlayerOperation(iOriginPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UISetCSTrader(iOriginPlayerID, iOriginCityID, 0-iTargetPlayerID)
		end
	end
end

function OnLocalPlayerTurnBegin()
	print("Resolving Buffered Parameters")
	if tBufferedParams["CSBufferedParams"] == nil or tBufferedParams["CSBufferedParams"] == {} or #tBufferedParams["CSBufferedParams"] == 0 then
		print("Shoud Terminate")
		return
	end
	print("Buffered Parameters Detected")
	--local tTempCSBufferedParams = tBufferedParams["CSBufferedParams"]
	for i, kParameters in ipairs(tBufferedParams["CSBufferedParams"]) do
		print("OldIndex", i)
		for k,v in pairs(kParameters) do
			print(k,v)
		end
		UI.RequestPlayerOperation(kParameters["iOriginPlayerID"], PlayerOperations.EXECUTE_SCRIPT, kParameters)
		table.remove(tBufferedParams["CSBufferedParams"], i)
	end
end

function OnGovernorChanged(iGovernorOwnerID, iGovernorID)
	print("OnGovernorChanged")
	print(iGovernorOwnerID, iGovernorID)
	local pPlayer = Players[iGovernorOwnerID]
	if pPlayer==nil then
		return
	end
	if iGovernorID ~= 1 then --not amani
		return
	end
	local tAmani = pPlayer:GetProperty("AMANI")
	if tAmani == nil then
		return
	end
	local pPlayerGovernors = pPlayer:GetGovernors()
	local pPlayerGovernor = GetAppointedGovernor(iGovernorOwnerID, iGovernorID)
	local kParameters = {}
	kParameters.OnStart = "GameplaySetAmaniProperty"
	kParameters["iGovernorOwnerID"] = iGovernorOwnerID
	if pPlayerGovernor:IsEstablished(1) and tAmani~=nil then
		print("Amani Established")
		local pCity = CityManager.GetCity(tAmani.iMinorID, tAmani.iCityID)
		if pPlayerGovernor:GetAssignedCity() == pCity then
			print("amani established -> recalculate amani yields and plot properties")
			tAmani.Status = 1
			kParameters["tAmani"] = tAmani
			UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
		end
	elseif pPlayerGovernor:IsEstablished(1) == false and tAmani.iCityID ~= nil then
		print("amani removed -> recalculate amani yields and plot properties, player properties as well")
		tAmani.Status = -1
		kParameters["tAmani"] = tAmani
		UI.RequestPlayerOperation(iGovernorOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UISetAmaniProperty(iPlayerID, tAmani)
	end
end

function OnUnitGreatPersonCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" then
		return
	end
	--iGPClassID:
	--0 = General
	--1 = Admiral
	--2 = Engineer
	--3 = Merchant
	--4 = Prophet
	--5 = Scientist
	--6 = Writer
	--7 = Artist
	--8 = Musician
	--9 = Comandante
	if iGPClassID ~= 0 then
		return
	end
	if iGPIndividualID == 58 then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayGPGeneralUnifierCreated"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	kParameters["iGPClassID"] = iGPClassID
	kParameters["iGPIndividualID"] = iGPIndividualID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIGPGeneralUnifierCreated(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
end

function OnUnitGreatPersonActivatedQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	local kParameters = {}
	kParameters.OnStart = ""
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iUnitID"] = iUnitID
	kParameters["iGPClassID"] = iGPClassID
	kParameters["iGPIndividualID"] = iGPIndividualID
	--print("Class ID", iGPClassID, "Individual ID", iGPIndividualID)
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() == "LEADER_QIN_ALT" then
		if iGPIndividualID == 176 or iGPIndividualID == 67 or iGPIndividualID == 74 then --timur, sudirman (177 bbg changed him), monash. vijaya
			kParameters.OnStart = "GameplayUnifierSameUnitUniqueEffect"
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UIUnifierSameUnitUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		elseif iGPIndividualID == 71 then -- zhukov
			kParameters.OnStart = "GameplayUnifierSamePlayerUniqueEffect"
			UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			--UIEvents.UIUnifierSamePlayerUniqueEffect(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
		end
	end
end

function OnUnitGreatPersonActivatedNotQinUnifier(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if iGPClassID ~= 0 then
		return
	end
	--print("Track suntzu")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_QIN_ALT" and iGPIndividualID == 58 then
		local kParameters = {}
		kParameters.OnStart = "GameplayNotUnifierDeleteSunTzu"
		kParameters["iPlayerID"] = iPlayerID
		kParameters["iUnitID"] = iUnitID
		kParameters["iGPClassID"] = iGPClassID
		kParameters["iGPIndividualID"] = iGPIndividualID
		UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
		--UIEvents.UINotUnifierDeleteSunTzu(iPlayerID, iUnitID, iGPClassID, iGPIndividualID)
	end
end

function OnUnitMoved(iPlayerID, iUnitID, iX, iY, bVis, bStateChange)
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~= 'LEADER_QIN_ALT' then
		return
	end
	local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID)
	if pUnit == nil then
		return
	end
	local pGreatPerson = pUnit:GetGreatPerson()
	local iGPClassID = pGreatPerson:GetClass()
	local iGPIndividualID = pGreatPerson:GetIndividual()
	--print(pGreatPerson, iGPClassID, iGPIndividualID)
	if iGPClassID~=0 and (iGPIndividualID~=176 or iGPIndividualID~=67 or iGPIndividualID~=74) then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayUnifierTrackRelevantGenerals"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iGPIndividualID"] = iGPIndividualID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	--UIEvents.UIUnifierTrackRelevantGenerals(iPlayerID, iGPIndividualID, iX, iY)
end

--Ludwig
function OnLudwigWonderPlaced(iX, iY, iBuildingID, iPlayerID, iCityID, nPercentComplete, bPillaged)
	print("OnLudwigWonderPlaced: Started")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("OnLudwigWonderPlaced: Owner not Ludwig => Exit")
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	if GameInfo.Buildings[iBuildingID].IsWonder == false then
		return print("OnLudwigWonderPlaced: Not a Wonder")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderPlaced"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBuildingID"] = iBuildingID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	kParameters["nPercentComplete"] = nPercentComplete
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnLudwigWonderRemoved(iX, iY)
	print("OnWonderRemoved: Started")
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot == nil then
		return
	end
	local iPlayerID = pPlot:GetOwner()
	if iPlayerID == -1 then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("OnWonderRemoved: Owner not Ludwig => Exit")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderRemoved"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnLudwigWonderCompleted(iX, iY, iBuildingID, iPlayerID, iCityID, nPercentComplete, unknown)
	print("OnLudwigWonderCompleted: Started")
	local pPlayer = Players[iPlayerID]
	if pPlayer == nil then
		return
	end
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~="LEADER_LUDWIG" then
		return print("GameplayLudwigWonderCompleted: Owner not Ludwig => Exit")
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	if GameInfo.Buildings[iBuildingID].IsWonder == false then
		return print("OnLudwigWonderPlaced: Not a Wonder")
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayLudwigWonderCompleted"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBuildingID"] = iBuildingID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	kParameters["nPercentComplete"] = nPercentComplete
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end
--Spy Capture gives Capacity 5.4
function OnSpyMissionCompleted(iPlayerID, iMissionID)
	--Debug("Called  "..tostring(iPlayerID), "OnSpyMissionCompleted")
	local tMission:table = nil;
	if iPlayerID ~= Game.GetLocalPlayer() then
		return --print("Mission Completed Raised not on Owner")
	end
	local pPlayer:table = Players[iPlayerID];
	if pPlayer then
		local pPlayerDiplomacy:table = pPlayer:GetDiplomacy();
		if pPlayerDiplomacy then
			tMission = pPlayerDiplomacy:GetMission(iPlayerID, iMissionID);
			if tMission == nil then
				UI.DataError("Unable to show misison completed popup for mission ID: " .. tostring(iMissionID));
				return
			end
		end
	end
	local kParameters = {}
	--5.6: Added 2 states to allow for Wu Zeitan's Spy Interraction.
	if tMission.InitialResult == EspionageResultTypes.CAPTURED or tMission.EscapeResult == EspionageResultTypes.CAPTURED then
		kParameters.State = 0
	elseif tMission.InitialResult == EspionageResultTypes.KILLED or tMission.EscapeResult == EspionageResultTypes.KILLED then
		kParameters.State = 1
	else
		return 
	end
	kParameters.OnStart = "GameplaySpyMissionCompleted"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iMissionID"] = iMissionID
	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
end
--Religion (and Mvemba) 5.4
--religion hooks
function OnReligionFounded(iPlayerID, iReligionID)
	print("OnReligionFounded: Called")
	local kParameters = {}
	kParameters.OnStart = "GameplayReligionFounded"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iReligionID"] = iReligionID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnBeliefAdded(iPlayerID, iBeliefID)
	print("OnBeliefAdded: Called")
	local kParameters = {}
	kParameters.OnStart = "GameplayBeliefAdded"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iBeliefID"] = iBeliefID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnCapitalCityChanged(iPlayerID, iCityID)
	print("OnCapitalCityChanged: Called")
	local pPlayer = Players[iPlayerID]
	if pPlayer==nil then
		return
	end
	local pCity = CityManager.GetCity(iPlayerID, iCityID)
	if pCity == nil then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayCapitalCityChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnPlayerDefeat(iPlayerID, iDefeatID, iEventID)
	print("OnPlayerDefeat: Called for iPlayerID", iPlayerID)
	local kParameters = {}
	kParameters.OnStart = "GameplayPlayerDefeat"
	kParameters["iPlayerID"] = iPlayerID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end
--mvemba exclusive hooks
function OnMvembaCityReligionChanged(iPlayerID, iCityID, iUnknown1, iUnknown2)
	print("OnMvembaCityReligionChanged: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityReligionChanged"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	kParameters["iUnknown1"] = iUnknown1
	kParameters["iUnknown2"] = iUnknown2
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityAddedToMap(iPlayerID, iCityID, iX, iY)
	print("OnMvembaCityAddedToMap: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName()~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityAddedToMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	kParameters["iX"] = iX
	kParameters["iY"] = iY
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityRemovedFromMap(iPlayerID, iCityID)
	print("OnMvembaCityRemovedFromMap: Called")
	if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaCityRemovedFromMap"
	kParameters["iPlayerID"] = iPlayerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

function OnMvembaCityTransfered(iNewOwnerID, iCityID, iOldOwnerID, nTransferType)
	print("OnMvembaCityRemovedFromMap: Called")
	if PlayerConfigurations[iNewOwnerID]:GetLeaderTypeName() ~= "LEADER_MVEMBA" and PlayerConfigurations[iOldOwnerID]:GetLeaderTypeName() == "LEADER_MVEMBA" then
		return
	end
	local kParameters = {}
	kParameters.OnStart = "GameplayMvembaGiftCity"
	kParameters["iNewOwnerID"] = iNewOwnerID
	kParameters["iOldOwnerID"] = iOldOwnerID
	kParameters["iCityID"] = iCityID
	UI.RequestPlayerOperation(iNewOwnerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
end

--exodus
function OnDedicationChosen(iPlayerID : number, iOperationID : number)
	print("OnDedicationChosen: Called")
	if iOperationID ~= PlayerOperations.COMMEMORATE then
		return
	end
	local iLocPlayerID = Game.GetLocalPlayer()
	local iHostPlayerID = 0
	if GameConfiguration.IsAnyMultiplayer() then
		iHostPlayerID = Network.GetGameHostPlayerID()
	end
	if iPlayerID ~= iLocPlayerID and Players[iPlayerID]:IsHuman() then
		return
	end
	if Players[iPlayerID]:IsHuman() == false and iLocPlayerID ~= iHostPlayerID then
		return
	end
	local pGameEras = Game.GetEras()
	local tCommemorations =  pGameEras:GetPlayerActiveCommemorations(iPlayerID)
	if #tCommemorations == 0 or tCommemorations == {} or tCommemorations == nil then
		return
	end
	print("OnDedicationChosen: Dedications Detected")
	for i, iCommemorationID in ipairs(tCommemorations) do
		if iCommemorationID == 3 then
			if pGameEras:HasHeroicGoldenAge(iPlayerID) or pGameEras:HasGoldenAge(iPlayerID) then
				print("OnDedicationChosen: Golden Exodus Detected")
				local kParameters = {}
				kParameters.OnStart = "GameplayExodusSetProperty"
				kParameters["iPlayerID"] = iPlayerID
				UI.RequestPlayerOperation(iLocPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
			end
		end
	end
end

function OnGameEraChanged(iPrevEraID, iNewEraID)
	print("OnGameEraChanged: Called some blah blah")
	local iHostPlayerID = 0
	local iLocPlayerID = Game.GetLocalPlayer()
	if GameConfiguration.IsAnyMultiplayer() then
		iHostPlayerID = Network.GetGameHostPlayerID()
	end
	if iLocPlayerID ~= iHostPlayerID then
		return print("OnGameEraChanged: Returns")
	end
	print("Sending Raise Event")
	local kParameters = {}
	kParameters.OnStart = "GameplayRemoveExodus"
	kParameters["iPlayerID"] = iLocPlayerID
	print("kParameters calculated = > sending")
	print(kParameters["iPlayerID"], kParameters.OnStart)
	UI.RequestPlayerOperation(iLocPlayerID, PlayerOperations.EXECUTE_SCRIPT, kParameters);
	print("Removed?")
end

--Support
function GetAppointedGovernor(playerID:number, governorTypeIndex:number)
	-- Make sure we're looking for a valid governor
	if playerID < 0 or governorTypeIndex < 0 then
		return nil;
	end

	-- Get the player governor list
	local pGovernorDef = GameInfo.Governors[governorTypeIndex];
	local pPlayer:table = Players[playerID];
	local pPlayerGovernors:table = pPlayer:GetGovernors();
	local bHasGovernors, tGovernorList = pPlayerGovernors:GetGovernorList();

	-- Find and return the governor from the governor list
	if pPlayerGovernors:HasGovernor(pGovernorDef.Hash) then
		for i,governor in ipairs(tGovernorList) do
			if governor:GetType() == governorTypeIndex then
				return governor;
			end
		end
	end

	-- Return nil if this player has not appointed that governor
	return nil;
end

function IDToPos(List, SearchItem, key, multi)
	--print(SearchItem)
	multi = multi or false
	--print(multi)
	key = key or nil
	--print(key)
	local results = {}
	if List == {} then
		return false
	end
    if SearchItem==nil then
        return print("Search Error")
    end
    for i, item in ipairs(List) do
    	if key == nil then
    		--print(item)
	        if item == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	        end
	    else
	    	--print(item[key])
	    	if item[key] == SearchItem then
	        	if multi then
	        		table.insert(results, i)
	        	else
	            	return i;
	            end
	    	end
	    end
    end
    if results == {} or #results==0 or results==nil then
    	return false
    else
    	--print("IDtoPos Results:")
    	for _, item in ipairs(results) do
    		--print(item)
    	end
    	return results
    end
end

function ExtraYieldPropertyDictionary(iYieldId)
	local YieldDict = {}
	YieldDict[0] = "EXTRA_YIELD_FOOD"
	YieldDict[1] = "EXTRA_YIELD_PRODUCTION"
	YieldDict[2] = "EXTRA_YIELD_GOLD"
	YieldDict[5] = "EXTRA_YIELD_FAITH"
	YieldDict[4] = "EXTRA_YIELD_CULTURE"
	YieldDict[3] = "EXTRA_YIELD_SCIENCE"
	return YieldDict[iYieldId]
end

function BuildRecursiveDataString(data: table)
	local str: string = ""
	for k,v in pairs(data) do
		if type(v)=="table" then
			--print("BuildRecursiveDataString: Table Detected")
			local deeper_data = v
			local new_string = BuildRecursiveDataString(deeper_data)
			--print("NewString ="..new_string)
			str = "table: "..new_string.."; "
		else
			str = str..tostring(k)..": "..tostring(v).." "
		end
	end
	return str
end

--=========Events=========--

function Initialize()
	--Exp bug
	Events.UnitPromoted.Add(OnPromotionFixExp);
	--Amani
	Events.GovernorAssigned.Add(OnGovernorAssigned)
	Events.GovernorChanged.Add(OnGovernorChanged)
	Events.TradeRouteActivityChanged.Add(OnTradeRouteActivityChanged)
	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin)
	print("Delete Amani UI hooks added")
	-- No idea what this is
	Events.SpyMissionCompleted.Add(OnSpyMissionCompleted)
	print("Spy Capture Capacity UI hook added")

	--BCY no rng setting (param names are still called BBCC)
	if GameConfiguration.GetValue("BBCC_SETTING_YIELD") == 1 then
		print("BCY: No RNG detected")
		Events.PlotYieldChanged.Add(OnBCYPlotYieldChanged)
	end
end

--====Activation====--
Initialize()