//
//  GameSession.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Структура для хранения данных о текущей игре
class GameSession: Codable {
	
	/// Номер текущего вопроса в массиве загруженных вопросов
	var currentQuestionArrayId: Int = 0
	
	/// ID текущего вопроса
	var currentQuestionID: Int?
	
	/// Номер вопроса
	var questionCountNumber = Observable<Int>(1)
	
	/// Номер вопроса типа INT для сохранения в Codable
	var questionCountNumberInt = 1
	
	/// Текущее кол-во правильных ответов
	var score: Int = 0
	
	/// Победил или проиграл
	var success: Bool = false
	
	/// Массив использованных подсказок
	var usedClues: [Int] = []
	
	/// Использованные на этом вопросе подсказки
	var currentQuestionClues: [Int] = []
	
	/// Порядок вопросов в текущей сессии
	var currentQuestionsOrder: Game.QuestionsOrder {
		Game.shared.order
	}
	
	/// Массив заданных вопросов
	var askedQuestions: [Int] = []
	
	/// Общее кол-во вопросов
	var questionsCount: Int?
	
	enum CodingKeys: String, CodingKey {
		case currentQuestionArrayId
		case currentQuestionID
		case questionCountNumberInt
		case score
		case success
		case usedClues
		case currentQuestionClues
		case askedQuestions
		case questionsCount
	}
	
	init() {
		questionCountNumber.value = questionCountNumberInt
	}
	
	/// Увеличить ID вопроса на 1 и кол-во успехов на 1
	func nextQuestion() {
		currentQuestionArrayId += 1
		score += 1
		questionCountNumber.value += 1
		questionCountNumberInt = questionCountNumber.value
		currentQuestionClues = []
	}
	
	/// Сохраняет ID текущего вопроса, чтобы задать его при возобновлении игры
	func currentlyAsking(question: Int) {
		currentQuestionID = question
	}
	
	/// Помечает вопрос как уже заданный
	func checkQuestionAsAsked(id: Int) {
		askedQuestions.append(id)
	}
	
	/// Зафиксировать факт победы
	func didWin() {
		success = true
	}
	
	func resetArrayCount() {
		currentQuestionArrayId = 0
	}
}
