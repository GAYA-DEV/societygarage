config = {}

config.veh = {
    {society = "ambulance", label = "~g~ interne ~s~| Ambulance", name = "ambulance", price = 12300},
    {society = "ambulance", label = "~g~ interne ~s~| V.L", name = "dodgeems", price = 15000},
    {society = "ambulance", label = "~y~ Medecin ~s~| 4x4", name = "polstalkerg", price = 15000},
    {society = "ambulance", label = "~y~ Medecin ~s~| V.I.R", name = "poltorenceg", price = 15000},
    {society = "ambulance", label = "~r~ Chirurgien ~s~| V.L", name = "ghispo3", price = 22500},

    {society = "police", label = "Recrue", name = "police", price = 22500},
    {society = "police", label = "~b~Officier ~s~| Dodge", name = "police2", price = 22500},
    {society = "police", label = "~b~Officier ~s~| Chevrolet", name = "police8", price = 22500},
    {society = "police", label = "~b~Officier ~s~| Ford - Interceptor", name = "police3", price = 22500},
    {society = "police", label = "~b~Sergent ~s~| Dodge", name = "police2", price = 22500},
    {society = "police", label = "~b~Sergent ~s~| Moto", name = "polthrust", price = 22500},
    {society = "police", label = "~b~Sergent ~s~| Bus pénitentiaire", name = "pbus", price = 22500},
    {society = "police", label = "~b~Sergent ~s~| Fourgon pénitentiaire", name = "policet", price = 22500},
    {society = "police", label = "~b~Sergent ~s~| Blindé", name = "riot", price = 22500},
    {society = "police", label = "~b~Lieutenant ~s~| Porshe", name = "pol718", price = 22500},
    {society = "police", label = "~b~Lieutenant ~s~| Oracle Banalisé", name = "policefelon", price = 22500},
    {society = "police", label = "~b~Capitaine ~s~| VIR", name = "polp1", price = 22500},
    {society = "police", label = "~b~Commandant ~s~| VIR Porsche", name = "pol718", price = 22500},

    {society = "fbi", label = "~y~ Suburban", name = "suburban", price = 22500},
    {society = "fbi", label = "~y~ Véhicule intérvention", name = "gurkhaff", price = 22500},
    {society = "fbi", label = "~y~ Range Rover", name = "um1", price = 22500},
    {society = "fbi", label = "~y~ Ford interceptor", name = "um2", price = 22500},
    {society = "fbi", label = "~y~ Dodge Blanche", name = "um3", price = 22500},
    {society = "fbi", label = "~y~ Ford 4X4", name = "um5", price = 22500},

    {society = "mecano", label = "~o~ Transporteur remorque", name = "flatbedm2", price = 22500},
    {society = "mecano", label = "~o~ Dépaneuse", name = "towtruck2", price = 22500},
}

config.thegarage = {
    {
        label = "A.M.S",
        society = "ambulance",
        name = "s_m_m_security_01",
        posx = 304.75, 
        posy = -1448.14, 
        posz = 29.97, 
        posh = 25.36,
        PosSpawn = vector3(312.08, -1447.74, 29.97), 
        HedSpawn = 229.67
    },
    --[[{
        label = "L.S.P.D",
        society = "police",
        name = "s_m_m_security_01",
        posx = 460.71, 
        posy = -988.17, 
        posz = 25.70, 
        posh = 153.06,
        PosSpawn = vector3(458.40, -993.46, 25.70), 
        HedSpawn = 229.67
    },]]--
    --[[{
        label = "F.B.I",
        society = "fbi",
        name = "s_m_m_security_01",
        posx = 61.57, 
        posy = -753.22, 
        posz = 44.22, 
        posh = 73.02,
        PosSpawn = vector3(55.23, -751.35, 44.22), 
        HedSpawn = 339.24
    },]]--
    --[[{
        label = "Benny's",
        society = "mecano",
        name = "s_m_m_security_01",
        posx = -175.57, 
        posy = -1296.42, 
        posz = 31.05, 
        posh = 201.67,
        PosSpawn = vector3(-167.87, -1299.98, 31.05), 
        HedSpawn = 92.03
    },]]--
}

config.haveESXVehicleLock = false