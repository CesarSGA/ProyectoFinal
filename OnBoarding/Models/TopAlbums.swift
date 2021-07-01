//
//  TopAlbums.swift
//  OnBoarding
//
//

import Foundation

struct TopAlbums: Codable {
    let albums: Albums
}

struct Albums: Codable {
    let album: [Album]
}

struct Album: Codable {
    let name: String?
    let url: String
    let artist: Artist
}
