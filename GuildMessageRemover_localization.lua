local addonName, L = ...;
local function localizationFallback(L, key)
 return key;
end
setmetatable(L, {__index=localizationFallback});