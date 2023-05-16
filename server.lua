-- local QBCore = exports["qb-core"]:GetCoreObject()

-- RegisterNetEvent('moon-helis:server:updatehelistatus', function(vehiclename, citizenid, state)
--     local src = source

--     -- Check if the entry exists in the table
--     local query = "SELECT * FROM moon_helis WHERE citizenid = ? AND vehicle_name = ?"
--     exports.oxmysql:execute(query, {citizenid, vehiclename}, function(result)
--         if result[1] then
--             local updateQuery = "UPDATE moon_helis SET status = ? WHERE citizenid = ? AND vehicle_name = ?"
--             exports.oxmysql:execute(updateQuery, {state, citizenid, vehiclename})
--         else
--             local insertQuery = "INSERT INTO moon_helis (citizenid, vehicle_name, status) VALUES (?, ?, 0)"
--             exports.oxmysql:execute(insertQuery, {citizenid, vehiclename})
--         end
--     end)
-- end)

--^ For Future Updates Dont Mess






