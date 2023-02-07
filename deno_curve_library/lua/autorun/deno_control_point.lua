-- Deno's curve creator tool for Garry's Mod
-- Feel free to edit or republish this code
-- If you have any questions, contact me on discord (Deno#5735)

-- This class is used to store control points for the curves

CurveControlPoint = {
    position = nil,
    curveIndex = nil,
    parentCurve = nil
}

function CurveControlPoint:GetPos()
    return self.position
end

function CurveControlPoint:SetPos(newPos)
    self.position = newPos
end

function CurveControlPoint:Remove()
    if self.parentCurve then
        self.parentCurve:RemoveControlPoint(self)
    end

    self = nil
end

function CurveControlPoint:New(obj, pos) -- initialize control point class, pass argument of existing control point or nil
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self

    self.position = pos

    return obj
end