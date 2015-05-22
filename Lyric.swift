//
//  Lyric.swift
//  karaoke
//
//  Created by Cryptoc1 on 5/20/15.
//  Copyright (c) 2015 Cryptocosm Developers. All rights reserved.
//

import Cocoa
import WebKit

// Our lyric class
class Lyric {
    let defaultURL: String = "http://azlyrics.com/yello/ohyeah.html"
    let templateURL: String = "http://azlyrics.com/lyrics/"
    var URL: String
    var lyrics: Array<String>?
    
    init(url: String, makeLyrics: Bool?) {
        self.URL = url
        if makeLyrics! {
            self.makeLyrics()
        } else if !makeLyrics! {
            if DEVMODE {
                NSLog("NOTICE: Initializing Lyric Object without building the lyrics array, that means you have to do it manually.")
            }
        }
    }
    
    // Gets the lyrics from AZLyrics, then formats them into an array of 
    // Don't call this to many times becuase AZLyrics doesn't allow scraping or "apis"
    func makeLyrics() {
        // Create the url
        let url = NSURL(string: self.getURL())
        
        // Make an HTTP Request and get the webpage
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            // Make the HTML into a String to make it easier to extract the lyrics
            var dataAsString = NSString(data: data!, encoding: NSUTF8StringEncoding)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // Get indexes of comments
            let startIndex: String.Index = dataAsString.rangeOfString("<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->")!.endIndex
            let endIndex: String.Index = dataAsString.rangeOfString("<!-- MxM banner -->")!.startIndex
            
            // Extract the lyrics from in-between the comments located above
            var lyricsUf = dataAsString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Remove HTML and Carriage Returns, but preserve the Newlines for splitting
            lyricsUf = lyricsUf.stringByReplacingOccurrencesOfString("<br>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            lyricsUf = lyricsUf.stringByReplacingOccurrencesOfString("</div>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            lyricsUf = lyricsUf.stringByReplacingOccurrencesOfString("\r", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            var lyricArray = lyricsUf.componentsSeparatedByString("\n")
            var stanzas: Array = [String]()
            
            // Cleanup the array
            for i in lyricArray {
                if i != "" {
                    stanzas.append(i)
                }
            }

            // Update the lyrics property
            self.setLyrics(stanzas)
            
            if DEVMODE {
                NSLog("Async operation occured, must use Lyric.getLyrics() to get the lyrics Array")
            }
        }
        task.resume()
    }
    
    func buildURLFromTemplate(urlPart: String) -> String {
        return self.templateURL + urlPart;
    }
    
    func getURL() -> String {
        return self.URL
    }
    
    func setURL(url: String, updateLyrics: Bool?) -> Bool {
        var ret: Bool = Bool()
        // Make sure the URL String contains the the proper protocol
        if !url.contains("http://") || !url.contains("https://") {
            NSLog("Must declare HTTP or HTTPS protocol in URL String")
            ret = false
        } else {
            self.URL = url
            ret = true
        }
        
        // User wants to rebuild lyrics Array
        if updateLyrics! {
            self.makeLyrics()
        }
        
        // Return if successful
        return ret
    }
    
    func getLyrics() -> Array<String> {
        return self.lyrics!
    }
    
    // Doesn't necessarily get called outside of Lyric.MakeLyrics()
    func setLyrics(lyricArray: Array<String>) {
        self.lyrics = lyricArray
    }
    
    func getDefaultURL() -> String {
        return self.defaultURL
    }
    
    func getTemplateURL() -> String {
        return self.templateURL
    }
}

// Some extensions to the String Class
extension String {
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}