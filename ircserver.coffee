net = require 'net'
events = require 'events'
IRCParser = require './ircparser.coffee'

module.exports = class IRCServer extends events.EventEmitter
    parser: new IRCParser()
    server: null
    connection: null
    constructor: ->
        @server = net.createServer @onConnect
        @server.listen 6667, ->
            console.log 'Server listening on 6667'
    send: (command) =>
        if @connection
            @connection.write command + '\r\n', 'utf8', ->
                console.log 'Command sent:', command
    onConnect: (@connection) =>
        console.log "Connection!"
        @connection.on 'data', @onData

    onData: (data) =>
        linestring = data.toString().replace "\r", ""
        lines = linestring.split "\n"
        lines.pop()
        @forward line for line in lines
           
    forward: (line) =>
        message = @parser.parseMessage line
        if message
            @emit message.command, message 
            @emit 'message', message 
