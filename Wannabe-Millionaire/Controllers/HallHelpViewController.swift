//
//  HallHelpViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import UIKit

/// Контроллер для отображения подсказки "Помощь зала"
final class HallHelpViewController: UIViewController {

	@IBOutlet var voteResults: [UIView]!
	@IBOutlet weak var resultView: UIView!
	
	/// Результаты голосования
	var clueData: [Int] = []
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		drawVoteResults()
    }
	
	/// Отрисовать результаты голосования
	private func drawVoteResults() {
		for (index, view) in voteResults.enumerated() {
			let width = CGFloat(self.clueData[index] * Int(self.resultView.frame.width) / 100)
			view.widthAnchor.constraint(equalToConstant: width).isActive = true
		}
	}
	
	/// Закрыть подсказку
	@IBAction func closeVoteController(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
