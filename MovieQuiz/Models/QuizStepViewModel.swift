//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 28.07.2024.
//

import UIKit

    // вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
