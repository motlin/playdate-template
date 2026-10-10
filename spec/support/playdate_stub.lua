-- Minimal host-side stand-in for the Playdate runtime so pure game logic runs under plain Lua.

package.path = "source/?.lua;" .. package.path

-- Playdate's import runs a file once and returns nothing on later imports; mimic that so
-- specs fail the same way the device does when a module is imported twice.
local imported = {}
function import(name)
    if imported[name] then return nil end
    imported[name] = true
    return require(name)
end

playdate = {
    graphics = {
        kColorBlack = 0,
        kColorWhite = 1,
    },
}
