MenuData = {}
TriggerEvent("redemrp_menu_base:getData",function(call)
    MenuData = call
end)

local Prison = {name = "Prison", x = 3352.7, y = -651.52, z = 45.30 }
local ExitPrisonPier = {name = "Prison Pier", x = 2882.63, y = -1376.32, z = 44.55 }
local jailTime = 0

-- Test Function | Uses Left Arrow for Jailing
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if IsControlJustPressed(0, 0xA65EBAB4) then
--             jailMenu()
--         end
--     end
-- end)



function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
	local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
    end
    
	for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

RegisterNetEvent('dans_jail:client:jailLogin')
AddEventHandler('dans_jail:client:jailLogin', function(newJailTime)
    jailTime = newJailTime
    print("JAIL LOGIN")
    SetEntityCoords(PlayerPedId(), Prison.x, Prison.y, Prison.z)
    TriggerEvent('redem_roleplay:Tip', "You logged out while in prison, you still have to serve your sentence!", 4000)
    InJail()
end)

RegisterNetEvent('dans_jail:client:jailPlayer')
AddEventHandler('dans_jail:client:jailPlayer', function(newJailTime)
    jailTime = newJailTime + 1
    print(jailTime.." Jail Time")
    SetEntityCoords(PlayerPedId(), Prison.x, Prison.y, Prison.z)
    TriggerServerEvent('redemrp_status:AddAmount', 100, 100)
    InJail()
end)

RegisterNetEvent('dans_jail:client:unJailPlayer')
AddEventHandler('dans_jail:client:unJailPlayer', function()
    jailTime = 0

    UnJail()
end)

RegisterNetEvent('dans_jail:client:openJailMenu')
AddEventHandler('dans_jail:client:openJailMenu', function()
    print("IT WORKS WTF")
end)

function InJail()
    Citizen.CreateThread(function()
        while jailTime > 0 do
            local coords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(coords, Prison.x, Prison.y, Prison.z)

            if distance < 50.0 then
                jailTime = jailTime - 1

                print("IN JAIL NOW!")
                TriggerEvent('redem_roleplay:Tip', "You have "..jailTime.." Minutes Left", 4000)

                TriggerServerEvent('dans_jail:server:updateJailTime', jailTime)

                if jailTime == 0 then
                    UnJail()

                    TriggerServerEvent('dans_jail:server:updateJailTime', 0)
                end
            else
                TriggerServerEvent('dans_jail:server:updateJailTime', 0)
                TriggerEvent('redem_roleplay:Tip', "You have escaped from Prison!", 4000)
                jailTime = jailTime - jailTime
                print(jailTime)
            end
            Citizen.Wait(60000) 
        end       
    end)
end

function UnJail()
    InJail()

    SetEntityCoords(PlayerPedId(), ExitPrisonPier.x, ExitPrisonPier.y, ExitPrisonPier.z)

    TriggerEvent('redem_roleplay:Tip', "You have been released!", 4000)
end

function jailMenu()
    MenuData.CloseAll()
    local elements = {}

    local elements = {
        { label = "Jail Nearest Player", value = 'jail' },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'jail_menu', {
        title = "Jail Menu",
        subtext = "Sheriff Jail Menu",
        align = 'top-left',
        elements = elements,
    },
    function(data, menu)
        if(data.current.value == 'jail') then
            elements2 = {
                { label = "Jail Time", value = 1, type = 'slider', min = 1, max = 60},
            }
            menu.close()

            MenuData.Open('default', GetCurrentResourceName(), 'jailTime_menu', {
                title = "Send to Jail",
                subtext = "Sentence Length",
                align = 'top-left',
                elements = elements2,
            },
            function(data2, menu2)
                local jailTime = tonumber(data2.current.value)
                local reason = "criminal"

                local closestPlayer, closestDistance = GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                else
                    TriggerServerEvent('dans_jail:server:jailPlayer', GetPlayerServerId(closestPlayer), jailTime)
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end
