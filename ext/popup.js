chrome.tabs.query({currentWindow: true, active: true}, (tabs) => {
    var parser = document.createElement('a')
    parser.href = tabs[0].url
    var app = Elm.Main.fullscreen({ hostname: parser.hostname })

    app.ports.kdbxRequest.subscribe((req) => {
        console.log(req)
    })
})
