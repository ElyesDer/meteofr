//
//  WeatherDetailsCell.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation
import UIKit
import SwiftUI

class WeatherDetailsCell: UITableViewCell {
    
    static let identifier = "WeatherDetailsCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cloundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var content: WeatherViewModel!
    
    func setup(with content: WeatherViewModel) {
        self.content = content

        print("setup: called with \(content.countryName)")
        
        // setup image loading
//        setUpViews()
//        setUpConstraints()

        contentConfiguration = UIHostingConfiguration {
//            HelloView()
            Text(content.countryName)
                .border(Color.red, width: 2)
        }
    }
}

struct HelloView: View {
    @State private var toggle: Bool = false

    public init() {
    }

    var body: some View {
        VStack {
            Text("Tap me for more")
                .onTapGesture {
                    toggle.toggle()
                }
        }
//        .frame(height: toggle ? 100 : 200)
        .border(Color.red, width: 1)
    }
}

extension WeatherDetailsCell: ViewConstraintAutoLayoutSetup {
    
    func setUpViews() {
        nameLabel.text = self.content.countryName
        tempLabel.text = self.content.temperature
        cloundImage.image = self.content.clounds
        
        self.addSubview(nameLabel)
        self.addSubview(tempLabel)
        self.addSubview(cloundImage)
    }
    
    func setUpConstraints() {
        nameLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil,
                         padding: .init(top: 2, left: 8, bottom: 2, right: 0))
        tempLabel.anchor(top: self.topAnchor, leading: nameLabel.trailingAnchor, bottom: self.bottomAnchor, trailing: nil)
        cloundImage.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor,
                           padding: .init(top: 2, left: 0, bottom: 2, right: 8))
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            tempLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            cloundImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        ])
    }
}
