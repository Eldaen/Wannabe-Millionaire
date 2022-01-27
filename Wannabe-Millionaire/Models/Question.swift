//
//  Question.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import Foundation

/// Модель вопроса
struct Question: Codable {
	var text: String
	
	/// Массив возможных ответов на вопрос
	var answerOptions: [String]
	
	/// ID правильного ответа из массива answerOptions
	var correctAnswer: Int
	
	/// ID результатов, которые нужно убрать после подсказки fiftyFifty
	var fiftyFiftyClue: [Int]
	
	/// ID, который нужно подсветить как верный, после подсказки Звонок другу
	var callFriendClue: Int
	
	/// Помощь зала
	var hallHelp: HallHelpClue
	
	/// Проверяет верность ответа
	func checkAnswer(_ id: Int) -> Bool {
		if correctAnswer == id {
			return true
		} else {
			return false
		}
	}
}
