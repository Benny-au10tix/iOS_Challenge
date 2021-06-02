//
//  ImageDownloader.swift
//  Candidate App
//
//  Created by Benny Davidovitz on 02/06/2021.
//

import Foundation

class ImageDownloader {
    
    enum ImageDownloaderError: Error {
        case invalidUrl
        case networkError(error: Error)
        case httpStatus(code: Int)
        case unknown
    }
    
    typealias Completion = (Result<Data,ImageDownloaderError>)->Void
    
    let responseQueue: DispatchQueue
    
    init(responseQueue: DispatchQueue = .main) {
        self.responseQueue = responseQueue
    }
    
    func download(from urlString: String, completion: @escaping Completion) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.handle(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    //MARK: - Private Helpers
    
    private func respond(with result: Result<Data,ImageDownloaderError>, to completion: @escaping Completion) {
        self.responseQueue.asyncAfter(deadline: .now() + 1, execute: {
            completion(result)
        })
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?, completion: @escaping Completion) {
        if let error = error {
            respond(with: .failure(.networkError(error: error)), to: completion)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            respond(with: .failure(.unknown), to: completion)
            return
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            respond(with: .failure(.httpStatus(code: httpResponse.statusCode)), to: completion)
            return
        }
        
        guard let data = data else {
            respond(with: .failure(.unknown), to: completion)
            return
        }
        
        respond(with: .success(data), to: completion)
        
    }
    
}
