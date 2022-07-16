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
    
    @Published
    private var diceValue: Int?
    
    enum DiceError: Error {
        case rolledOffTable
    }
    
    private var rollSubject = PassthroughSubject<Void, Never>()
    
    init() {
        rollSubject
            .flatMap { [unowned self] in
                roll()
                    .handleEvents(
                        receiveSubscription: { [unowned self] _ in
                            isRolling = true
                        }, receiveCompletion: { [unowned self] _ in
                            isRolling = false
                        }, receiveCancel: { [unowned self] in
                            isRolling = false
                        })
                    .map { $0 as Int? }
                    .catch { error -> Just<Int?> in
                        print("error: \(error)")
                        return Just(nil)
                    }
            }
            .assign(to: &$diceValue)
        
        $diceValue
            .map { [unowned self] in diceImage(for: $0) }
            .assign(to: &$diceImage)
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
        rollSubject.send()
    }
    
    private func diceImage(for value: Int?) -> UIImage {
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
