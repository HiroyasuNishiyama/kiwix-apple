//
//  LibraryAlerts.swift
//  Kiwix
//
//  Created by Chris Li on 9/14/16.
//  Copyright © 2016 Chris. All rights reserved.
//

import UIKit
import Operations

class SpaceNotEnoughAlert: AlertOperation<UIViewController> {
    init(context: UIViewController) {
        super.init(presentAlertFrom: context)
        
        title = LocalizedStrings.Library.spaceNotEnough
        message = NSLocalizedString("Please free up some space and try again.", comment: "Library, Space Alert")
        addActionWithTitle(LocalizedStrings.cancel)
    }
}

class SpaceCautionAlert: AlertOperation<UIViewController> {
    init(context: UIViewController, bookID: String) {
        super.init(presentAlertFrom: context)
        
        title = NSLocalizedString("Space Alert", comment: "Library, Space Alert")
        message = NSLocalizedString("This book will take up more than 80% of your free space after downloaded.", comment: "Library, Space Alert")
        addActionWithTitle(NSLocalizedString("Download Anyway", comment: "Library, Space Alert"), style: .Destructive) { _ in
            guard let download = DownloadBookOperation(bookID: bookID) else {return}
            Network.shared.queue.addOperation(download)
        }
        addActionWithTitle(LocalizedStrings.cancel)
        preferredAction = actions[0]
    }
}
