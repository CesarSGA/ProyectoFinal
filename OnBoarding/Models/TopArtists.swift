//
//  TopArtists.swift
//  OnBoarding
//
//

import Foundation

struct TopArtist: Codable {
    let artists: Artists
}

struct Artists: Codable {
    let artist: [Artist]
}

struct Artist: Codable {
    let name: String
    let url: String
    let listeners: String!
    let playcount: String!
}
