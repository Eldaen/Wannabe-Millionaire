//
//  HintUsageFacade.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 03.02.2022.
//

import Foundation

final class HintUsageFacade: Codable {
	
	enum Errors: Error {
		case noSession
	}
	
	/// ID текущего вопроса в массиве вопросов
	var currentQuestionID: Int
	
	/// Объект сессии
	weak var session: GameSession?
	
	init(session: GameSession, questionID: Int) {
		self.session = session
		currentQuestionID = questionID
	}
	
	func useFiftyFiftyClue() -> Bool? {
		let clue = GameViewController.Clues.fiftyFifty.rawValue
		guard useClue(clue: clue) != nil else { return nil }
		return true
	}
	
	func useFriendCallClue() -> Bool? {
		let clue = GameViewController.Clues.callFriend.rawValue
		guard useClue(clue: clue) != nil else { return nil }
		return true
	}
	
	func useHallHelpClue() -> Bool? {
		let clue = GameViewController.Clues.hallHelp.rawValue
		guard useClue(clue: clue) != nil else { return nil }
		return true
	}
	
	private func useClue(clue: Int) -> Bool? {
		guard let session = session else {
			return nil
		}
		guard !session.usedClues.contains(clue) else {
			return nil
		}
		session.usedClues.append(clue)
		session.currentQuestionClues.append(clue)
		
		return true
	}
}
