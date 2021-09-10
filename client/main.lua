local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local TargetCoords            = nil
local Blips                   = {}
local Licenses                = {}
local CurrentTest             = nil
local CurrentTestType         = nil

ESX                           = nil
GUI.Time                      = 0

Citizen.CreateThread(function()
    while ESX == nil do
		    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		    Citizen.Wait(0)
	  end

	  while ESX.GetPlayerData().job == nil do
		    Citizen.Wait(10)
	  end

	  ESX.PlayerData = ESX.GetPlayerData()
end)

function OpenflyingSchoolMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'flyingschool', {
		title    = _U('flying_menu'),
		align    = 'top-left',
		elements = {
			{label = _U('give'), value = 'give'},
			{label = _U('retrieve'), value = 'remove'},
			{label = _U('billing'), value = 'bill'}
}}, function(data, menu)

if data.current.value == 'give' then
			local elements = {
                {label = _U('traffic_give'), value = 'trg'}}

      if ESX.PlayerData.job.grade_name == 'chief' then
				table.insert(elements, {label = _U('airman_give'), value = 'air1'})
			end
			
			if ESX.PlayerData.job.grade_name == 'chief' then
				table.insert(elements, {label = _U('senior_give'), value = 'air2'})
			end
			
			if ESX.PlayerData.job.grade_name == 'chief' then
				table.insert(elements, {label = _U('staff_give'), value = 'air3'})
			end

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give', {
				title    = _U('give'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'trg' then
                           TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'dmv')
                    elseif action == 'air1' then
						TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'letecky1')
					elseif action == 'air2' then
						TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'letecky2')
                    elseif action == 'air3' then
                    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'letecky3')
                         end
                     else
                         ESX.ShowNotification(_U('no_players_nearby'))
                         end
                     end, function(data2, menu2)
				menu2.close()
	             end)
elseif data.current.value == 'remove' then
      local elements = {
                  {label = _U('traffic_remove'), value = 'trr'}}

      if ESX.PlayerData.job.grade_name == 'airman' or ESX.PlayerData.job.grade_name == 'staff' then
				table.insert(elements, {label = _U('airman_remove'), value = 'air1r'})
			end
			
			if ESX.PlayerData.job.grade_name == 'senior' or ESX.PlayerData.job.grade_name == 'staff' then
				table.insert(elements, {label = _U('senior_remove'), value = 'air2r'})
			end
			
			if ESX.PlayerData.job.grade_name == 'staff' or ESX.PlayerData.job.grade_name == 'staff' then
				table.insert(elements, {label = _U('staff_remove'), value = 'air3r'})
			end

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove', {
				title    = _U('retrieve'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'trr' then
						TriggerServerEvent('esx_license:removeLicense',GetPlayerServerId(closestPlayer), 'dmv')
                                                ESX.ShowNotification(xPlayer, GetPlayerServerId(closestPlayer) .. 'Test' )
					elseif action == 'air1r' then
						TriggerServerEvent('esx_license:removeLicense',GetPlayerServerId(closestPlayer),'letecky1')
					elseif action == 'air2r' then
						TriggerServerEvent('esx_license:removeLicense',GetPlayerServerId(closestPlayer), 'letecky2')
                    elseif action == 'air3r' then
                        TriggerServerEvent('esx_license:removeLicense',GetPlayerServerId(closestplayer), 'letecky3')
                                end
                         else
                            ESX.ShowNotification(_U('no_players_nearby'))
                         end
                     end, function(data2, menu2)
				menu2.close()
	             end)
elseif data.current.value == 'bill' then
            OpenBillingMenu()
end
end, function(data, menu)
  menu.close()
end)
end


function OpenBillingMenu()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bil', {
      title = 'billing_amount'
    }, function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then
        menu.close()

        if amount == nil then
            ESX.ShowNotification(_U('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_flying', _U('billing'), amount)
        end
      else
        ESX.ShowNotification(_U('no_players_nearby'))
      end
    end, function(data, menu)
        menu.close()
    end)
