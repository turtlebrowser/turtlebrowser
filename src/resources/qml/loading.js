// Review
function process(loadRequest) {
    console.log("Loading changed for request url : " + loadRequest.url);

    switch(loadRequest.status) {
    case WebEngineView.LoadStartedStatus: {
        console.log("status STARTED");
        break;
    }
    case WebEngineView.LoadStoppedStatus: {
        console.log("status STOPPED");
        break;
    }
    case WebEngineView.LoadSucceededStatus: {
        console.log("status SUCCEEDED");
        break;
    }
    case WebEngineView.LoadFailedStatus: {
        console.log("status FAILED");
        console.log("errorCode   : " + loadRequest.errorCode);
        console.log("errorString : " + loadRequest.errorString);

        switch (loadRequest.errorDomain) {
        case WebEngineView.NoErrorDomain : {
            console.log("Error Domain NONE");
            break;
        }
        case WebEngineView.InternalErrorDomain : {
            console.log("Error Domain INTERNAL");
            break;
        }
        case WebEngineView.ConnectionErrorDomain : {
            console.log("Error Domain CONNECTION");
            break;
        }
        case WebEngineView.CertificateErrorDomain : {
            console.log("Error Domain CERTIFICATE");
            break;
        }
        case WebEngineView.HttpErrorDomain : {
            console.log("Error Domain HTTP");
            break;
        }
        case WebEngineView.FtpErrorDomain : {
            console.log("Error Domain FTP");
            break;
        }
        case WebEngineView.DnsErrorDomain : {
            console.log("Error Domain DNS");
            break;
        }
        }
        break;
    }
    }
}
