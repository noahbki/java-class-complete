
class JavaTemplate

    constructor: ->
        @tabString = "\t"

    generateClass: (classdef) ->
        buffer = ""
        buffer += "public class #{classdef.fullname}"
        buffer += " extends #{classdef.extends}" if classdef.extends
        buffer += " {\n"

        buffer += @indent(@generateMethod(classdef.name, null, classdef.parameters, "members", {}), 1)
        buffer += @indent(@generateMethod(classdef.name, null, classdef.parameters, "constructor", {
            "before": "super(" if classdef.extends
        }), 1)

        if classdef.methods.length > 0
            for method in [0..classdef.methods.length - 1]

                method = classdef.methods[method]
                buffer += @indent(@generateMethod(classdef.name, method.name, method.parameters, method.type), 1)

        buffer += "}"

        buffer

    generateMethod: (className, method, parameters, type = "member", body = {}, classdef) ->
        buffer = ""
        if type == "static"
            buffer += "public static void #{method}("
        else if type == "method"
            buffer += "public void #{method}("
        else if type == "constructor"
            # buffer += "\n"
            buffer += "public #{className}("
        else if type == "members"
            for param in [0..parameters.length - 1]
                parameter = parameters[param]
                if parameter
	                if parameter.member
	                    if parameter.type is null
	                        parameter.type = "int"
	                    buffer += "\npublic #{parameter.type} #{parameter.name};"
            buffer += "\n"
            return buffer


        if parameters.length > 0
            for param in [0..parameters.length - 1]
                parameter = parameters[param]
                if param == parameters.length - 1
                    if parameter.type is null
                        parameter.type = "int"
                    buffer += parameter.type + " "
                    buffer += (parameters[parameters.length - 1].name + ") {\n")
                else
                    if parameter.type is null
                        parameter.type = "int"
                    buffer += parameter.type + " "
                    buffer += parameters[param].name + ", "
        else
            buffer += ") {\n"

        if body.before
            if parameters.length > 0
                for param in [0..parameters.length - 1]
                    if param == parameters.length - 1
                        body.before += parameters[parameters.length - 1].name + ");"
                    else
                        body.before += parameters[param].name + ", "
            buffer += "#{@indent(body.before, 1)}"

        checks = false
        members = false

        if parameters.length > 0
            buffer += "\n" if body.before
            for param in [0..parameters.length - 1]
                param = parameters[param]

                if param.member
                    members = true

        if parameters.length > 0 && members
            buffer += "\n" if checks
            for param in [0..parameters.length - 1]
                param = parameters[param]
                if param.member
                    buffer += "#{@tabString}this.#{param.name} = #{param.name};\n"

        if body.after
            buffer += "\n" if checks || members
            buffer += "#{@indent(body.after, 1)}"

        buffer += "}\n"
        return buffer

    indent: (text, indent) ->
        buffer = ""
        lines = text.split(/\n|\r\n/)

        prefix = ""
        prefix += "#{@tabString}" for i in [0..indent - 1]

        for line in lines
            buffer += prefix + line + "\n"

        return buffer

module.exports = new JavaTemplate
