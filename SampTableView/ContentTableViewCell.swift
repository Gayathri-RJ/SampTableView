//
//  ContentTableViewCell.swift
//  SampTableView
//
//  Created by Gayathri on 15/03/22.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
