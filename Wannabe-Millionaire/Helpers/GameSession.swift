//
//  GameSession.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Структура для хранения данных о текущей игре
struct GameSession: Codable {
	
	/// Номер текущего вопроса в массиве загруженных вопросов
	var currentQuestionArrayId: Int = 0
	
	/// ID текущего вопроса
	var currentQuestionID: Int?
	
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
	
	/// Увеличить ID вопроса на 1 и кол-во успехов на 1
	mutating func nextQuestion() {
		currentQuestionArrayId += 1
		score += 1
		currentQuestionClues = []
	}
	
	/// Сохраняет ID текущего вопроса, чтобы задать его при возобновлении игры
	mutating func currentlyAsking(question: Int) {
		currentQuestionID = question
	}
	
	/// Помечает вопрос как уже заданный
	mutating func checkQuestionAsAsked(id: Int) {
		askedQuestions.append(id)
	}
	
	/// Зафиксировать факт победы
	mutating func didWin() {
		success = true
	}
	
	mutating func resetArrayCount() {
		currentQuestionArrayId = 0
	}
}
