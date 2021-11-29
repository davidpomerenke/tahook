const { uniqueNamesGenerator, adjectives, animals } = require('unique-names-generator')

const name = uniqueNamesGenerator({ dictionaries: [adjectives, animals] })
    .replace(/_/g, ' ')
var app = Elm.Main.init({
    node: document.getElementById('myapp'),
    flags: name
})
// const peerConfig = {
//     host: 'tahook.ew.r.appspot.com',
//     secure: true,
//     port: 9000,
//     path: '/'
// }
const namespace = 'tahook '
const connect = name => {
    var connections = {}
    // console.log(name)
    const self = new Peer(namespace + name)
    self.on('open', id => {
        // console.log('connection opened')
        self.on('connection', conn => {
            // console.log('on connection')
            const other = conn.peer.replace(namespace, '')
            connections[other] = conn
            conn.on('data', data => {
                console.log('received', other, data)
                app.ports.fromPeer.send({ peer: other, value: data })
            })
        })
    })
    self.on('error', e => console.warn('PeerJS error', e.type))
    app.ports.toPeer.subscribe(({ peer, value }) => {
        console.log('sending to', peer, value)
        if (peer === name) {
            console.log('sending to self', value)
            app.ports.fromPeer.send({ peer: peer, value: value })
        } else if (peer in connections) {
            // console.log('sending with old conn')
            connections[peer].send(value)
        }
        else {
            const conn = self.connect(namespace + peer)
            connections[peer] = conn
            conn.on('open', () => {
                // console.log('sending with new conn', peer, value)
                conn.send(value)
            })
            conn.on('data', data => {
                console.log('received (2)', peer, data)
                app.ports.fromPeer.send({ peer: peer, value: data })
            })
        }
    })
    window.onbeforeunload = () => {
        for (conn of Object.values(connections)) {
            conn.send(['Types.Disconnected'])
        }
        self.disconnect()
    }
}
connect(name)
app.ports.setName.subscribe(() => {
    connect(name)
})
app.ports.scrollDown.subscribe(() => {
    console.log('scroll')
    setTimeout(() => {
        const chat = document.getElementById('chat')
        if (chat) chat.scrollTo({ top: chat.scrollHeight, behavior: 'smooth' })
    }, 100)
})