end

--flying Actions

function OpenflyingActionsMenu()

  local elements = {
    {label = _U('vehicle_list'), value = 'vehicle_list'},
    {label = _U('deposit_stock'), value = 'put_stock'},
    {label = _U('withdraw_stock'), value = 'get_stock'},
    {label = _U('cloakroom'), value = 'cloakroom'},
    {label = _U('cloakroom2'), value = 'cloakroom'}
  }
  if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'flying_actions',
    {
      title    = _U('vehicle_list'),
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

        if Config.EnableSocietyOwnedVehicles then

            local elements = {}

            ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

              for i=1, #vehicles, 1 do
                table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
              end

              ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'vehicle_spawner',
                {
                  title    = _U('service_vehicle'),
                  align    = 'top-left',
                  elements = elements,
                },
                function(data, menu)

                  menu.close()

                  local vehicleProps = data.current.value

                  ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                    local playerPed = GetPlayerPed(-1)
                    TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  end)

                  TriggerServerEvent('esx_society:removeVehicleFromGarage', 'flying', vehicleProps)

                end,
                function(data, menu)
                  menu.close()
                end
              )

            end, 'flying')

          else

            local elements = {
			        --{label = 'Car', value = 'blista'},
              --{label = 'Motor', value = 'sanchez'},
              --{label = 'Truck', value = 'kart20'}
            }

      if ESX.PlayerData.job.grade_name == 'airman' then ---skupina PPLA
        table.insert(elements, {label = _U('ripley'), value = 'ripley'})
        table.insert(elements, {label = _U('airtug'), value = 'airtug'})
				table.insert(elements, {label = _U('lietadlo1'), value = 'shamal'})
			end
			
      if ESX.PlayerData.job.grade_name == 'senior' then --skupina CPLA
        table.insert(elements, {label = _U('ripley'), value = 'ripley'})
        table.insert(elements, {label = _U('airtug'), value = 'airtug'})
				table.insert(elements, {label = _U('lietadlo1'), value = 'shamal'})
      end
      
      if ESX.PlayerData.job.grade_name == 'staff' then --skupina PPLA/CPLA/CPLH
        table.insert(elements, {label = _U('ripley'), value = 'ripley'})
        table.insert(elements, {label = _U('airtug'), value = 'airtug'})
        table.insert(elements, {label = _U('lietadlo1'), value = 'shamal'})
        table.insert(elements, {label = _U('heli1'), value = 'supervolito2'})
        table.insert(elements, {label = _U('heli2'), value = 'buzzard2'})
      end
      
      if ESX.PlayerData.job.grade_name == 'chief' then --skupina PPLA/CPLA/CPLH
        table.insert(elements, {label = _U('ripley'), value = 'ripley'})
        table.insert(elements, {label = _U('airtug'), value = 'airtug'})
        table.insert(elements, {label = _U('lietadlo1'), value = 'shamal'})
        table.insert(elements, {label = _U('heli1'), value = 'supervolito2'})
        table.insert(elements, {label = _U('heli2'), value = 'buzzard2'})
      end

      if ESX.PlayerData.job.grade_name == 'sergeant' then --skupina PPLA/CPLA/CPLH
        table.insert(elements, {label = _U('ripley'), value = 'ripley'})
        table.insert(elements, {label = _U('airtug'), value = 'airtug'})
        table.insert(elements, {label = _U('lietadlo1'), value = 'shamal'})
        table.insert(elements, {label = _U('heli1'), value = 'supervolito2'})
        table.insert(elements, {label = _U('heli2'), value = 'buzzard2'})
      end
			

            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'spawn_vehicle',
              {
                title    = _U('service_vehicle'),
                elements = elements
              },
              function(data, menu)
                for i=1, #elements, 1 do
                  if Config.MaxInService == -1 then
                    ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                      local playerPed = GetPlayerPed(-1)
                      TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    end)
                    break
                  else
                    ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
                      if canTakeService then
                        ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                          local playerPed = GetPlayerPed(-1)
                          TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                        end)
                      else
                        ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
                      end
                    end, 'flying')
                    break
                  end
                end
                menu.close()
              end,
              function(data, menu)
                menu.close()
                OpenflyingActionsMenu()
              end
            )

          end
      end

      if data.current.value == 'cloakroom' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
            else
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
            end

        end)
      end

      if data.current.value == 'cloakroom2' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            TriggerEvent('skinchanger:loadSkin', skin)

        end)
      end

      if data.current.value == 'put_stock' then
        OpenPutStocksMenu()
      end

      if data.current.value == 'get_stock' then
        OpenGetStocksMenu()
      end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'flying', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'flying_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_flyingschooljob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do

      local item = items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_flyingschooljob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_flyingschooljob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_flyingschooljob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

