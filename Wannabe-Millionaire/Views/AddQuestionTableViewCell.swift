//
//  AddQuestionTableViewCell.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import UIKit

/// Ячейка для добавления вопросов в приложение
final class AddQuestionTableViewCell: UITableViewCell {

	@IBOutlet weak var questionText: UITextField!
	@IBOutlet weak var correctAnswer: UITextField!
	@IBOutlet weak var answerTwo: UITextField!
	@IBOutlet weak var answerThree: UITextField!
	@IBOutlet weak var answerFour: UITextField!
	@IBOutlet weak var addButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = .black
	}
}
