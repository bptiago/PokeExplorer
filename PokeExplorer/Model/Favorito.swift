//
//  Favorito.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 12/06/25.
//

import Foundation
import SwiftData

@Model
class Favorito {
    
    @Attribute(.unique) var id: Int
    var name: String
    var url: String
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
