-- Deno's curve creator tool for Garry's Mod
-- Feel free to edit or republish this code
-- If you have any questions, contact me on discord (Deno#5735)

-- This part of the code is for visualizing curves and is not required for the rest of the system to work

if SERVER then return end

curve = curve or nil

local function createControlPoint(ply)
    if curve == nil then
        curve = CubicBezier:New()
    end

    local controlEnt = ents.CreateClientProp()
    controlEnt:SetPos(ply:GetPos())
    controlEnt:SetModel("models/hunter/misc/sphere075x075.mdl")
    controlEnt:Spawn()

    local controlPoint = CurveControlPoint:New(nil, ply:GetPos())
    controlPoint.GetPos = function()
        return controlEnt:GetPos()
    end

    controlPoint.parentEnt = controlEnt

    curve:AddControlPoint(controlPoint)
end
concommand.Add("curvecontrol", createControlPoint)

local function removeDrawnEnts()
    if not curve or not curve.drawEnts or #curve.drawEnts < 1 then return end

    for _, drawEnt in ipairs(curve.drawEnts) do
        drawEnt:Remove()
    end
end

local function removeCurve()
    if not curve then 
        print("Error: No curve exists")
        return 
    end

    for i = curve:GetControlSize(), 1, -1 do
        curve.controlPoints[i].parentEnt:Remove()
        curve.controlPoints[i]:Remove()
    end

    removeDrawnEnts()

    curve = nil
end
concommand.Add("curveremove", removeCurve)

local function printCurve()
    if not curve then 
        print("Error: No curve exists")
        return 
    end

    PrintTable(curve.controlPoints)
end
concommand.Add("curveprint", printCurve)

local function drawCurve()
    removeDrawnEnts()

    curve.drawEnts = {}

    for i=0, 1, 0.01 do
        local pos = curve:GetPos(i)

        local visualModel = ents.CreateClientProp()
        visualModel:SetPos(pos)
        visualModel:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        visualModel:Spawn()

        table.insert(curve.drawEnts, visualModel)
    end
end
concommand.Add("curvedraw", drawCurve)

