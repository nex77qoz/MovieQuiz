//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Максим Бабкин on 28.07.2024.
//

import UIKit

struct QuizQuestion {
      // строка с названием фильма,
      // совпадает с названием картинки афиши фильма в Assets
      let image: String
      // строка с вопросом о рейтинге фильма
      let text: String
      // булевое значение (true, false), правильный ответ на вопрос
      let correctAnswer: Bool
}
