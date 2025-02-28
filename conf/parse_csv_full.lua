local headers_store = {}

function csv_parse(tag, timestamp, record)
    local csv_line = record["log"]
    if not csv_line then
        return 0, 0, 0
    end

    local headers_key = tag
    if not headers_store[headers_key] and csv_line:match("^No%.") and csv_line:find(",", 1, true) then
        headers_store[headers_key] = {}
        local index = 1
        for value in csv_line:gmatch("[^,]+") do
            local clean_name = value:gsub("[^%w%s%-]", "_"):gsub("%s+", "_")
            headers_store[headers_key][index] = clean_name
            index = index + 1
        end
        return 0, 0, 0  -- Skip header
    end

    if not headers_store[headers_key] then
        return 0, 0, 0  -- Skip if no header
    end

    local fields = {}
    local index = 1
    for value in csv_line:gmatch("[^,]+") do
        if headers_store[headers_key][index] then
            fields[headers_store[headers_key][index]] = value
        end
        index = index + 1
    end

    return 1, timestamp, fields
end