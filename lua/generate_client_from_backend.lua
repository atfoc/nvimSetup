local M = {}

---@class ClassQueryCapture
---@field class_name TSNode?
---@field type_name TSNode?
---@field field_name TSNode?
---@field generic_type TSNode?
---@field generic_type_argument TSNode?
local ClassQueryCapture = {}
ClassQueryCapture.__index = ClassQueryCapture

---@return ClassQueryCapture
function ClassQueryCapture.new()
    ---@type ClassQueryCapture
    local self = {
    }
    setmetatable(self, ClassQueryCapture)

    return self
end

---@class ClassField
---@field field_name string
---@field field_type string?
---@field generic_type string?
---@field generic_type_argument string?
local ClassField = {}
ClassField.__index = ClassField

---@return ClassField
function ClassField.new()
    ---@type ClassField
    local self = {
        field_name = "",
        field_type = nil,
        generic_type = nil,
        generic_type_argument = nil,
    }

    setmetatable(self, ClassField)

    return self
end

---@param field_type string
---@param field_name string
function ClassField:set_field(field_type, field_name)
    self.field_type = field_type
    self.field_name = field_name
    self.generic_type_argument = nil
    self.generic_type = nil
end

---@param generic_type string
---@param generic_type_argument string
---@param field_name string
function ClassField:set_generic_field(generic_type, generic_type_argument, field_name)
    self.filed_type = nil
    self.field_name = field_name
    self.generic_type_argument = generic_type_argument
    self.generic_type = generic_type
end

---@return string type, string name, boolean ok
function ClassField:get_field()
    if self.field_name ~= "" and self.field_type ~= nil then
        return self.field_type, self.field_name, true
    end

    return "", "", false
end

---@return string type, string type_argument, string name, boolean ok
function ClassField:get_generic_field()
    if self.field_name ~= "" and self.generic_type ~= nil and self.generic_type_argument ~= nil then
        return self.generic_type, self.generic_type_argument, self.field_name, true
    end

    return "", "", "", false
end

---@class ClassInfo
---@field name string
---@field fields ClassField[]
local ClassInfo = {}
ClassInfo.__index = ClassInfo

---@return ClassInfo
function ClassInfo.new()
    ---@type ClassInfo
    local self = { name = "", fields = {} }
    setmetatable(self, ClassInfo)
    return self
end

---@class CodeGenerator
---@field buffer string[]
---@field current_indent integer
---@field at_begining_of_line boolean
local CodeGenerator = {}
CodeGenerator.__index = CodeGenerator

---@return CodeGenerator
function CodeGenerator.new()
    ---@type CodeGenerator
    local self = {
        buffer = {},
        current_indent = 0,
        at_begining_of_line = true,
    }
    setmetatable(self, CodeGenerator)

    return self
end

---@return string
function CodeGenerator:generate()
    return table.concat(self.buffer)
end

---@param value string
---@return CodeGenerator
function CodeGenerator:put(value)
    if self.at_begining_of_line then
        if self.current_indent > 0 then
            local indent = string.rep("\t", self.current_indent)
            table.insert(self.buffer, indent)
        elseif self.current_indent < 0 then
            error("CodeGenerator indent has to be a positive number")
        end
        self.at_begining_of_line = false
    end

    table.insert(self.buffer, value)
    return self
end

---@return CodeGenerator
function CodeGenerator:new_line()
    table.insert(self.buffer, "\n")
    self.at_begining_of_line = true
    return self
end

---@param amount integer?
---@return CodeGenerator
function CodeGenerator:indent(amount)
    local actual_amount = amount or 1
    if actual_amount <= 0 then
        error("CodeGenerator indent has to be a positive number")
    end

    self.current_indent = self.current_indent + actual_amount
    return self
end

---@param amount integer?
---@return CodeGenerator
function CodeGenerator:outdent(amount)
    local actual_amount = amount or 1
    if actual_amount <= 0 then
        error("CodeGenerator outdent has to be a positive number")
    end

    self.current_indent = self.current_indent - actual_amount
    if self.current_indent < 0 then
        error("CodeGenerator indent can not go bellow 0, too much outdent")
    end

    return self
end

---@param captures ClassQueryCapture[]
---@return ClassInfo, string?
local function create_class_info_from_caputre(captures)
    local info = ClassInfo.new()

    for _, capture in ipairs(captures) do
        if info.name == "" then
            info.name = vim.treesitter.get_node_text(capture.class_name, 0)
        end

        if capture.type_name ~= nil and capture.field_name ~= nil then
            local classField = ClassField.new()
            classField:set_field(vim.treesitter.get_node_text(capture.type_name, 0),
                vim.treesitter.get_node_text(capture.field_name, 0))
            table.insert(info.fields, classField)
        elseif capture.generic_type ~= nil and capture.generic_type_argument ~= nil and capture.field_name ~= nil then
            local classField = ClassField.new()
            classField:set_generic_field(vim.treesitter.get_node_text(capture.generic_type, 0),
                vim.treesitter.get_node_text(capture.generic_type_argument, 0),
                vim.treesitter.get_node_text(capture.field_name, 0))
            table.insert(info.fields, classField)
        else
            return info, "failed to extract all data unknown field type"
        end
    end

    return info, nil
