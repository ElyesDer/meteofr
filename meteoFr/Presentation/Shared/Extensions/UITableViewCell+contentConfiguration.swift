//
//  UITableViewCell+contentConfiguration.swift
//  meteoFr
//
//  Created by Elyes Derouiche on 09/07/2023.
//

import Foundation
import UIKit
import SwiftUI

/// A proposal for the size
///
/// * The ``zero`` proposal; the size responds with its minimum size.
/// * The ``infinity`` proposal; the size responds with its maximum size.
/// * The ``unspecified`` proposal; the size responds with its system default size.
internal struct ProposedSize: Equatable, Sendable {

    /// The proposed horizontal size measured in points.
    ///
    /// A value of `nil` represents an unspecified width proposal.
    public var width: CGFloat?

    /// The proposed vertical size measured in points.
    ///
    /// A value of `nil` represents an unspecified height proposal.
    public var height: CGFloat?

    /// A size proposal that contains zero in both dimensions.
    public static var zero: ProposedSize { .init(width: 0, height: 0) }

    /// The proposed size with both dimensions left unspecified.
    ///
    /// Both dimensions contain `nil` in this size proposal.
    public static var unspecified: ProposedSize { .init(width: nil, height: nil) }

    /// A size proposal that contains infinity in both dimensions.
    ///
    /// Both dimensions contain .infinity in this size proposal.
    public static var infinity: ProposedSize { .init(width: .infinity, height: .infinity) }

    /// Creates a new proposed size using the specified width and height.
    ///
    /// - Parameters:
    ///   - width: A proposed width in points. Use a value of `nil` to indicate
    ///     that the width is unspecified for this proposal.
    ///   - height: A proposed height in points. Use a value of `nil` to
    ///     indicate that the height is unspecified for this proposal.
    @inlinable public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }

    /// Creates a new proposed size from a specified size.
    ///
    /// - Parameter size: A proposed size with dimensions measured in points.
    @inlinable public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }

}

/// Provides optional inset values. `nil` is interpreted as: use system default
internal struct ProposedInsets: Equatable {

    /// The proposed leading margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var leading: CGFloat?

    /// The proposed trailing margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var trailing: CGFloat?

    /// The proposed top margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var top: CGFloat?

    /// The proposed bottom margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var bottom: CGFloat?

    /// An insets proposal with all dimensions left unspecified.
    public static var unspecified: ProposedInsets { .init() }

    /// An insets proposal that contains zero for all dimensions.
    public static var zero: ProposedInsets { .init(leading: 0, trailing: 0, top: 0, bottom: 0) }

}

public protocol BackportUIContentConfiguration {
    func makeContentView() -> UIView
}


public extension UITableViewCell {
    var contentConfiguration: BackportUIContentConfiguration? {
        get { nil } // we can't really support anything here, so for now we'll return nil
        set {
//            configuredView?.removeFromSuperview()

            contentView.subviews.forEach({ $0.removeFromSuperview() })

            guard let configuration = newValue else { return }
            let contentView = contentView

            var configuredView = configuration.makeContentView()
            configuredView.translatesAutoresizingMaskIntoConstraints = false

            clipsToBounds = false
            contentView.clipsToBounds = false
            contentView.preservesSuperviewLayoutMargins = false
            contentView.addSubview(configuredView)

            let insets = Mirror(reflecting: configuration)
                .children.first(where: { $0.label == "insets" })?.value as? ProposedInsets
            ?? .unspecified

            insets.top.flatMap { contentView.directionalLayoutMargins.top = $0 }
            insets.bottom.flatMap { contentView.directionalLayoutMargins.bottom = $0 }
            insets.leading.flatMap { contentView.directionalLayoutMargins.leading = $0 }
            insets.trailing.flatMap { contentView.directionalLayoutMargins.trailing = $0 }

            NSLayoutConstraint.activate([
                configuredView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                configuredView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                configuredView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
                configuredView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            ])
        }
    }

}
