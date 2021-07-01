//
//  ResultsArtist.swift
//  OnBoarding
//
//

import Foundation

struct ResultsArtist: Codable {
    let results: [Results]
}

struct Results: Codable {
    let id: Int?
    let type: String?
    let uri: String?
    let title: String?
    let thumb: String?
    let cover_image: String?
    let resource_url: String?
}
