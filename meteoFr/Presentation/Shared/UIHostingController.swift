//
//  UIHostingController.swift
//  meteoFr
//
//  Created by Elyes Derouiche on 09/07/2023.
//

import Foundation
import UIKit
import SwiftUI

public struct UIHostingConfiguration<Label>: BackportUIContentConfiguration where Label: View {
    var content: Label
    var insets: ProposedInsets
    var minSize: ProposedSize
    
    public func makeContentView() -> UIView {
        let view = UIHostingController(
            rootView: ZStack {
                content
            }
        ).view!

        view.backgroundColor = .clear
        view.clipsToBounds = false

        return view
    }

    public func minSize(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        var view = self
        view.minSize = .init(width: width, height: height)
        return view
    }
}

extension UIHostingConfiguration {

    public init(@ViewBuilder label: () -> Label) {
        self.init(content: label(), insets: .init(), minSize: .infinity)
    }

}