end

--- @param class_name string
--- @return ClassInfo, string?
local function java_class_info(class_name)
    local query_string = string.format([[
(class_declaration
            name: (identifier) @className
            (#eq? @className "%s")
            body: (class_body
                (field_declaration
                    type: [
                            ((type_identifier) @typeName)
                            (generic_type
                              (type_identifier) @genericType
                              (type_arguments (type_identifier) @genericTypeArgument))

                          ]
                    declarator: (
                                 variable_declarator
                                 name: (identifier) @fieldName
                                 ))))
            ]], class_name)

    local query = vim.treesitter.query.parse("java", query_string)
    local parser = vim.treesitter.get_parser(0, "java")
    if parser == nil then
        return {}, "failed to parse current buffer"
    end

    local tree = parser:parse()[1]
    local root_node = tree:root()

    ---@type ClassQueryCapture[]
    local captured_from_query = {}

    for _, match in query:iter_matches(root_node, 0) do
        local captured = ClassQueryCapture.new()
        for id, nodes in pairs(match) do
            if query.captures[id] == "className" then
                captured.class_name = nodes[1]
            end

            if query.captures[id] == "typeName" then
                captured.type_name = nodes[1]
            end

            if query.captures[id] == "fieldName" then
                captured.field_name = nodes[1]
            end

            if query.captures[id] == "genericType" then
                captured.generic_type = nodes[1]
            end

            if query.captures[id] == "genericTypeArgument" then
                captured.generic_type_argument = nodes[1]
            end
        end
        table.insert(captured_from_query, captured)
    end


    local info, err = create_class_info_from_caputre(captured_from_query)
    if err ~= nil then
        return ClassInfo.new(), err
    end

    return info, nil
end


---@return string, string? error
local function convert_java_type_to_ts(type)
    if type == "String" then
        return "string", nil
    end

    if type == "int" or type == "short" or type == "long" or type == "Integer" or type == "Short" or type == "Long" then
        return "number", nil
    end

    if type == "double" or type == "Double" or type == "float" or type == "Float" then
        return "number", nil
    end

    if type == "boolean" or type == "Boolean" then
        return "boolean", nil
    end

    return "", "unknown type " .. type
end

---@param generator CodeGenerator
---@param info ClassInfo
---@param types_to_process table<string, boolean>
---@return string? err
local function generate_ts_interface_from_class(generator, info, types_to_process)
    generator:put("type ")
        :put(info.name):put(" = {"):new_line()
        :indent()

    for _, field in ipairs(info.fields) do
        local field_type, field_name, ok = field:get_field()
        if ok then
            generator:put(field_name):put(": ")
            local ts_type, err = convert_java_type_to_ts(field_type)
            if err ~= nil then
                generator:put(field_type):new_line()
                if types_to_process[field_type] == nil then
                    types_to_process[field_type] = false
                end
            else
                generator:put(ts_type):new_line()
            end
        end

        local type, type_argument, name, ok = field:get_generic_field()
        if ok then
            if type ~= "List" then
                return "only supported generic type is List got " .. type
            end

            generator:put(name):put(": ")
            local ts_type, err = convert_java_type_to_ts(type_argument)
            if err ~= nil then
                generator:put(type_argument):put("[]"):new_line()
                if types_to_process[type_argument] == nil then
                    types_to_process[type_argument] = false
                end
            else
                generator:put(ts_type):put("[]"):new_line()
            end
        end
    end

    generator:outdent()
        :put("}"):new_line()

    return nil
end

---@param generator CodeGenerator
---@param name string
---@return string? err
local function generate_ts_from_java_class_recursivly(generator, name)
    local types_to_process = {}
    types_to_process[name] = false

    while true do
        local to_process = nil
        for type, processed in pairs(types_to_process) do
            if processed ~= true then
                to_process = type
                break
            end
        end

        if to_process == nil then
            break
        end

        local info, err = java_class_info(to_process)
        if err ~= nil then
            return err
        end

        err = generate_ts_interface_from_class(generator, info, types_to_process)
        if err ~= nil then
            return err
        end

        types_to_process[to_process] = true
    end
end

function M.generate_ts_from_java()

    local generator = CodeGenerator.new()
    local err = generate_ts_from_java_class_recursivly(generator, "Response")
    if err ~= nil then
        vim.notify(err, vim.log.errors.ERROR)
        return
    end

    vim.print(generator:generate())
end

M:generate_ts_from_java()
return M
