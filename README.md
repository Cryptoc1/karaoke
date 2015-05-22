# karaoke
This is a *very* simple karaoke app for Mac.

## How?
The program compares lyrics from AZLyrics, and spoken word using NSSpeechRecognition. Though this works, "singing" may not be as easy as just speaking the text. For that
reason, I'll probably use this as a foundation to another app idea I have swirling around in my head (*"Stay tuned for more!"*). Regardless of it's effectiveness, I still
think that the concept is cool. 😎

# Notices
To get more verbose information from the program, set `DEVMODE` to `true` in `ViewController.swift`.
    
```swift

...

import Cocoa
import AppKit

// Setting to true enables logging in a some functions and what-not
var DEVMODE: Bool = false

class ViewController: NSViewController, 

...

```

The icon was provided by (Icons8)[Icons8.com]