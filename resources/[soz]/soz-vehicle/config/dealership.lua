Config.Dealerships = {
    ["pdm"] = {
        ["active"] = true,
        ["licence"] = "car",
        ["categories"] = {
            ["Sedans"] = "Sedans",
            ["Coupes"] = "Coupés",
            ["Suvs"] = "SUV",
            ["Off-road"] = "Tout-Terrain",
            ["Muscle"] = "Grosse Cylindrée",
            ["Compacts"] = "Compacts",
            ["Vans"] = "Vans",
        },
        ["blip"] = {
            ["name"] = "Concessionnaire Auto",
            ["coords"] = vector3(-45.67, -1098.34, 26.42),
            ["sprite"] = 225,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "s_m_m_autoshop_01",
            ["coords"] = vector4(-56.61, -1096.58, 25.42, 30.0),
            ["zone"] = {
                ["center"] = vector3(-55.49, -1096.44, 26.92),
                ["length"] = 10,
                ["width"] = 10,
                ["options"] = {
                    name = "Concess_z",
                    heading = 340,
                    minZ = 25.92,
                    maxZ = 29.92,
                }
            },
        },
        ["vehicle"] = {
            ["spawn"] = vector4(-46.64, -1097.53, 25.44, 26.42),
            ["camera"] = vector3(-53.69, -1094.83, 27.0),
        },
    },
    ["sport"] = {
        ["active"] = false,
        ["licence"] = "car",
        ["categories"] = {},
        ["blip"] = {
            ["name"] = "Concessionnaire Auto Sportive",
            ["coords"] = vector3(0, 0, 0),
            ["sprite"] = 523,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "a_m_y_business_03",
            ["coords"] = vector4(0, 0, 0, 0.0),
            ["zone"] = {}
        },
        ["vehicles"] = {
            ["spawn"] = vector4(0, 0, 0, 0.0),
            ["camera"] = vector3(0, 0, 0),
        },
    },
    ["cycle"] = {
        ["active"] = true,
        ["licence"] = nil,
        ["categories"] = {["Cycles"] = "Vélos"},
        ["blip"] = {
            ["name"] = "Concessionnaire Vélo",
            ["coords"] = vector3(-1222.26, -1494.83, 4.34),
            ["sprite"] = 559,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "s_m_m_autoshop_01",
            ["coords"] = vector4(-1222.26, -1494.83, 3.34, 120.0),
            ["zone"] = {
                ["center"] = vector3(-1223.7, -1495.49, 4.37),
                ["length"] = 8,
                ["width"] = 10,
                ["options"] = {
                    name = "Concessvelo_z",
                    heading = 305,
                    minZ = 3.37,
                    maxZ = 7.37,
                }
            },
        },
        ["vehicle"] = {
            ["spawn"] = vector4(-1221.96, -1498.45, 4.35, 210.0),
            ["camera"] = vector3(-1236.72, -1495.94, 5.33),
        },
        ["vehicleSpawnPosition"] = vector4(-1221.96, -1498.45, 4.35, 210.0),
    },
    ["moto"] = {
        ["active"] = true,
        ["licence"] = "motorcycle",
        ["categories"] = {["Motorcycles"] = "Motos"},
        ["blip"] = {
            ["name"] = "Concessionnaire Moto",
            ["coords"] = vector3(1224.79, 2727.25, 38.0),
            ["sprite"] = 522,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "s_m_m_autoshop_01",
            ["coords"] = vector4(1224.79, 2727.25, 37.0, 180.0),
            ["zone"] = {
                ["center"] = vector3(1224.99, 2725.22, 38.0),
                ["length"] = 8,
                ["width"] = 10,
                ["options"] = {
                    name = "Concessmoto_z",
                    heading = 0,
                    minZ = 37.0,
                    maxZ = 41.0,
                }
            },
        },
        ["vehicle"] = {["spawn"] = vector4(1212.69, 2726.24, 38.0, 180.0), ["camera"] = vector3(1224.5, 2701.63, 39.0)},
    },
    ["air"] = {
        ["active"] = true,
        ["licence"] = "heli",
        ["categories"] = {["Helicopters"] = "Hélicoptères"},
        ["blip"] = {
            ["name"] = "Concessionnaire Hélicoptère",
            ["coords"] = vector3(1734.18, 3313.44, 41.22),
            ["sprite"] = 64,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "s_m_m_autoshop_02",
            ["coords"] = vector4(1743.13, 3307.23, 40.22, 148.91),
            ["zone"] = {
                ["center"] = vector3(1732.15, 3308.31, 41.22),
                ["length"] = 23.8,
                ["width"] = 27.8,
                ["options"] = {
                    name = "sandy_concess_air",
                    heading = 15,
                    minZ = 40.22,
                    maxZ = 44.22,
                }
            },
        },
        ["vehicle"] = {
            ["spawn"] = vector4(1730.47, 3314.38, 40.22, 153.64),
            ["camera"] = vector4(1733.07, 3303.82, 42.22, 14.55),
        },
    },
    ["boat"] = {
        ["active"] = false,
        ["licence"] = "boat",
        ["categories"] = {["Boats"] = "Bateaux"},
        ["blip"] = {
            ["name"] = "Concessionnaire Bateau",
            ["coords"] = vector3(0, 0, 0),
            ["sprite"] = 410,
            ["color"] = 46,
        },
        ["ped"] = {
            ["model"] = "mp_f_boatstaff_01",
            ["coords"] = vector4(0, 0, 0, 0),
            ["zone"] = {}
        },
        ["vehicle"] = {["spawn"] = vector4(0, 0, 0, 0), ["camera"] = vector3(0, 0, 0)},
    },
}
