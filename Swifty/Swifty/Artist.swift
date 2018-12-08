//
//  Artists.swift
//  Swifty
//
//  Created by Jun Cheng on 12/7/18.
//  Copyright © 2018 Jun Cheng. All rights reserved.
//

import UIKit

class Artist {
    var name: String
    var generes: [String]?
    
    init?(_ name: String, _ genres: [String]?) {
        if (name.isEmpty) {
            return nil
        }
        
        self.name = name
        self.generes = genres
    }
}
