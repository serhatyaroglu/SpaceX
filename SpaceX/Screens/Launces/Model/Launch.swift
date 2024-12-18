//
//  SpaceX.swift
//  SpaceX
//
//  Created by serhat yaroglu on 17.12.2024.
//
import UIKit

struct Launch: Codable {
    let name: String
    let dateUtc: String
    let rocket: String
    let upcoming: Bool
    let flightNumber: Int?
    let links: Links?
    let datePrecision: String?
    let cores: [Core]?
    
    enum CodingKeys: String, CodingKey {
        case  links, rocket
        case flightNumber = "flight_number"
        case name
        case dateUtc = "date_utc"
        case datePrecision = "date_precision"
        case upcoming
        case cores
    }
    
    struct Links: Codable {
        let patch: Patch?
        let reddit: Reddit?
        let flickr: Flickr?
        let presskit: String?
        let webcast: String?
        let youtubeId: String?
        let article: String?
        let wikipedia: String?
    }
    
    struct Patch: Codable {
        let small: String?
        let large: String?
    }
    
    struct Reddit: Codable {
        let campaign: String?
        let launch: String?
        let media: String?
        let recovery: String?
    }
    
    struct Flickr: Codable {
        let small: [String]?
        let original: [String]?
    }
    
    struct Core: Codable {
        let core: String?
        let flight: Int?
        let gridfins: Bool?
        let legs: Bool?
        let reused: Bool?
        let landingAttempt: Bool?
        let landingSuccess: Bool?
        let landingType: String?
        let landpad: String?
    }
}
