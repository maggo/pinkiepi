IRCClient = require './ircclient'
IRCServer = require './ircserver'

client = new IRCClient
server = new IRCServer
#client.connect 6667, 'irc.freenode.net'

client.once 'NOTICE', ->
    client.send 'NICK Herpderp'
    client.send 'USER Herpderp 8 * :Test Bot'

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