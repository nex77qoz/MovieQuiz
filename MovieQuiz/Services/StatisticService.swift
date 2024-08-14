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
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
    }
    
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult {
        get {
            return GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    func resetStats() {
        storage.set(0, forKey: Keys.bestGameCorrect.rawValue)
        storage.set(0, forKey: Keys.bestGameTotal.rawValue)
    }
    
    var correctAnswers: Int {
        get { storage.integer(forKey: Keys.correct.rawValue) }
        set { storage.set(newValue, forKey: Keys.correct.rawValue) }
    }

    var totalAccuracy: Double {
        let totalQuestions = gamesCount * 10
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }

    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1

        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }
}
