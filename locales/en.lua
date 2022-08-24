local Translations = {
    error = {
        ['not_the_owner'] = 'You do not own this vehicle!',
        ['area_is_obstructed'] = "This area is obstructed",
        ['is_in_vehicle'] = "You are already in a vehicle",
    },
    menu = {
        ['garage'] = "My Garage",
        ['parking'] = "Parking",
        ['close_menu'] = "Close menu",
        ['radialmenu'] = "My Vehicles",
    },
    vehicle = {
        ['plate'] = "Plate: %{plate}<br>",
        ['fuel']  = "Fuel: %{fuel}%<br>",
        ['engine'] = "Engine: %{engine}%<br>",
        ['body']  = "Body: %{body}%<br>",
    },
    command = {
        ['info'] = "Park or get your vehicle",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})