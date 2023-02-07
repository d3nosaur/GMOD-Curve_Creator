# GMOD-Curve_Creator
A simple library for creating curves and splines in Garry's Mod

Initialize a curve by using the classes initializer method
```
local curve = CubicBezier:New()
```
Once you have you're curve, you can add control points to it by using
```
local controlPoint = CurveControlPoint:New(nil, position)
curve:AddControlPoint(controlPoint)
```
To get the position at a time value on the curve, use
```
local pos = curve:GetPos(time) -- time is between 0 and 1
```


```
-- Curve Functions

-- Initialize a curve
-- Param: An existing curves object (or nil if creating a new one)
-- Returns: The curve object
CurveClass:New(obj)

-- Get a curves position at a time.
-- Param: Float, the time value (between 0 and 1)
-- Returns: Vector, the position
curve:GetPos(time)

-- Get the amount of control points within the curve
-- Returns: Integer value of number of control points
curve:GetControlSize()

-- Add a control point to the curve
-- Param: The control point object
curve:AddControlPoint(point)

-- Remove a control point from the curve
-- Param: The control point object
curve:RemoveControlPoint(point)
```


```
-- Control Point Functions

-- Initialize a control point
-- Params
--  Object - An existing control point object (or nil if creating a new one)
--  Position - The position of the control point
-- Returns: The control point object
CurveControlPoint:New()

-- Sets a new position for the curve
-- Param: Vector, the new position
point:SetPos(pos)

-- Gets the position of the control point (Can be overrided to provide interesting results such as parenting to an entity)
-- Returns: The position of the point
point:GetPos()

-- Removes the control point (And handles removing from parent curve)
point:Remove()
```

There are currently 2 different types of curves:
 - CubicBezier: A generic cubic bezier, requires 2 additional weighted control points for every pair of main control points (total = 1+3n points)
 - LinearCurve: Just straight lines between control points, mainly used for testing

Future Plans:
 - Catmull-Rom: Very useful for just throwing down points and having a curve created out of them, curve will travel through all the points
 - B-Spline: Similar to Catmull-Rom but more continuous and doesn't pass through every point
