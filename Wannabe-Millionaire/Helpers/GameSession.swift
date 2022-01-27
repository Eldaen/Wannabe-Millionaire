//
//  GameSession.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import Foundation

/// Структура для хранения данных о текущей игре
struct GameSession {
	
	/// Номер текущего вопроса
	var currentQuestionId: Int
	
	/// Текущее кол-во правильных ответов
	var score: Int
	
	/// Победил или проиграл
	var success: Bool = false
	
	/// Массив использованных подсказок
	var usedClues: [Int] = []
	
	/// Увеличить результат на 1
	mutating func increaseScore() {
		score += 1
	}
	
	/// Увеличить ID вопроса на 1
	mutating func nextQuestion() {
		currentQuestionId += 1
	}
	
	/// Зафиксировать факт победы
	mutating func didWin() {
		success = true
	}
}
