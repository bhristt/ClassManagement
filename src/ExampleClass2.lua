local ManagedClass = require(workspace.ManagedClass)
local ExampleClass1 = require(workspace.ExampleClass1)

local ExampleClass2 = ManagedClass.new()
ExampleClass2:SetClassName("ExampleClass2")
ExampleClass2:Inherit(ExampleClass1)

ExampleClass2:Virtualize("VirtualFunction", function()
	print("This is the overidden version of ExampleClass1's virtual function!")
end)

return ExampleClass2