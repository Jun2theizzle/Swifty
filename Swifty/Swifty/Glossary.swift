//
//  Artists.swift
//  Swifty
//
//  Created by Jun Cheng on 12/7/18.
//  Copyright © 2018 Jun Cheng. All rights reserved.
//

import UIKit
import Fuse

class Glossary {
    var artists: [Artist]
    
    init() {
        self.artists = []
        // let's hard code some artists
        self.artists.append(Artist.init("4B", ["Hardstyle" , "Trap"])!)
        self.artists.append(Artist.init("A-Trak", ["Electro House"])!)
        self.artists.append(Artist.init("AC Slater", ["Hardstyle" , "Trap"])!)
        self.artists.append(Artist.init("Rezz", ["Techno" , "Dubstep"])!)
        self.artists.append(Artist.init("Valentino Khan", ["Hardstyle"])!)
        self.artists.append(Artist.init("Gud Vibrations", ["Hardstyle" , "Dubstep"])!)
        self.artists.append(Artist.init("Habstrakt", ["Hardstyle"])!)
        
    }
    
    func findMatching(_ name: String) -> Artist? {
        let fuse = Fuse()
        var highestMatching: Double = 0.0
        var foundArtist: Artist? = nil
        for artist in self.artists {
            let result = fuse.search(name, in: artist.name)
            if let score = result?.score, score > highestMatching {

                foundArtist = artist
                highestMatching = score
            }

        }
        
        return foundArtist
    }
}
