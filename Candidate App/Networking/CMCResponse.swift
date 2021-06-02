//
//  CMCResponse.swift
//  Candidate App
//
//  Created by Benny Davidovitz on 02/06/2021.
//

import Foundation

struct CMCResponse: Codable {
    struct CMCData: Codable {
        let quote: [String: Quote]
    }
    
    struct Quote: Codable {
        let price: Double
        let percent_change_24h: Double
    }
    
    let data: [String: CMCData]
}
