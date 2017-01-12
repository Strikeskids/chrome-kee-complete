const Elm = require('../src/Main')

chrome.tabs.query({currentWindow: true, active: true}, (tabs) => {
    const parser = document.createElement('a')
    parser.href = tabs[0].url
    const app = Elm.Main.fullscreen({ hostname: parser.hostname })

    app.ports.kdbxRequest.subscribe((req) => {
        console.log(req)
    })
})
