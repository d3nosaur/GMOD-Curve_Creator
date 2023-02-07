LinearCurve = BaseCurve:New()

local function calc(u, p0, p1)
    local memoKey = tostring(u) .. ", " .. tostring(p0.curveIndex) .. ", " .. tostring(p1.curveIndex)
    if self.activeMemo[memoKey] then return self.activeMemo[memoKey] end

    self.activeMemo[memoKey] = LerpVector(u, p0:GetPos(), p1:GetPos())
    return self.activeMemo[memoKey]
end

function LinearCurve:GetPos(time) -- gets position at given time value (float between 0 and 1)
    local controlPoints = self.controlPoints

    local numPaths = self:GetNumPaths(2)
    local globalTime = time * numPaths
    local leftBound = math.floor(globalTime)
    local localTime = globalTime % 1

    if leftBound == numPaths then
        leftBound = leftBound - 1
        localTime = localTime + 1
    end

    local leftIndex = leftBound + 1

    return calc(localTime, controlPoints[leftIndex], controlPoints[leftIndex + 1])
end

function LinearCurve:New(obj)
    obj = obj or BaseCurve:New()
    setmetatable(obj, self)
    self.__index = self

    return obj
end