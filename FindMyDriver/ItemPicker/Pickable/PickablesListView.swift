//
//  PickablesListView.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 22/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import UIKit

final class PickablesListView<T>: UIView {

    private var data: [Pickable<T>]
    private var driversStack: UIStackView!
    weak var parentView: UIViewController?
    
    init(with data: [Pickable<T>]) {
        self.data = data
        super.init(frame: .zero)
        self.isHidden = true
    }
    
    func updateData(with data: [Pickable<T>]) {
        self.data = data
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubviews() {
        self.driversStack = self.createDriversStackView()
    }
    
    
    private func createDriversStackView() -> UIStackView {
        let subViews = self.data.map { PickableView(with: $0)}
        
        subViews.forEach { $0.delegate = self.parentView as? PickableViewDelegate}
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.axis = .vertical
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
}
