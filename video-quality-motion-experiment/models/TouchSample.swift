//
//  TouchSample.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 20.04.22.
//

import Foundation

struct TouchSample: Codable {
    
    /* timestamp of touch input */
    var timeStampTap: String
    
    /* location of touch input */
    var locationTap: String
    
    func toString() -> String {
        let jsonEncoder = JSONEncoder()
    
        do {
            let encodeSample = try jsonEncoder.encode(self)
            let endcodeStringSample = String(data: encodeSample, encoding: .utf8)!
            return endcodeStringSample
        } catch {
            print(error.localizedDescription)
            return "error while encoding motionSample to String"
        }
    }
}
