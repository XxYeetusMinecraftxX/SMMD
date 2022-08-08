local component = require("component")
local event = require("event")
local sides = require("sides")
local term  = require("term")

-- Example addresses for 2 redstone I/O as it uses redstone currently
local redstoneI1 = component.proxy("58bbd304-f0c8-4b67-8afa-1aaf798b35ca") 
local redstoneI2 = component.proxy("b3839192-b978-43d9-a78b-bd00a82fd6f4")
local gpu = component.gpu

-- Resolution set to nicely fill a 2x1 horizontal screen Tier 2
gpu.setResolution(60,12)

local loop = true
local maintenance = false

while loop do

    maintenance = false
    term.clear()

    component.gpu.set(2,10,"╔═════╗")
    component.gpu.set(2,11,"║Shell║")
    component.gpu.set(2,12,"╚═════╝")

    if redstoneI1.getInput(sides.east)>0 then
        print("I1 Needs maintenance")
        maintenance = true
    end

    if redstoneI2.getInput(sides.south)>0 then
        print("I2 Needs maintenance")
        maintenance = true
    end

    -- "Maintenance needed" alert
    if maintenance then
        gpu.setBackground(0xFF0000)
        gpu.setForeground(0x000000)
        component.gpu.set(25,10,"                    ")
        component.gpu.set(25,11,"                    ")
        component.gpu.set(25,12,"                    ")
        component.gpu.set(26,11,"MAINTENANCE NEEDED")
        gpu.setForeground(0xFFFFFF)
        gpu.setBackground(0x000000)
    end

    local kill,_,x,y = event.pull(1,"touch")

    -- Back to shell button logic
    if (kill and x>1 and x<9 and y>9 and y<13) then
        loop = false
        term.clear()
    end
end
