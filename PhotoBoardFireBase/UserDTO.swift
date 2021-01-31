//
//  UserDTO.swift
//  PhotoBoardFireBase
//
//  Created by jh on 2021/01/31.
//

import UIKit

@objcMembers
class UserDTO: NSObject {
    var explaination: String?
    var imageUrl: String?
    var subject: String?
    var uid: String?
    var userId: String?
    var likeCount: NSNumber?
    var likes: [String:Bool]?
    var imageName: String?
}
