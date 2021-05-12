//
//  PostCell.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 12/05/21.
//

import Foundation
import UIKit

class PostCell: UITableViewCell{
    @IBOutlet weak var author: UILabel?
    @IBOutlet weak var created: UILabel?
    @IBOutlet weak var imagePost: UIImageView?
    @IBOutlet weak var numComments: UILabel?
}
