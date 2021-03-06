//
//  TaskCellPresenter.swift
//  Jirassic
//
//  Created by Baluta Cristian on 27/11/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TaskCellPresenter: NSObject {

	var cell: CellProtocol?
	
	convenience init (cell: CellProtocol) {
		self.init()
		self.cell = cell
	}
	
	func present (previousTask: Task?, currentTask theTask: Task) {
		
		var duration = ""
		var statusImage: NSImage?
		
        if let thePreviosData = previousTask {
            // When we have a previous item to compare dates with
            switch (Int(theTask.taskType.int32Value)) {
                
            case TaskType.issue.rawValue:
                let diff = theTask.endDate.timeIntervalSince(thePreviosData.endDate as Date)
                duration = Date(timeIntervalSince1970: diff).HHmmGMT()
                statusImage = NSImage(named: NSImageNameStatusAvailable)
                break
                
            case TaskType.gitCommit.rawValue:
                let diff = theTask.endDate.timeIntervalSince(thePreviosData.endDate as Date)
                duration = Date(timeIntervalSince1970: diff).HHmmGMT()
                statusImage = NSImage(named: "GitIcon")
                break
                
            default:
                statusImage = NSImage(named: NSImageNameStatusUnavailable)
            }
        } else {
            statusImage = nil
        }
		
		cell?.data = (
			dateEnd: theTask.endDate,
			taskNumber: theTask.taskNumber ?? "",
			notes: theTask.notes ?? ""
		)
		cell?.duration = duration
		cell?.statusImage?.image = statusImage
	}
}
