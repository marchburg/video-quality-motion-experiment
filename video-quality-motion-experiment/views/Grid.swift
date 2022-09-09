//
//  Grid.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 01.02.22.
//

import SwiftUI

struct Grid: View {
    
    let numberOfHorizontalBoxes: Int = 9
    let numberOfVerticalBoxes: Int = 9
    
    var body: some View {
        
        /* geometry reader to get frame for this view proposed by parent view */
        GeometryReader { geometry in
            Path { path in
                /* vertical lines */
                for index in 0...numberOfVerticalBoxes {
                    let vOffset: CGFloat = CGFloat(index) * geometry.size.width / CGFloat(self.numberOfVerticalBoxes)
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                }
                /* horizontal lines */
                for index in 0...numberOfHorizontalBoxes {
                    let hOffset: CGFloat = CGFloat(index) * geometry.size.height / CGFloat(self.numberOfHorizontalBoxes)
                    path.move(to: CGPoint(x: 0, y: hOffset))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: hOffset))
                }
            }
            .stroke()
        }
        
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid()
    }
}
