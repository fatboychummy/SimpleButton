local ret = {}
local erString = "Bad argument #%d: %s"
local tpString = "Bad argument #%d: Expected %s, got %s"

function ret.new(periph, x, y, w, h, bg, fg, text, centered)
  if type(periph) ~= "table" then
    error(string.format(tpString, 1, "table", type(periph)), 2)
  end
  if type(periph.setBackgroundColor) ~= "function" then
    error(string.format(erString, 1, "Table is missing field setBackgroundColor"))
  end
  if type(periph.setTextColor) ~= "function" then
    error(string.format(erString, 1, "Table is missing field setTextColor"))
  end
  if type(periph.setCursorPos) ~= "function" then
    error(string.format(erString, 1, "Table is missing field setCursorPos"))
  end
  if type(periph.write) ~= "function" then
    error(string.format(erString, 1, "Table is missing field write"))
  end
  if type(periph.getTextColor) ~= "function" then
    error(string.format(erString, 1, "Table is missing field getTextColor"))
  end
  if type(periph.getBackgroundColor) ~= "function" then
    error(string.format(erString, 1, "Table is missing field getBackgroundColor"))
  end
  if type(x) ~= "number" then
    error(string.format(tpString, 2, "number", type(x)), 2)
  end
  if type(y) ~= "number" then
    error(string.format(tpString, 3, "number", type(y)), 2)
  end
  if type(w) ~= "number" then
    error(string.format(tpString, 4, "number", type(w)), 2)
  end
  if type(h) ~= "number" then
    error(string.format(tpString, 5, "number", type(h)), 2)
  end

  if type(bg) ~= "number" then
    error(string.format(tpString, 6, "number", type(bg)), 2)
  end
  if type(fg) ~= "number" then
    error(string.format(tpString, 7, "number", type(fg)), 2)
  end
  if type(text) ~= "string" and text ~= nil then
    error(string.format(tpString, 8, "string or nil", type(text)), 2)
  end
  if type(centered) ~= "boolean" and centered ~= nil then
    error(string.format(tpString, 9, "boolean or nil", type(centered)), 2)
  end

  w = w - 1
  h = h - 1
  text = text or ""

  local bT = {periph = upon}
  bT.x = x
  bT.y = y
  bT.w = w
  bT.h = h

  function bT.hit(_x, _y)
    return     _x >= x
           and _x <= x + w
           and _y >= y
           and _y <= y + h
  end

  function bT.draw()
    local oldBG, oldFG = periph.getBackgroundColor(), periph.getTextColor()
    local rep = string.rep(' ', w + 1)

    periph.setBackgroundColor(bg)
    periph.setTextColor(fg)
    for i = 0, h do
      periph.setCursorPos(x, y + i)
      periph.write(rep)
    end

    if centered then
      periph.setCursorPos(x + math.floor(w / 2) - math.floor(text:len() / 2), y + math.floor(h / 2))
    else
      periph.setCursorPos(x, y)
    end
    periph.write(text)

    periph.setBackgroundColor(oldBG)
    periph.setTextColor(oldFG)
  end

  local returnedTable = {}
  local mt = {}
  function mt.__index(t, k)
    if t == returnedTable then
      return bT[k]
    end
  end
  function mt.__newindex(t, k)
    if t == returnedTable then
      error("Why are you trying to set a variable inside a button object?", 2)
    end
  end
  return setmetatable(returnedTable, mt)
end

return ret
