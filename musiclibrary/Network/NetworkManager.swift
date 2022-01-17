//
//  NetworkManager.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

class NetworkManager:NSObject {
        
    private let url = "https://itunes.apple.com/search"
    
    enum NetworkErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    enum HttpMethod: String {
        case get
        case post
        var method: String { rawValue.uppercased() }
    }
    
   func createRequest(parameters: [String:String]=[String:String](), httpMethod:HttpMethod = .get) -> URLRequest? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        
        if httpMethod.method == "GET" {
            urlComponents.queryItems = parameters.map {
                (key, value) in
                        URLQueryItem(name: key, value: value)
            }
        }
       
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod.method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField:  "Content-Type")
        
        return request
    }
    
    func executeRequest(request: URLRequest, completion: (@escaping (Result<Data, Error>) -> Void)) {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let urlResponse  = response as? HTTPURLResponse else {
                return completion(.failure(NetworkErrors.invalidResponse))
            }
            
            if !(200..<300).contains(urlResponse.statusCode) {
                return completion(.failure(NetworkErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            guard let data = data else { return }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }
    
    public func downloadImage(url: String,
                                     completion: @escaping (Result<Data, Error>) -> Void) {
      
        let request = URLRequest(url: URL(string: url)!)
        
        executeRequest(request: request) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
