//
//  QuestionsService.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import Foundation

/// Сервис загрузки вопросов
final class QuestionsService {
	func loadQuestions() -> [Question] {
		if let filepath = Bundle.main.path(forResource: "questions", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([Question].self, from: contents)
				return decodedData
			} catch {
				print(error)
			}
		}
		return []
	}
}