AddEventHandler('esx_flyingschooljob:hasEnteredMarker', function(zone)

  if zone == 'flyingActions' then
    CurrentAction     = 'flying_actions_menu'
    CurrentActionMsg  = _U('open_actions')
    CurrentActionData = {}
  end

  if zone == 'DMVSchool' then
		CurrentAction     = 'theory_menu'
		CurrentActionMsg  = _U('press_open_theory')
		CurrentActionData = {}
   end

  if zone == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed,  false)

      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('veh_stored')
      CurrentActionData = {vehicle = vehicle}
    end
  end

end)

AddEventHandler('esx_flyingschooljob:hasExitedMarker', function(zone)
  CurrentAction = nil
  ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_flyingschooljob:loadLicenses')
AddEventHandler('esx_flyingschooljob:loadLicenses', function(licenses)
	Licenses = licenses
end)

--Blip
Citizen.CreateThread(function()

  for k,v in pairs(Config.Blip) do

    local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

    SetBlipSprite (blip, v.Sprite)
    SetBlipDisplay(blip, v.Display)
    SetBlipScale  (blip, v.Scale)
    SetBlipColour (blip, v.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)

  end

end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Wait(0)
	      local coords = GetEntityCoords(GetPlayerPed(-1))

    

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'flying' then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                  DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)

    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'flying' then
      local coords      = GetEntityCoords(GetPlayerPed(-1))
      local isInMarker  = false
      local currentZone = nil
      for k,v in pairs(Config.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
        end
      end
      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_flyingschooljob:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_flyingschooljob:hasExitedMarker', LastZone)
      end
    end
  end
end)


-- Block UI
Citizen.CreateThread(function()
    while true do
		    Citizen.Wait(1)

    		if CurrentTest == 'theory' then
    		    local playerPed = PlayerPedId()

    			  DisableControlAction(0, 1, true) -- LookLeftRight
      			DisableControlAction(0, 2, true) -- LookUpDown
      			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
      			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    		else
    			  Citizen.Wait(500)
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if CurrentAction ~= nil then

          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		  
		if IsControlJustReleased(0, 245) then
		  if CurrentAction == 'theory_menu' then
				OpenDMVSchoolMenu()
	        end
		end

          if IsControlJustReleased(0, 38) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'flying' then

            if CurrentAction == 'flying_actions_menu' then
                OpenflyingActionsMenu()
            end
 

            if CurrentAction == 'delete_vehicle' then

              if Config.EnableSocietyOwnedVehicles then

                local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
                TriggerServerEvent('esx_society:putVehicleInGarage', 'flying', vehicleProps)

              else

                if
                  GetEntityModel(vehicle) == GetHashKey('blista') or
                  GetEntityModel(vehicle) == GetHashKey('sanchez')
                then
                  TriggerServerEvent('esx_service:disableService', 'flying')
                end

              end

              ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
            end

            CurrentAction = nil
          end
        end

        if IsControlJustReleased(0, Keys['F6']) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'flying' then
            OpenflyingSchoolMenu()
        else
        	Citizen.Wait(100)
        end        
    end
end)
