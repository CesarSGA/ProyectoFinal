//
//  TagsCategory.swift
//  OnBoarding
//
//

import Foundation

struct TagsCategory: Codable {
    let tags: Tags
}

struct Tags: Codable {
    let tag: [Tag]
}

struct Tag: Codable {
    let name: String?
    let url: String
    let reach: String?
    let taggings: String?
    let streamable: String?
}
