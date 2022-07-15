//
//  ViewController.swift
//  Dice-Combine
//
//  Created by Fatih Sağlam on 15.07.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var diceImage = UIImageView()
    var rollDiceButton = BigButton()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = DiceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubscriptions()
    }
    
    @objc func rollDiceTapped() {
        // roll dice
    }
    
    private func configureSubscriptions() {
        viewModel.$diceImage
            .map{ $0 as UIImage? }
            .assign(to: \.image, on: diceImage)
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        view.addSubview(diceImage)
        view.addSubview(rollDiceButton)
        
        view.backgroundColor = .systemBackground
        
        diceImage.image = UIImage(named: "dice-four")
        diceImage.tintColor = .systemOrange
        diceImage.layer.shadowColor = UIColor.black.cgColor
        diceImage.layer.shadowOpacity = 0.25
        diceImage.layer.shadowRadius = 2
        diceImage.layer.shadowOffset = .zero
        diceImage.translatesAutoresizingMaskIntoConstraints = false
        
        rollDiceButton.setTitle("Roll Dice", for: .normal)
        rollDiceButton.addTarget(self, action: #selector(rollDiceTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            diceImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            diceImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            diceImage.widthAnchor.constraint(equalToConstant: 64),
            diceImage.heightAnchor.constraint(equalToConstant: 64),
            
            rollDiceButton.topAnchor.constraint(equalTo: diceImage.bottomAnchor, constant: 101),
            rollDiceButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rollDiceButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            rollDiceButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
