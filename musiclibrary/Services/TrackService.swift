//
//  TrackService.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

protocol TrackServiceProtocol {
    func fetchItunesData(completion:@escaping( (Result<[Track], Error>) -> Void ))
    func searchItunesData(with searchString: String, completion:@escaping( (Result<[Track], Error>) -> Void ))
}

class TrackService: TrackServiceProtocol {
    
    public func fetchItunesData(completion:@escaping( (Result<[Track], Error>) -> Void )) {
        
        let parameters = ["term":"star", "amp;country":"au", "amp;media":"movie", "amp;all":""]
        guard let request = NetworkManager().createRequest(parameters: parameters, httpMethod: .get) else {
            return
        }
        
        NetworkManager().executeRequest(request: request) { (result: Result<Data, Error>) in
            switch result {
                case .success(let data):
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let response = try jsonDecoder.decode(
                            Response.self,
                            from: data
                        )
                        completion(.success(response.results))
                    }catch (let error) {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func searchItunesData(with searchString: String, completion:@escaping( (Result<[Track], Error>) -> Void )) {
        
        let parameters = ["term":"\(searchString)", "amp;country":"au", "amp;media":"movie", "amp;all":""]
        guard let request = NetworkManager().createRequest(parameters: parameters, httpMethod: .get) else {
            return
        }
        
        NetworkManager().executeRequest(request: request) { (result: Result<Data, Error>) in
            switch result {
                case .success(let data):
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let response = try jsonDecoder.decode(
                            Response.self,
                            from: data
                        )
                        completion(.success(response.results))
                    }catch (let error) {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }


}
