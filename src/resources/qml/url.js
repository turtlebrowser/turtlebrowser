// Review
var defaultPrefix = "https://"

function searchUrl(terms) {
    return "https://www.google.com/search?q=" + encodeURI(terms);
}

function hasWhiteSpace(s) {
    return /\s/g.test(s);
}

function hasPeriod(s) {
    return /\./.test(s);
}

function isChromeUrl(s) {
    return /^(chrome:\/\/)/.test(s);
}

function hasProtocol(s) {
    return /^(https?|ftp|chrome)/.test(s);
}

function construct(typedText){
    if (hasWhiteSpace(typedText) || (!hasPeriod(typedText) && !isChromeUrl(typedText))) {
        return searchUrl(typedText);
    } else if (!hasProtocol(typedText) && !isChromeUrl(typedText)) {
        return defaultPrefix + typedText;
    } else {
        return typedText;
    }
}
