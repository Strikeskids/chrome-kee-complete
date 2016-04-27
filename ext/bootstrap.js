chrome.runtime.onInstalled.addListener(setup)

function setup() {
    const passwordFieldRule = {
        conditions: [
            new chrome.declarativeContent.PageStateMatcher({
                css: ['input[type="password"]'],
            }),
        ],
        actions: [
            new chrome.declarativeContent.ShowPageAction(),
        ],
    }

    chrome.declarativeContent.onPageChanged.removeRules(undefined, function() {
        chrome.declarativeContent.onPageChanged.addRules([passwordFieldRule])
    })
}
