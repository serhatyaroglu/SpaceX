//
//  NetworkLayer.swift
//  SpaceX
//
//  Created by serhat yaroglu on 17.12.2024.
//

import Foundation


protocol NetworkProtocol {
    func getRequest(_ endpoint: NetworkEndPoint, completion: @escaping (Swift.Result<[Launch], NetworkError>) -> Void)
}

final class NetworkLayer: NetworkProtocol {
    
    static let shared = NetworkLayer()
    private init() {}
    
    func getRequest(_ endpoint: NetworkEndPoint, completion: @escaping (Swift.Result<[Launch], NetworkError>) -> Void) {
        NetworkManager.shared.request(endpoint, completion: completion)
    }
}
