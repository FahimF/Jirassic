//
//  ComputerWakeUpInteractor.swift
//  Jirassic
//
//  Created by Baluta Cristian on 27/12/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class ComputerWakeUpInteractor: RepositoryInteractor {
    
	func runWithLastSleepDate (_ date: Date?) {
		
		let reader = ReadTasksInteractor(data: data)
		let existingTasks = reader.tasksInDay(Date())
		if existingTasks.count > 0 {
			// We already started the day, analyze if it's scrum time
			if TaskFinder().scrumExists(existingTasks) {
				let task = Task(dateEnd: Date(), type: TaskType.scrum)
                let saveInteractor = TaskInteractor(data: localRepository)
                saveInteractor.saveTask(task)
				InternalNotifications.notifyAboutNewlyAddedTask(task)
			}
		} else {
			// This might be the start of the day. Should we start counting automatically or wait the user to press start?
			
		}
	}
}
