//
//  AffectGrid.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 25.01.22.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct AffectGrid: View {
    
    /* participant data */
    @EnvironmentObject var participantData: ParticipantData
    
    /* x-coordinate of tap */
    @State var xTap: CGFloat? = nil
    
    /* y-coordinate of tap */
    @State var yTap: CGFloat? = nil
    
    @Binding var valence: Double
    @Binding var arousal: Double
    
    /* width of affect grid tap area */
    var widthTapZone: Double = 0.8 * UIScreen.screenWidth // 300
    
    /* width of vertical text label */
    var widthVerticalText: Double = 0.1 * UIScreen.screenWidth
    
    /* string labels */
    var labelLeft = "sehr unangenehm"
    var labelRight = "sehr angenehm"
    var labelTop = "sehr aufgeregt"
    var labelBottom = "sehr langweilig"
    
    var body: some View {
        
        VStack {
            
            /* label top */
            Text(self.labelTop)
            
            HStack {
                
                Spacer()
                
                /* label left */
                Text(self.labelLeft)
                    .rotationEffect(.degrees(-90))
                    .fixedSize()
                    .frame(width: self.widthVerticalText)
                
        
                ZStack(alignment: .topLeading) {
                    
                    Rectangle()
                        .fill(Color.white)
                        /* opacity almost zero for transparency but not zero to still detect gestures */
                        .opacity(0.001)
                        .padding()
                        .gesture(
                            /* acts like a tap gesture via minimumDistance = 0.0 and gives location of touch in value */
                            DragGesture(minimumDistance: 0.0)
                                .onEnded { value in

                
                                    /* recognize tap gesture on this element */
                                    self.participantData.addTouchSample(locationTap: "AffectGrid")

                                    /* check if tap location is within rectangle */
                                    if value.startLocation.x > 0.0 && value.startLocation.x < self.widthTapZone && value.startLocation.y > 0.0 && value.startLocation.y < self.widthTapZone {
                                        
                                        /* assign position where drag started to xTap and yTap */
                                        self.xTap = value.startLocation.x
                                        self.yTap = value.startLocation.y
                                        
                                        /* assign relative values xTap / width to a variable "valence", same for arousal */
                                        self.valence = value.startLocation.x / self.widthTapZone
                                        self.arousal = value.startLocation.y / self.widthTapZone
                                        
                                        // debug
                                        print("valence: \(valence), arousal: \(arousal)")
                                    }
                                
                                }
                        )

                    /* Circle indicating the position where user tapped */
                    Circle()
                        .fill(Color.accentColor)
                        /* hide Circle before user makes first touch input */
                        .opacity(self.xTap == nil ? 0 : 1)
                        .position(x: self.xTap ?? 0.0, y: self.yTap ?? 0.0)
                        .frame(width: 25)

                }
                /* make the view square */
                .aspectRatio(1.0, contentMode: .fit)
                /* set the width */
                .frame(width: self.widthTapZone)
                /* draw grid lines */
                .background {
                    Grid()
                }
                
                /* label right */
                Text(self.labelRight)
                    .rotationEffect(.degrees(-90))
                    .fixedSize()
                    .frame(width: self.widthVerticalText)
                
                Spacer()
                
            }
            
            /* label bottom */
            Text(self.labelBottom)
            
        }

    }
}

struct AffectGrid_Previews: PreviewProvider {
    @State static var valence: Double = -999
    @State static var arousal: Double = -999
    
    static var previews: some View {
        AffectGrid(valence: $valence, arousal: $arousal)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
