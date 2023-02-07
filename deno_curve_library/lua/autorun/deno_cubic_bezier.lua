CubicBezier = BaseCurve:New()

--[[
    cubic bezier matrix, could implement using Matrix class in glua but it only allows for 4x4 matrices so I wouldn't be able to multiply, making it redundant

    { 1,  0,  0,  0},
    {-3,  3,  0,  0},
    { 3, -6,  3,  0},
    {-3,  3, -3,  1}
]]

-- [1, u, u^2, u^3] * cubic bezier matrix * position values
-- Internal function, do not call unless you know what you're doing
function CubicBezier:calc(u, p0, p1, p2, p3) -- u = time, p0-p3 are points
    local memoKey = tostring(u) .. ", " .. tostring(p0.curveIndex) .. ", " .. tostring(p1.curveIndex) .. ", " .. tostring(p2.curveIndex) .. ", " .. tostring(p3.curveIndex)
    if self.activeMemo[memoKey] then return self.activeMemo[memoKey] end

    -- basically doing [1, u, u^2, u^3] * cubicBezierMatrix

    local u2 = u * u
    local u3 = u * u * u

    -- scalar multiples for the positions
    -- ex: at u=0, it will be {1, 0, 0, 0}, completely setting weights towards p0
    local p0Mult = (1) + (u*-3) + (u2* 3) + (u3*-1)
    local p1Mult =       (u* 3) + (u2*-6) + (u3* 3)
    local p2Mult =                (u2* 3) + (u3*-3)
    local p3Mult =                          (u3* 1)

    -- find new positions using multipliers
    local p0NewPos = p0:GetPos() * p0Mult
    local p1NewPos = p1:GetPos() * p1Mult
    local p2NewPos = p2:GetPos() * p2Mult
    local p3NewPos = p3:GetPos() * p3Mult

    -- finalPos is all the new positions added together
    local finalPos = p0NewPos + p1NewPos + p2NewPos + p3NewPos

    self.activeMemo[memoKey] = finalPos
    return self.activeMemo[memoKey]
end

function CubicBezier:GetPos(time) -- gets position at given time value (float between 0 and 1)
    local numControlPoints = self:GetControlSize()
    local controlPoints = self.controlPoints

    -- TODO: automatically cull additional ones
    if numControlPoints < 4 || (numControlPoints - 1) % 3 != 0 then -- need to have sets of 4 points or it wont work, might look for alternative to cull extras and remove this error
        print("Cubic Bezier Error: Incorrect number of control points")
        return
    end

    local numPaths = self:GetNumPaths(4) -- number of important separate curves within the curve
    local globalTime = time * numPaths -- each whole number represents a new curve with the following decimal being the time on the curve, ex: 3.5 is halfway through third curve
    local leftBound = math.floor(globalTime) -- left bound of current curve on global curve
    local localTime = globalTime % 1 -- local time of current curve (between 0 and 1)

    if leftBound == numPaths then -- can bug out if leftBound is the far right right point
        leftBound = leftBound - 1
        localTime = localTime + 1
    end

    local leftIndex = (leftBound * 3) + 1 -- index of control point at left side of current curve

    return self:calc(localTime, controlPoints[leftIndex], controlPoints[leftIndex + 1], controlPoints[leftIndex + 2], controlPoints[leftIndex + 3])
end

--[[function CubicBezier:GetPos(time) -- gets position at given time value (float between 0 and 1)
    local numControlPoints = self:GetControlSize()
    local controlPoints = self.controlPoints

    -- TODO: automatically cull additional ones
    if numControlPoints < 4 || (numControlPoints - 1) % 3 != 0 then -- need to have sets of 4 points or it wont work, might look for alternative to cull extras and remove this error
        print("Cubic Bezier Error: Incorrect number of control points")
        return
    end

    local numPaths = self:GetNumPaths(4)
    local leftBound, rightBound = self:CalculateLocalBounds(time, 4, numPaths)
    local leftIndex = self:GetLeftIndex(leftBound, numPaths, 4)

    local newTime = math.Remap(time, leftBound, rightBound, 0, 1) -- remap the value to be between 0 and 1 relative to current curve

    return self:calc(newTime, controlPoints[leftIndex], controlPoints[leftIndex + 1], controlPoints[leftIndex + 2], controlPoints[leftIndex + 3])
end]]

function CubicBezier:New(obj)
    obj = obj or BaseCurve:New()
    setmetatable(obj, self)
    self.__index = self

    return obj
end