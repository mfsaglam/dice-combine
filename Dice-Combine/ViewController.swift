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
        viewModel.rollDice()
    }
    
    private func configureSubscriptions() {
        viewModel.$diceImage
            .map{ $0 as UIImage? }
            .assign(to: \.image, on: diceImage)
            .store(in: &cancellables)
        
        viewModel.$isRolling
            .map { !$0 }
            .assign(to: \.isEnabled, on: rollDiceButton)
            .store(in: &cancellables)
        
        viewModel.$isRolling
            .sink { [weak self] isRolling in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.5) {
                    self.diceImage.alpha = isRolling ? 0.5 : 1.0
                    self.diceImage.transform = isRolling ? CGAffineTransform(scaleX: 0.5, y: 0.5) : CGAffineTransform.identity
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Dice Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                alert.addAction(UIAlertAction(title: "Reroll", style: .default, handler: { _ in
                    self.rollDiceTapped()
                }))
                self.present(alert, animated: true)
            }
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
