//
//  ReleasesArtist.swift
//  OnBoarding
//
//

import Foundation

struct ReleasesArtist: Codable {
    let releases: [Releases]
}

struct Releases: Codable {
    let id: Int?
    let status: String?
    let type: String?
    let format: String?
    let label: String?
    let title: String?
    let resource_url: String?
    let role: String?
    let artist: String?
    let year: Int?
}
