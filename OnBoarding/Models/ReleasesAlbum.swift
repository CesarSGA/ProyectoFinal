//
//  ReleasesAlbum.swift
//  OnBoarding
//
//

import Foundation

struct ReleasesAlbum: Codable {
    let id: Int?
    let year: Int?
    let resource_url: String?
    let uri: String?
    let artists_sort: String?
    let title: String?
    let country: String?
    let released: String?
    let genres: [String]?
    let tracklist: [Tracklist]
}
