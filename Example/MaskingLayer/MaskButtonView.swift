//
//  MaskButtonObject.swift
//  MaskMatte
//
//  Created by 永田大祐 on 2019/11/06.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

class MaskButtonView: UIView {

    let cameraMatte = UIButton()
    let cameraRecord = UIButton()
    
    private var originY : CGFloat = 25
    private var btWidthHeight : CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)

        btDesgin(frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func btDesgin(_ tab: CGRect) {

        cameraMatte.frame = CGRect(x: (tab.width) / 2 - (originY+btWidthHeight), y: (tab.height) / 2 - originY, width: btWidthHeight, height: 50)
        cameraMatte.backgroundColor = .red
        cameraMatte.layer.cornerRadius = cameraMatte.frame.height/2

        cameraRecord.frame = CGRect(x: (tab.width) / 2 + originY, y: (tab.height) / 2 - originY, width: btWidthHeight, height: btWidthHeight)
        cameraRecord.backgroundColor = .blue
        cameraRecord.layer.cornerRadius = cameraRecord.frame.height/2
    }
}
