//
//  TrackModel.swift
//  Musixzam
//
//  Created by NAVEEN MADHAN on 1/19/22.
//

import Foundation
import SwiftUI

struct Track: Identifiable {
    var id = UUID().uuidString
    
    var title: String
    var artist: String
    var artwork: URL
    var genres: [String]
    var appleMusicURL: URL
}
