

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# KireiWebView


Simple and Clean design WebViewController.


![ScreenShot](https://raw.githubusercontent.com/entotsu/KireiWebView/master/ScreenShot.png)

# Simple usage

```
let url = "http://google.com"
let kireiWebView = KireiWebViewController(url: url)
self.presentViewController(kireiWebView, animated: true, completion: nil)
```


# Custom parameter
```
kireiWebView.showFooter = false

kireiWebView.enablePcUserAgent = true

kireiWebView.enableOpenInSafari = true

kireiWebView.openInSafariText = "Safariでみる"

kireiWebView.shareButtonAction = { url, title in
    yourShareView.open(url, title)
}
```

# Creator

Developer [@tk_365](https://twitter.com/tk_365)

Designer [@mackymakiosh](https://www.behance.net/mcky_mnml)
