//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 03.08.2024.
//

import Foundation



final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "bestGameCorrect")
            let total = storage.integer(forKey: "bestGameTotal")
            let date = storage.object(forKey: "bestGameDate") as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: "bestGameCorrect")
            storage.set(newValue.total, forKey: "bestGameTotal")
            storage.set(newValue.date, forKey: "bestGameDate")
        }
    }
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }

    var totalAccuracy: Double {
            guard gamesCount > 0 else { return 0 }
        return Double(correctAnswers) / 10 * Double(gamesCount)
        }

    
    func store(correct count: Int, total amount: Int) {
        let currentCorrectAnswers = storage.integer(forKey: Keys.correct.rawValue)
        
        storage.set(currentCorrectAnswers + count, forKey: Keys.correct.rawValue)
        
        gamesCount += 1
        
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }
    
  
}
