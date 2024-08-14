//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 13.08.2024.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var currentQuestionIndex: Int = 0
    
    func yesButtonClicked(with question: QuizQuestion?) {
        guard let currQuestion = currentQuestion else {
            return
        }

        let givenAnswer = true
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currQuestion.correctAnswer)
    }
    func noButtonClicked(with question: QuizQuestion?) {
        guard let currQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currQuestion.correctAnswer)
    }
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
