//
//  EnterParticipantId.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 17.01.22.
//

import SwiftUI

struct EnterParticipantId: View {
        
    @Binding var participantId: String
    
    @Binding var selectNewParticipantId: Bool
    
    @State var selectedParticipantIdIndex: Int = -1
    
    @State var showAlertMissingId: Bool = false
    
    let participantSpecifications: [ParticipantSpecification]
    
    var body: some View {
        
        VStack {
            
            Form {
                
                /* instructions for Picker */
                Text("Please select the participant id")
                
                /* picker menu to select the participant id */
                Picker("", selection: $selectedParticipantIdIndex) {
                    /* dictionaries are unordered so the keys need to be sorted */
                    ForEach(0..<participantSpecifications.count, id: \.self) { i in

                        Text(self.participantSpecifications[i].pid)
                    }
                }
                /* defines how the picker looks. Alternatives are for example MenuPickerStyle(), WheelPickerStyle() */
                .pickerStyle(MenuPickerStyle())
            }
  
        
            
            Button(action: {
                
                if self.selectedParticipantIdIndex == -1 {
                    /* show alert if no participant id was selected*/
                    self.showAlertMissingId = true
                } else {
                    /* set selectNewParticipantId to false which triggers change of view in MainView */
                    self.selectNewParticipantId = false
                    
                    /* give selected participant id to parent view*/
                    self.participantId = self.participantSpecifications[self.selectedParticipantIdIndex].pid
                }
            }) {
                ButtonTextFullWidth(text: "Start")
            }
            .alert("Wählen Sie eine ID", isPresented: $showAlertMissingId) {
                Button("Ok", role: .cancel) {}
            }
            
            
        }
        /* hide the navigation bar */
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct EnterParticipantId_Previews: PreviewProvider {
    @State static var participantId: String = ""
    @State static var selectNewParticipantId: Bool = true
    static var previews: some View {
        EnterParticipantId(
            participantId: $participantId,
            selectNewParticipantId: $selectNewParticipantId,
            participantSpecifications: loadCSV(from: "participant_orders")
        )
    }
}
