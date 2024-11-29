ChemicalStack = {}
ChemicalStack.__index = ChemicalStack


--#region Constructor
function ChemicalStack:new(name, amount)
    local instance = setmetatable({}, self)

    instance.name = name or "Undefined"
    instance.amount = amount or 0

    return instance
end
--#endregion Constructor


--#region Methods
function ChemicalStack:get_name()
    return self.name
end

function ChemicalStack:get_amount()
    return self.amount
end

function ChemicalStack:set_name(new_name)
    self.name = new_name    
end

function ChemicalStack:set_amount(new_amount)
    if new_amount < 0 then
        new_amount = 0
    end 

    self.amount = new_amount
end
--#endregion Methods

return ChemicalStack
