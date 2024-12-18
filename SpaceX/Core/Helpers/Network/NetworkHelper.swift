//
//  NetworkLayer.swift
//  SpaceX
//
//  Created by serhat yaroglu on 17.12.2024.
//

import Foundation

enum NetworkError: Error {
    case unableToCompleteError
    case invalidResponse
    case invalidData
    case authError
    case unknownError
    case decodingError
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol NetworkEndpointDelegate {
    var baseURL: String { get }
    var method: HTTPMethod { get }
}

enum NetworkEndPoint {
    case upcoming
    case past
   case query
}

extension NetworkEndPoint: NetworkEndpointDelegate {
    var baseURL: String {
        switch self {
        case .upcoming:
            return  "https://api.spacexdata.com/v5/launches/upcoming"
        case .past:
            return"https://api.spacexdata.com/v5/launches/past"
       case .query:
            return "https://api.spacexdata.com/v5/launches/query"

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .upcoming, .past, .query:
                .get
        }
    }
    
    
    func request() -> URLRequest {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
