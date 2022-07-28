--// written by bhristt July 25, 2022


--[[
ManagedClass API:

ManagedClass is meant to be used as a base class to all other classes.
ManagedClass' main goal is to make it easier to implement OOP in Roblox
game development. ManagedClass makes it easy to create classes that inherit
multiple other classes. A ManagedClass instance can inherit other classes regardless
of whether those inherited classes are ManagedClass instances.

Creating a ManagedClass instance:
```
local ManagedClass = require(script.ManagedClass)
local newClass = ManagedClass.new()
```


ManagedClass Attributes:
///////////////////////////////////////////////////////////////////
ManagedClass.Inheriting
ManagedClass.OperatorFunctions
ManagedClass.PublicAttributes
ManagedClass.PublicFunctions
ManagedClass.VirtualFunctions
///////////////////////////////////////////////////////////////////


ManagedClass Functions:
///////////////////////////////////////////////////////////////////
ManagedClass:SetClassName(className: string)
ManagedClass:Inherit(...: class)
ManagedClass:Virtualize(index: string, func: (...any) -> any)
ManagedClass:Print()
///////////////////////////////////////////////////////////////////



]]



--// services



--// modules



--// declarations



--// constants
local MANAGED_CLASS_PROPERTIES = {
    CLASS_NAME = "ClassName",
    INHERITING = "Inheriting",
    OPERATOR_FUNCTIONS = "OperatorFunctions",
    PUBLIC_ATTRIBUTES = "PublicAttributes",
    PUBLIC_FUNCTIONS = "PublicFunctions",
    VIRTUAL_FUNCTIONS = "VirtualFunctions",
}
local MANAGED_CLASS_TYPE = "ManagedClass"



--// ManagedClass
local ManagedClass = {
    __type = MANAGED_CLASS_TYPE
}
local MCF = {}



--// ManagedClass metamethods
MCF.__index = function(self, index)
    --[[
    Priority list:
        1. Virtual Functions
        2. Inheriting Class(es) Properties
        3. ManagedClass Properties
        4. Public Attributes
        5. Public Functions
        6. Raw ManagedClass Table Properties
    ]]
    local inheriting = rawget(self, MANAGED_CLASS_PROPERTIES.INHERITING)
    local publicAttributes = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_ATTRIBUTES)
    local publicFunc = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_FUNCTIONS)
    local virtualFunc = rawget(self, MANAGED_CLASS_PROPERTIES.VIRTUAL_FUNCTIONS)
    local v
    v = virtualFunc[index]
    if v ~= nil then
        return v
    end
    for _, c in ipairs(inheriting) do
        v = c[index]
        if v ~= nil then
            break
        end
    end
    if v ~= nil then
        return v
    end
    v = ManagedClass[index] or publicAttributes[index] or publicFunc[index]
    if v ~= nil then
        return v
    end
    return rawget(self, index)
end



local MCF_NEW_INDEX_VALID_TYPES_FUNC = {
    --// for all functions
    --// intended for public functions
    ["function"] = function(self, index, value)
        local publicFunctions = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_FUNCTIONS)
        if publicFunctions[index] ~= nil then
            return
        end
        publicFunctions[index] = value
    end,

    --// for all other types, should add to public attributes
    --// intended for attributes, properties, changing values, etc
    OTHER = function(self, index, value)
        local publicAttributes = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_ATTRIBUTES)
        publicAttributes[index] = value
    end
}
MCF.__newindex = function(self, index, value)
    local indexFunc = MCF_NEW_INDEX_VALID_TYPES_FUNC[typeof(value)]
    if indexFunc ~= nil then
        indexFunc(self, index, value)
    else
        MCF_NEW_INDEX_VALID_TYPES_FUNC.OTHER(self, index, value)
    end
end



MCF.__tostring = function(self)
    local className = rawget(self, MANAGED_CLASS_PROPERTIES.CLASS_NAME)
    local inheriting = rawget(self, MANAGED_CLASS_PROPERTIES.INHERITING)
    local publicAttributes = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_ATTRIBUTES)
    local publicFunc = rawget(self, MANAGED_CLASS_PROPERTIES.PUBLIC_FUNCTIONS)
    local virtualFunc = rawget(self, MANAGED_CLASS_PROPERTIES.VIRTUAL_FUNCTIONS)
    local pstr, fstr = "", ""
    local i = 1
    fstr = fstr .. string.format("%s [%s]", className, MANAGED_CLASS_TYPE)
    if #inheriting > 0 then
        fstr = fstr .. "[Inheriting]:\n"
        for _, c in ipairs(inheriting) do
            pstr = string.format("\t%d. %s\n", i, c.ClassName or c.__type or tostring(c))
            fstr = fstr .. pstr
        end
    else
        fstr = fstr .. "[Inheriting]:\n\tNone\n"
    end
    if #publicAttributes > 0 then
        fstr = fstr .. "[Attributes]:\n"
        for a, v in pairs(publicAttributes) do
            pstr = string.format("\t%s: %s [%s]\n", a, tostring(v), typeof(v))
            fstr = fstr .. pstr
        end
    else
        fstr = fstr .. "[Attributes]:\n\tNone\n"
    end
    if #publicFunc + #virtualFunc > 0 then
        fstr = fstr .. "[Functions]:"
        for n, _ in pairs(publicFunc) do
            pstr = string.format("\n\tpublic [%s]", n)
            fstr = fstr .. pstr
        end
        for n, _ in pairs(virtualFunc) do
            pstr = string.format("\n\tvirtual [%s]", n)
            fstr = fstr .. pstr
        end
    else
        fstr = fstr .. "[Functions]:\n\tNone"
    end
    return fstr
end



--// ManagedClass constructor
--// parameters to this constructor are classes that
--// the new ManagedClass instance will inherit
function ManagedClass.new(...)
    local self = setmetatable({}, MCF)
    rawset(self, MANAGED_CLASS_PROPERTIES.CLASS_NAME, "NewManagedClass")
    rawset(self, MANAGED_CLASS_PROPERTIES.INHERITING, {})
    rawset(self, MANAGED_CLASS_PROPERTIES.OPERATOR_FUNCTIONS, {})
    rawset(self, MANAGED_CLASS_PROPERTIES.PUBLIC_ATTRIBUTES, {})
    rawset(self, MANAGED_CLASS_PROPERTIES.PUBLIC_FUNCTIONS, {})
    rawset(self, MANAGED_CLASS_PROPERTIES.VIRTUAL_FUNCTIONS, {})
    self:Inherit(...)
    return self
end



--// ManagedClass functions
function ManagedClass:SetClassName(className)
    rawset(self, MANAGED_CLASS_PROPERTIES.CLASS_NAME, className)
end



function ManagedClass:Inherit(...)
    local inheriting = rawget(self, MANAGED_CLASS_PROPERTIES.INHERITING)
    local classes = {...}
    for _, class in pairs(classes) do
        table.insert(inheriting, class)
    end
end



function ManagedClass:Virtualize(index, func)
    local virtualFunc = rawget(self, MANAGED_CLASS_PROPERTIES.VIRTUAL_FUNCTIONS)
    if virtualFunc[index] == nil then
        virtualFunc[index] = func
    end
end



function ManagedClass:Print()
    local str = tostring(self)
    print(str)
end



--// return ManagedClass
return ManagedClass