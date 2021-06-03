//
//  FetchViewController.swift
//  Candidate App
//
//  Created by Assaf Halfon on 30/05/2021.
//

import UIKit

class FetchViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var fetchButton: UIButton?
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        self.setupButton()
    }
    
    
    // MARK: - Internal API
    
    internal func setupButton() {
        let button = UIButton(type: .system)
        button.frame = .zero
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Doge Exchange Rate", for: .normal)
        button.addTarget(self, action: #selector(dogeButtonTouchUpInside), for: .touchUpInside)
        self.view.addSubview(button)
        [
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ].forEach({ $0.isActive = true })
        self.fetchButton = button
    }
    
    @objc internal func dogeButtonTouchUpInside() {
        let dogeVC = DogeViewController()
        self.navigationController?.pushViewController(dogeVC, animated: true)
    }

}
