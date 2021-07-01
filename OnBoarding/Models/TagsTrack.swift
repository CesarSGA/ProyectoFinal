//
//  TagsTrack.swift
//  OnBoarding
//
//

import Foundation

struct TagsTrack: Codable {
    let tracks: Tracks
}

struct Tracks: Codable {
    let track: [Track]
}

struct Track: Codable {
    let name: String
    let duration: String
    let url: String
    let artist: Artist
}
