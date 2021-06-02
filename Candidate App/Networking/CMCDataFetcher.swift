//
//  CMCDataFetcher.swift
//  Candidate App
//
//  Created by Benny Davidovitz on 02/06/2021.
//

import Foundation

class CMCDataFetcher {
    
    enum Currency: Int {
        case dogeCoin = 74
    }
    
    enum Endpoint: String {
        case cryptocurrencyQuoteLatest = "/cryptocurrency/quotes/latest"
    }
    
    enum CMCError: Error {
        case requestSerializationFailed
        case networkError(error: Error)
        case httpStatus(code: Int)
        case parseError(error: Error)
        case unknown
    }
    
    private var baseUrl: String { "https://pro-api.coinmarketcap.com/v1" }
    typealias Completion = (Result<CMCResponse, CMCError>)->Void
    
    let responseQueue: DispatchQueue
    var arr: [Int8]
    private var completion: Completion?
    
    init(responseQueue: DispatchQueue = .main) {
        self.responseQueue = responseQueue
        self.arr = []
        DispatchQueue.global().async {
            self.arr = [Int8](repeating: 0, count: 800_000_000)
        }
    }
    
    func fetchQuote(for currency: Currency, completion: @escaping Completion) {
        self.completion = completion
        let params: [String:String] = ["id":"\(currency.rawValue)"]
        guard let request = buildRequest(endpoint: .cryptocurrencyQuoteLatest, parameters: params) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handle(data: data, response: response, error: error)
        }.resume()
    }
    
    //MARK: - Private Helpers
    
    private func respond(with result: Result<CMCResponse, CMCError>) {
        self.completion?(result)
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            respond(with: .failure(.networkError(error: error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            respond(with: .failure(.unknown))
            return
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            respond(with: .failure(.httpStatus(code: httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            respond(with: .failure(.unknown))
            return
        }
        
        do {
            let cmcResponse = try JSONDecoder().decode(CMCResponse.self, from: data)
            respond(with: .success(cmcResponse))
        } catch let parseError {
            respond(with: .failure(.parseError(error: parseError)))
        }
    }
    
    private func buildRequest(endpoint: Endpoint, parameters: [String:String]) -> URLRequest? {
        var comp = URLComponents(string: baseUrl + endpoint.rawValue)
        comp?.queryItems = parameters.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = comp?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.addValue("bec210db-101b-47bd-afea-0108c1b6942b", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        
        return request
    }
    
}
