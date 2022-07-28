local ManagedClass = require(workspace.ManagedClass)
local ExampleClass1 = ManagedClass.new()
ExampleClass1:SetClassName("ExampleClass1")

function ExampleClass1:ExampleFunction()
    print("Hello!")
end

function ExampleClass1:VirtualFunction()
    print("This is a function that should never be called because it's a virtual function!")
end

print(ExampleClass1.PublicFunctions)

return ExampleClass1