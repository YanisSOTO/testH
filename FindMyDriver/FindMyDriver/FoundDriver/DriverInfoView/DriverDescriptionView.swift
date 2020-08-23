//
//  DriverDescriptionView.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import UIKit

final class DriverDescriptionView: UIView {
    
    private var mainStackView: UIStackView!

    
    init() {
        super.init(frame: .zero)
        self.isHidden = true
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubviews() {
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.mainStackView = self.createMainStackView()
    }
        
    private func createMainStackView() -> UIStackView {
        let subViews = [
            RoundedView(contentView: self.createPicture()),
            self.createInfoDriverLabelStackView(),
            self.createAdressStackView()
        ]

        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        return stackView
    }
    
    private func createInfoDriverLabelStackView() -> UIStackView {
        let subViews = [
            self.nameLabel,
            self.dateLabel
        ]
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 5, right: 20)

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        return stackView
    }
    
    private func createAdressStackView() -> UIStackView {
        let subViews = [
            self.streetLabel,
            self.postalLabel,
            self.countryLabel
        ]
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        return stackView
    }
    
    private func createPicture() -> UIImageView {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    let nameLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    let dateLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = .gray
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    let streetLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    
    let postalLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }

    let countryLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }

    let profileImageView = UIImageView()..{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
}
