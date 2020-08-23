//
//  PickableView.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 22/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import UIKit

protocol PickableViewDelegate: class {
    func showMapkitWithPosition(driver: Pickable<DriverHeetch>)
}

final class PickableView<T>: UIView {
    
    private let data: Pickable<T>
    private var stackView: UIStackView!
    weak var delegate: PickableViewDelegate?

    init(with data: Pickable<T>) {
        self.data = data
        super.init(frame: .zero)
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchView( sender: UITapGestureRecognizer) {
        guard let delegate = self.delegate else { return }
        delegate.showMapkitWithPosition(driver: self.data as! Pickable<DriverHeetch>)
    }
    
    func setSubviews() {
        //Setup shadow
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.backgroundColor = .white
        
        
        //AddGesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchView))
        self.addGestureRecognizer(tap)
        
        //Creates view
        self.stackView = self.createStackView()
    }
    
    private func createStackView() -> UIStackView {
        let subViews = [
            RoundedView(contentView: self.createPicture()),
            self.createLabelName()
        ]
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true


        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        return stackView


    }
        
    private func createLabelName() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
//        label.setContentHuggingPriority(.required, for: .vertical)
        label.text = self.data.title
        return label
    }
    
    private func createPicture() -> UIImageView {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .vertical)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        if let url = URL(string:"http://hiring.heetch.com\(self.data.image)") {
            imageView.image = UIImage.loadImageFromURL(url: url)
        }
        return imageView
    }
}
