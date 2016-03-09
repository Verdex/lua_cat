

vm_obj_tag = {
    word = "VM word type",
    number = "VM number type",
    string = "VM string type",
    bool = "VM bool type",
    primitive_word = "VM primitive word type",
}

local function copy( self )
    return create_vm_obj( self.tag, self.value )
end


function create_vm_obj( t, v )
    return { tag = t, value = v, copy = copy }
end
