//
//  ConstraintsAutoLayout.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation

/// This procol serves as guide to setup UIView implementing AutoLayout constraints
protocol ViewConstraintAutoLayoutSetup {
    func setUpViews()
    func setUpConstraints()
}
