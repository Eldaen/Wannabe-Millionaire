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
	
	mutating func increaseScore() {
		score += 1
	}
	
	mutating func nextQuestion() {
		currentQuestionId += 1
	}
}
