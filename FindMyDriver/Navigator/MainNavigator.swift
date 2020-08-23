//
//  MainNavigator.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 21/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import UIKit

class MainNavigator: Navigator {
    
    ///Every destination possible in this navigator
    enum Destination {
        case findMyDriver(viewModel: FindMyDriverViewModel)
    }
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .findMyDriver(let viewModel):
            return FindMyDriverViewController(viewModel: viewModel)
        }
    }
}

