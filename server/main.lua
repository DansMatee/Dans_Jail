AddEventHandler('redemrp:playerLoaded', function(source, user) -- When user connects
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")
        print(charid)

        MySQL.Async.fetchAll('SELECT jail FROM characters WHERE identifier = @identifier AND characterid = @charid', { ["@identifier"] = identifier, ["@charid"] = charid }, function(result)
            local newJailTime = tonumber(result[1].jail)

            if newJailTime > 0 then
                Citizen.Wait(2000)
                TriggerClientEvent('dans_jail:client:jailLogin', _source, newJailTime)
                print("SHOULD BE IN JAIL")
            else
                print("no time - player loaded")
            end
        end)
    end)
end)

RegisterServerEvent('dans_jail:server:updateJailTime') -- Updates jail time
AddEventHandler('dans_jail:server:updateJailTime', function(newJailTime)
    local _source = source
    EditJailTime(_source, newJailTime)
end)

RegisterServerEvent('dans_jail:server:jailPlayer') -- Jails player
AddEventHandler('dans_jail:server:jailPlayer', function(targetSrc, jailTime, jailReason)
    local _source = source
    print(_source)
    local _targetSrc = targetSrc
    print(_targetSrc)
    if _targetSrc ~= 0 then 
        TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
            if user.getJob() == "sheriff" then
                JailPlayer(_targetSrc, jailTime)

                print(_source .." jailed ".. _targetSrc)
            end
        end)
    else
        print('Noone near')
    end
end)

function EditJailTime(source, jailTime) -- Edits jail time

    local _source = source
    print(_source.." Test")
    
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")

        MySQL.Async.execute('UPDATE characters SET jail = @newJailTime WHERE identifier = @identifier AND characterid = @charid',
            { ["@identifier"] = identifier, ["@charid"] = charid, ["@newJailTime"] = tonumber(jailTime) }
        )
    end)
end

function JailPlayer(jailPlayer, jailTime)
    TriggerClientEvent('dans_jail:client:jailPlayer', jailPlayer, jailTime)

    EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
    TriggerClientEvent('dans_jail:client:unJailPlayer', jailPlayer)

    EditJailTime(jailPlayer, 0)
end
