//
//  DiceViewModel.swift
//  Dice-Combine
//
//  Created by Fatih Sağlam on 15.07.2022.
//

import UIKit
import Combine

class DiceViewModel {
    private static var unknownDiceImage = UIImage(systemName: "questionmark.square.fill")!
    
    @Published
    var isRolling = false
    
    @Published
    var diceImage: UIImage = unknownDiceImage
    
    enum DiceError: Error {
        case rolledOffTable
    }
    
    private func roll() -> AnyPublisher<Int, DiceError> {
        Future { promise in
            if Int.random(in: 1...4) == 1 {
                promise(.failure(DiceError.rolledOffTable))
            } else {
                let value = Int.random(in: 1...6)
                promise(.success(value))
            }
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func rollDice() {
        fatalError("Not Implemented")
    }
    
    private func diceImage(for value: Int) -> UIImage {
        switch value {
        case 1: return UIImage(named: "dice-one")!
        case 2: return UIImage(named: "dice-two")!
        case 3: return UIImage(named: "dice-three")!
        case 4: return UIImage(named: "dice-four")!
        case 5: return UIImage(named: "dice-five")!
        case 6: return UIImage(named: "dice-six")!
        default:
            return Self.unknownDiceImage
        }
    }
}
