local Translations = {
    error = {
        ['not_the_owner'] = 'Je bent geen eigennaar van dit voertuig!',
        ['area_is_obstructed'] = "Het gebied word belemmerd",
        ['is_in_vehicle'] = "Je zit al in een voertuig",
    },
    menu = {
        ['garage'] = "Mijn Garage",
        ['parking'] = "Parkeren",
        ['close_menu'] = "Sluit menu",
        ['radialmenu'] = "Mijn Voertuigen",
        ['header_cotegories'] = "Voertuigcategorieën",
    },
    vehicle = {
        ['plate'] = "Kenteken: %{plate}<br>",
        ['fuel']  = "Brandstof: %{fuel}%<br>",
        ['engine'] = "Motor: %{engine}%<br>",
        ['body']  = "Body: %{body}%<br>",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
