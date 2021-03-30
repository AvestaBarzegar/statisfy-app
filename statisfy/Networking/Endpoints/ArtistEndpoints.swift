//
//  ArtistEndpoints.swift
//  statisfy
//
//  Created by Avesta Barzegar on 2021-03-30.
//

import Foundation

struct ArtistLongEndpoint: Endpoint {
    
    var scheme: Scheme.RawValue = Scheme.https.rawValue
    
    var baseURL: String = "api.spotify.com"
    
    var path: String = "/v1/me/top/artists"
    
    var pathParameters: String?
    
    var parameters: [URLQueryItem]? = [
        URLQueryItem(name: "time_range", value: "long_term"),
        URLQueryItem(name: "limit", value: "50"),
        URLQueryItem(name: "offset", value: "0")
    
    ]
    
    var method: Methods.RawValue? = Methods.get.rawValue
    
    static let shared =  ArtistShortEndpoint()
    
    func urlBuilder() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = parameters
        let url = components.url
        return url
    }
}

struct ArtistMediumEndpoint: Endpoint {
    
    var scheme: Scheme.RawValue = Scheme.https.rawValue
    
    var baseURL: String = "api.spotify.com"
    
    var path: String = "/v1/me/top/artists"
    
    var pathParameters: String?
    
    var parameters: [URLQueryItem]? = [
        URLQueryItem(name: "time_range", value: "medium_term"),
        URLQueryItem(name: "limit", value: "50"),
        URLQueryItem(name: "offset", value: "0")
    
    ]
    
    var method: Methods.RawValue? = Methods.get.rawValue
    
    static let shared =  ArtistShortEndpoint()
    
    func urlBuilder() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = parameters
        let url = components.url
        return url
    }
}

struct ArtistShortEndpoint: Endpoint {
    
    var scheme: Scheme.RawValue = Scheme.https.rawValue
    
    var baseURL: String = "api.spotify.com"
    
    var path: String = "/v1/me/top/artists"
    
    var pathParameters: String?
    
    var parameters: [URLQueryItem]? = [
        URLQueryItem(name: "time_range", value: "short_term"),
        URLQueryItem(name: "limit", value: "50"),
        URLQueryItem(name: "offset", value: "0")
    
    ]
    
    var method: Methods.RawValue? = Methods.get.rawValue
    
    static let shared =  ArtistShortEndpoint()
    
    func urlBuilder() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = parameters
        let url = components.url
        return url
    }
}
