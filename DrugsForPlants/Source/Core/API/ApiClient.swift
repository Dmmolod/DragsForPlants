//
//  ApiClient.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct ApiClient {
    
    let scheme: String
    let host: String
    
    init(scheme: String = "http", host: String = "shans.d2.i-partner.ru") {
        self.scheme = scheme
        self.host = host
    }
}

extension ApiClient {
    //MARK: - Common API
    func request<Response: Decodable>(
        _ request: Request,
        response: @escaping (Result<Response, ApiError>) -> ()
    ) {
        makeURLRequest(for: request)
            .onSuccess { send($0, response) }
            .onFailure { response(.failure($0)) }
    }
    
    //MARK: - Make url request
    func makeURLRequest(for request: Request) -> Result<URLRequest, ApiError> {
        makeURL(path: request.path, query: request.query).flatMap {
            makeRequest(url: $0, method: request.method)
        }
    }
    
    func makeURL(path: String, query: [String: String]) -> Result<URL, ApiError> {
        guard let url = URL(string: path)
        else { return .failure(ApiError(message: "Failed to get url.")) }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        components?.host = host
        components?.queryItems = query.map(URLQueryItem.init)
        
        guard let url = components?.url
        else { return .failure(ApiError(message: "Failed to get url from components.")) }
        
        return .success(url)
    }
    
    func makeRequest(url: URL, method: String) -> Result<URLRequest, ApiError> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return .success(request)
    }
    
    //MARK: - Send request method
    func send<T: Decodable>(
        _ request: URLRequest,
        _ completion: @escaping (Result<T, ApiError>) -> ()
    ) {
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { data, _, error in
                DispatchQueue.main.async {
                    if let error { return completion(.failure(ApiError(error))) }
                    
                    guard let data
                    else { return completion(.failure(ApiError(message: "Data is nil"))) }
                    
                    guard let response = try? JSONDecoder().decode(T.self, from: data)
                    else { return completion(
                        .failure(
                            ApiError(
                                message: "Failed to decode data for url: \(request.url?.absoluteString ?? "nil")"
                            )
                        ))
                    }
                    
                    completion(.success(response))
                }
            }
        ).resume()
    }
}

