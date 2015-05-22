//
//  ViewController.swift
//  karaoke
//
//  Created by Cryptoc1 on 5/20/15.
//  Copyright (c) 2015 Cryptocosm Developers. All rights reserved.
//

import Cocoa
import AppKit

// Setting to true enables logging in a some functions and what-not
var DEVMODE: Bool = false

class ViewController: NSViewController, NSSpeechRecognizerDelegate {
    
    // Class-scope globals
    let sr:NSSpeechRecognizer = NSSpeechRecognizer()
    let lyrics: Lyric = Lyric(url: "http://azlyrics.com/lyrics/yello/ohyeah.html", makeLyrics: false)
    var currentCommandIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init SpeechRecognition
        sr.delegate = self
        sr.commands = []
        
        // Build the lyrics. I do it here so that the app inits without having to wait for the Lyric class-global declaration
        lyrics.makeLyrics()
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func Listen(sender: AnyObject) {
        sr.startListening()
        println("Listening...")
        
        if URLTextField.stringValue != "" {
            lyrics.setURL(lyrics.buildURLFromTemplate(URLTextField.stringValue), updateLyrics: true)
            if DEVMODE {
                NSLog("setURL to: \(lyrics.buildURLFromTemplate(URLTextField.stringValue))")
            }
        } else {
            if DEVMODE {
                NSLog("No URL submitted, using the default of: \(lyrics.getDefaultURL())")
            }
        }
        
        self.setCommand(lyrics.getLyrics(), commandIndex: currentCommandIndex)
        if DEVMODE {
            NSLog("lyrics.getLyrics().count: \(lyrics.getLyrics().count)")
        }
    }
    
    @IBAction func Stop(sender: AnyObject) {
        sr.stopListening()
        println("Done Listening...")
    }
    
    func speechRecognizer(sender: NSSpeechRecognizer, didRecognizeCommand command: AnyObject?) {
        if (command as! String == lyrics.getLyrics()[currentCommandIndex - 1]) {
            // Sets the next command to be recognized, then increments currentCommandIndex by 1
            self.setCommand(lyrics.getLyrics(), commandIndex: currentCommandIndex)
            if DEVMODE {
                NSLog("Correct stanza was inputted")
            }
        }
    }
    
    func setCommand(commands: Array<String>, commandIndex: Int) {
        if commandIndex == lyrics.getLyrics().count {
            sr.commands = []
            lyricsTextFieldCell.title = "You finished the song, congrats!"
            self.Stop(self)
        } else {
            sr.commands = [commands[commandIndex]]
            lyricsTextFieldCell.title = commands[commandIndex]
            currentCommandIndex++
        }
        if DEVMODE {
            NSLog("Updated sr.commands to: \"\(sr.commands!)\"")
            NSLog("currentCommandIndex: \(currentCommandIndex)")
        }
    }
    
    @IBOutlet weak var lyricsTextFieldCell: NSTextFieldCell!
    @IBOutlet weak var URLTextField: NSTextField!
}