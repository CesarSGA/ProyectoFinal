//
//  MasterAlbum.swift
//  OnBoarding
//
//

import Foundation

struct MasterAlbum: Codable {
    let id: Int?
    let main_release: Int?
    let most_recent_release: Int?
    let resource_url: String?
    let uri: String?
    let versions_url: String?
    let main_release_url: String?
    let most_recent_release_url: String?
    let num_for_sale: Int?
    let year: Int?
    let title: String?
    let tracklist: [Tracklist]
    let genres: [String]?
}
