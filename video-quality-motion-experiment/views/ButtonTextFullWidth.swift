//
//  ButtonTextFullWidth.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 09.11.20.
//

import SwiftUI

struct ButtonTextFullWidth: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .padding()
            .font(.title)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(CGFloat(40))
            .padding()
    }
}

struct ButtonTextFullWidth_Previews: PreviewProvider {

    static var text: String = "sample button full width"
    
    static var previews: some View {
        ButtonTextFullWidth(text: text)
    }
}
