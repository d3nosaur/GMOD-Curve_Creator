-- Deno's curve creator tool for Garry's Mod
-- Feel free to edit or republish this code
-- If you have any questions, contact me on discord (Deno#5735)

-- This class should only be used as a base to create other curves, should not be initialized on its own

BaseCurve = {
    controlPoints = {},
    activeMemo = {} -- memoization for calc function, resets whenever control points are altered, index = time + array of control point indices, value = curve position at time
}

local throwawayPos = Vector(0, 0, 0) -- not meant to actually use this class so I'm not gonna go through the hassle of returning a real value
function BaseCurve:GetPos(time) -- gets position at given time value (float between 0 and 1)
    return throwawayPos
end

function BaseCurve:GetControlSize() -- returns number of control points, including weight ones (for cases like bezier curve)
    return #self.controlPoints
end

function BaseCurve:AddControlPoint(point) -- adds a control point to front of curve
    point.curveIndex = self:GetControlSize() + 1
    point.parentCurve = self
    table.insert(self.controlPoints, point)

    self.activeMemo = {}
end

-- WARNING: Does not check to make sure the curve contains the point, do not call this function unless you are sure it does
function BaseCurve:RemoveControlPoint(point) -- removes a control point from the curve
    local index = point.curveIndex

    for i=index+1, self:GetControlSize() do
        local point = self.controlPoints[i]

        point.curveIndex = point.curveIndex - 1
    end

    point.parentCurve = nil
    table.remove(self.controlPoints, index)

    self.activeMemo = {}
end

-- Internal function to get the number of local paths within curve
function BaseCurve:GetNumPaths(numPointsPerLocalPath)
    local numBoundaryPoints = math.floor(self:GetControlSize() / (numPointsPerLocalPath - 1)) + 1 -- number of points that define local paths
    local numPaths = numBoundaryPoints - 1 -- number of paths between points

    return numPaths
end

function BaseCurve:New(obj) -- initialize curve class, pass argument of existing curve table or nil
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end