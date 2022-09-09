//
//  MotionSample.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 14.12.21.
//

import Foundation

struct MotionSample: Codable {
    
    /* timestamp when this motion sample was created */
    var timeStampPhone: String
    
    /* a number that is continuously increased */
    var sampleCount: Int
    
    /* acceleration that the user is giving to the device */
    var accelerationUserX: Double
    var accelerationUserY: Double
    var accelerationUserZ: Double
    
    /* gyroscope data whose bias has been removed by Core Motion algorithms */
    var rotationRateX: Double
    var rotationRateY: Double
    var rotationRateZ: Double
    
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
