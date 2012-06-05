IRCClient = require './ircclient'
IRCServer = require './ircserver'

client = new IRCClient
server = new IRCServer

console.log "Connecting to server..."
client.connect 6667, 'irc.canternet.org', ->
    console.log "Connected"

server.on 'message', (m) ->
    console.log "Message from Client:", m
    client.send m.rawLine

client.on 'message', (m) ->
    console.log "Message from Server:", m
    server.send m.rawLine

###
client.on 'NOTICE', (msg) ->
    console.log 'Notice:', msg.args.join()

    if msg.args[0] is 'Auth'
        client.emit 'connect'

client.on 'PING', ->
    client.send 'PING'

client.on 'ERROR', (msg) ->
    console.log 'Error:', msg.args.join()

client.on 'message', (msg) ->
    if msg.command isnt 'NOTICE'
        console.log 'Command received:', msg.command

client.on 'connect', ->
    console.log 'CONNECTED'