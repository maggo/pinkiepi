net = require 'net'
events = require 'events'
IRCParser = require './ircparser'

module.exports = class IRCClient extends events.EventEmitter
    connection: null
    connect: (@port, @host, callback) ->
        if typeof(port) is String 
            @host = port
            @port = 6667
            callback = host

        @connection = net.connect port, host, =>
            console.log 'Connected'
            @connection.setEncoding 'utf8'
            @connection.on 'data', (data) =>
                @rawMessage data
            if callback then callback()

    send: (command) ->
        @connection.write command + '\r\n', 'utf8', ->
            console.log 'Command sent:', command
    rawMessage: (data) ->
        #console.log 'RawMessage:', data.toString()
        lines = data.toString().split '\r\n'
        lines.pop()
        for line in lines
            parser = new IRCParser()
            message = parser.parseMessage line
            if message?
                @emit message.command, message 
                @emit 'message', message 