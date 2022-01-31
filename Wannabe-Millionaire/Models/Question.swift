//
//  Question.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import Foundation

/// Модель вопроса
struct Question: Codable {

	/// Варианты подсказки помощь зала
	enum HallHelp: String {
		case full = "full"
		case half = "half"
	}
	
	/// Номер вопроса
	var id: Int
	
	/// Текст вопроса
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
	
	/// Возвращает данные по подсказке Помощь зала
	func getHallHelp(for key: HallHelp) -> [Int] {
		switch key {
		case .full:
			return hallHelp.full
		case .half:
			return hallHelp.half
		}
	}
}

// MARK: -- Equatable

extension Question: Equatable {
	static func == (lhs: Question, rhs: Question) -> Bool {
		lhs == rhs
	}
}
