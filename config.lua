Config = {}

Config.DrawDistance               = 20.0 -- How close would you need to come to the point for it to show?
Config.MarkerType                 = 1 -- It Is what it sounds like
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.EnablePlayerManagement     = true -- Enable If you have esx_society installed!
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService           = -1
Config.TheoryPrice =   200

Config.Locale                     = 'en'

Config.Zones = {
       
	flyingActions = {
		Pos   = {x = -941.62, y = -2955.77, z = 13.9},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 32, g = 229, b = 10},
		Type  = 21
	},

        
	VehicleDeleter = {
		Pos   = {x = -962.44, y = -2985.14, z = 14.5},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 229, g = 25, b = 10 },
		Type  = 33
	},

	VehicleSpawnPoint = {
		Pos   = {x = -962.44, y = -2985.14, z = 13.4},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 0, b = 0},
		Heading = 58.08,
		Type  = -1
	},

}

Config.Blip = {

   Blip = {
      Pos     = {x = -962.44, y = -2985.14, z = 12.4},
      Sprite  = 251,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    }
}

