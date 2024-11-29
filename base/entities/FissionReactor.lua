local ChemicalStack = require("base.entities.ChemicalStack")

FissionReactor = {}
FissionReactor.__index = FissionReactor

function FissionReactor:new(is_active, temp, fuel_tank)
    print("Creating new instance...")
    local instance = setmetatable({}, self)
    print("Metatable set: ", getmetatable(instance))

    instance.is_active = is_active
    instance.temp = temp
    instance.fuel_tank = fuel_tank

    return instance
end

function FissionReactor:print_stat()
    print("Fission Reactor State")
    print("Is Acive: ", self.is_active)
    print("Temperature: ", self.temp)
    print("Fuel: ", self.fuel_tank:get_name(), " = ", self.fuel_tank:get_amount())
end

--#region Setters
function FissionReactor:set_is_active(is_active)
    self.is_active = is_active
end

function FissionReactor:set_temp(temp)
    self.temp = temp
end

function FissionReactor:set_fuel(fuel_tank)
    self.fuel_tank = fuel_tank
end
--#endregion Setters


--#region Getters
function FissionReactor:get_is_active()
    return self.is_active
end

function FissionReactor:get_temp()
    return self.temp
end

function FissionReactor:get_fuel_tank()
    return self.fuel_tank
end
--#endregion Getters


return FissionReactor
