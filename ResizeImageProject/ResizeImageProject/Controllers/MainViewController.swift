//
//  ViewController.swift
//  DiTatiCuVladu
//
//  Created by Grigore on 03.07.2023.
//

import UIKit
//import OverlaySwipeNavigationController

/* un serviciuDeIMag
 un contr la care ajung prin swipe
 care are un plus si accesezi foto din tel
 center x + 24 de jos
 imagine cu plus
 
 target = librarie cu foto din tel dupa ce selectez se pune pe controller x/y
 */

class MainViewController: UIViewController {
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var myButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(myView)
        view.addSubview(myButton)
        setConstraints()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(toLeft))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func myButtonTapped() {
        self.myView.backgroundColor = .random()
        let currentCollor = myView.backgroundColor
        guard let title = currentCollor else { return }
        let myTitle = title.accessibilityName
        myButton.setTitleColor(currentCollor, for: .normal)
        myButton.setTitle(myTitle, for: .normal)
    }
    
    @objc func toLeft() {
        let imageVC = ImageResizeController()
        navigationController?.pushViewController(imageVC, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            myView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            myView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            myButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            myButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myView.layer.cornerRadius = 24
        myButton.layer.cornerRadius = 12
    }
    
}

