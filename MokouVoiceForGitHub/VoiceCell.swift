//
//  VoiceCell.swift
//  MokouVoiceForGitHub
//
//  Created by 戸高新也 on 2019/05/21.
//  Copyright © 2019 戸高新也. All rights reserved.
//

import Foundation


import UIKit

class VoiceCell: UICollectionViewCell{
    
    let voiceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let defaultColor = UIColor(r: 1, g: 101, b: 161)
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor.white : defaultColor
            voiceNameLabel.textColor = isHighlighted ? defaultColor : .white
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = defaultColor
        voiceNameLabel.font = .systemFont(ofSize: sizeOfText())
        
        voiceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        voiceNameLabel.textAlignment = .center
        addSubview(voiceNameLabel)
        voiceNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        voiceNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        voiceNameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        voiceNameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 6
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = UIDevice.current.iPad ?  1.5 : 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sizeOfText() -> CGFloat{
        if UIDevice.current.iPad {
            return 19
        }else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
            return 11
        }else{
            return 13
        }
    }
}

