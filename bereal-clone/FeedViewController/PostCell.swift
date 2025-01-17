//
//  PostCell.swift
//  bereal-clone
//
//  Created by Phuong Anh Le on 3/26/23.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    
    private var imageDataRequest: DataRequest?
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    func configure(with post: Post) {
        // Username
        if let user = post.user {
            nameLabel.text = user.username
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }

}
