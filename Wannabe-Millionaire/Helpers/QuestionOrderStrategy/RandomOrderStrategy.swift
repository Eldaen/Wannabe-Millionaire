//
//  RandomOrderStrategy.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 31.01.2022.
//

import Foundation

final class RandomOrderStrategy: QuestionOrderStrategy {
	
	/// Сервис загрузки вопросов
	let questionsService = QuestionsService()
	
	/// Загружает данные вопросов
	func loadQuestions(for session: GameSession) -> [Question] {
		let questions = questionsService.loadQuestionsRandom()
		var result: [Question] = []
		
		if session.askedQuestions.isEmpty {
			result = questions
		} else {
			// Если есть заданные вопросы, то убираем их из ответа
			result = questions.filter( { !session.askedQuestions.contains($0.id) } )
		}
		
		if let currentQuestion = session.currentQuestionID {
			let firstQuestion = result.filter( { $0.id == currentQuestion} )
			result = firstQuestion + result.filter( { $0.id != currentQuestion } )
		}
		
		return result
	}
}
