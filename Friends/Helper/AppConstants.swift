//
//  AppConstants.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//

class AppConstants {
    static let numberOfFriends = 10
    static let friendsUrl = "https://randomuser.me/api/"
    struct Cells {
        static let FriendCell = "FriendCell"
    }
    struct CollectionViewSettings {
        static let numberOfColumns = 3
        static let spacing = 1.5
    }
    struct CollectionCellDesignConstants {
        static let baseCellWidth = 180
        static let baseImageWidth = 100
    }
    struct AlertMessages {
        static let infoNotAvailable = "Information not available"
        static let errorMessage = "Something went wrong. Please try again later"
    }
    struct ViewControllers {
        static let DetailsViewController = "DetailsController"
    }
}
