local ChemicalStack = require("base.entities.ChemicalStack")
local FissionReactor = require("base.entities.FissionReactor")

local reactor_periph = peripheral.wrap("fissionReactorLogicAdapter_0")
local fuel_tank = reactor_periph.getFuel()
local reactor = FissionReactor:new(
    reactor_periph.getStatus(),
    reactor_periph.getTemperature(),
    ChemicalStack:new(
        fuel_tank.name,
        fuel_tank.amount
    )
)

local function main()
    while true do
        reactor:set_is_active(reactor_periph.getStatus())
        reactor:set_temp(reactor_periph.getTemperature())
        fuel_tank = reactor_periph.getFuel()
        reactor:set_fuel(ChemicalStack:new(fuel_tank.name, fuel_tank.amount))

        reactor:print_stat()
        print("=========================")

        sleep(3)
    end
end


-- Run main
main()