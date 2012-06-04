net = require 'net'
events = require 'events'

module.exports = class IRCServer extends events.EventEmitter
    connection: null
    constructor: ->
        @connection = net.createServer {}, @onConnect
        @connection.listen 6667, ->
            console.log 'Server listening on 6667'

    onConnect: (connection) ->
        connection.on 'data', @onData

    onData: (data) ->
        lines = data.toString().split '\r\n'
        lines.pop()
        for line in lines
            parser = new IRCParser()
            message = parser.parseMessage line
            if message?
                @emit message.command, message 
                @emit 'message', message 