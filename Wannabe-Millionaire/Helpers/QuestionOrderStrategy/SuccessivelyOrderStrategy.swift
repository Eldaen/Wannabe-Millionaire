//
//  SuccessivelyOrderStrategy.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 31.01.2022.
//

import Foundation

final class SuccessivelyOrderStrategy: QuestionOrderStrategy {
	
	/// Сервис загрузки вопросов
	let questionsService = QuestionsService()
	
	/// Загружает данные вопросов
	func loadQuestions(for session: GameSession) -> [Question] {
		let questions = questionsService.loadQuestions()
		var result: [Question] = []
		
		if session.askedQuestions.isEmpty {
			result = questions
		} else {
			// Если есть заданные вопросы, то убираем их из ответа
			result = questions.filter( { !session.askedQuestions.contains($0.id) } )
		}
		
		return result
	}
}
