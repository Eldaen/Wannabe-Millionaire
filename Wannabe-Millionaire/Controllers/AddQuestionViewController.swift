//
//  AddQuestionViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import UIKit

/// Контроллер добавления вопросов в игру
final class AddQuestionViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = self
		tableView.backgroundColor = .black
		tableView.register(UINib(nibName: "AddQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "AddQuestionTableViewCell")
    }
}

extension AddQuestionViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuestionTableViewCell") as? AddQuestionTableViewCell
		else {
			return UITableViewCell ()
		}
		
		return cell
	}
}
