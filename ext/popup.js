chrome.tabs.query({currentWindow: true, active: true}, (tabs) => {
    var parser = document.createElement('a')
    parser.href = tabs[0].url
    Elm.Main.fullscreen({ hostname: parser.hostname })
})
