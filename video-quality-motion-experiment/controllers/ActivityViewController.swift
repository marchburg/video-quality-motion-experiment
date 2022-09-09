//
//  ActivityViewController.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 07.02.22.
//

import Foundation
import UIKit
import SwiftUI

/* SwiftUI implementation of UIActivityViewController based on https://stackoverflow.com/questions/56533564/showing-uiactivityviewcontroller-in-swiftui */

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
