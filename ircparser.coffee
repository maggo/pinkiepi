module.exports = class IRCParser
	parseMessage: (line, stripColors) ->
        message = {}
        message.rawLine = line

        if stripColors then line = line.replace /[\x02\x1f\x16\x0f]|\x03\d{0,2}(?:,\d{0,2})?/g, ""

        match = line.match /^:([^ ]+) +/
        if match?
            message.prefix = match[1]
            line = line.replace /^:[^ ]+ +/, ''
            if match = message.prefix.match /^([_a-zA-Z0-9\[\]\\`^{}|-]*)(!([^@]+)@(.*))?$/
                message.nick = match[1]
                message.user = match[3]
                message.host = match[4]
            else
                message.server = message.prefix

        match = line.match /^([^ ]+) */
        if match?
            message.command = match[1]
            message.rawCommand = match[1]
            message.commandType = 'normal'
            line = line.replace /^[^ ]+ +/, ''

        ###
        if replyFor[message.rawCommand]
            message.command     = replyFor[message.rawCommand].name
            message.commandType = replyFor[message.rawCommand].type
        ###
        message.args = []

        if line.indexOf ':' != -1
            index = line.indexOf ':'
            middle = line.substr(0, index).replace /( +)$/, ""
            trailing = line.substr index+1
        else
            middle = line;

        if middle.length
            message.args = middle.split /( +)/

        if typeof trailing != 'undefined' && trailing.length
            message.args.push trailing

        return message
	