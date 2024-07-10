//
//  File.swift
//  
//
//  Created by Александр Андреев on 10.07.2024.
//

import Foundation

protocol JSONParsable {
    var json: [String: Any] { get }
    
    static func parse(json: Any) -> Self?
}
