//
//  XZSlider.swift
//  PeopleLight
//
//  Created by 典爆mac on 2017/10/18.
//  Copyright © 2017年 smartit. All rights reserved.
//

import UIKit

public protocol XZSliderDelegate {
    
    func changeActionComplete(index:Int,value:Double)
}
class XZSlider: UIView {
    
    var defaultValue : Float = 1
    
    var delegate : XZSliderDelegate?
    //数据
    var values: [Double]!
    {
        didSet{
            self.creatView(values: self.values)
        }
    }
    
    var thumbImage : UIImage = UIImage.init(named: "k进度点")!
    //背景颜色
    var backColor: UIColor = UIColor.gray
    //进度颜色
    var progressColor: UIColor = UIColor.red
    //背景
    fileprivate var backView: UIView!
    //进度
    fileprivate var progressView: UISlider!
    
    //进度
    var progress : Double = 0.0
    
    /// 选择回调事件
    var changeActionComplete:(_ index:Int,_ value:Double)->() = ({_ in
        
    })
    
    init(frame: CGRect,values:[Double]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.values = values
        self.creatView(values: self.values)
    }
    
    func creatView(values:[Double]) {
        if values.count < 2 {
            return
        }
        for item in values{
            if item > 2 {
                return
            }
        }
        self.isHidden = true
        self.bounds.size.height  = self.bounds.size.height > 30 ? 30 : self.bounds.size.height
        backView = UIView.init(frame: self.bounds)
        backView.backgroundColor = backColor
        
        backView.layer.cornerRadius = self.bounds.size.height / 2
        backView.layer.masksToBounds = true
        
        progressView = UISlider.init(frame: CGRect.init(x: 15, y: 0, width: self.bounds.size.width - 30, height: 20))
        progressView.minimumTrackTintColor = colorFromHex("eeeeee")
        progressView.maximumTrackTintColor = colorFromHex("eeeeee")

        progressView.setThumbImage(thumbImage, for: UIControlState.normal)
        progressView.setThumbImage(thumbImage, for: UIControlState.selected)
        progressView.addTarget(self, action: #selector(self.valueChanging(sender:)), for: UIControlEvents.valueChanged)
        progressView.addTarget(self, action: #selector(self.valueChanged(sender:)), for: UIControlEvents.touchUpInside)
        progressView.minimumValue = Float(values.first!)
        progressView.maximumValue = Float(values.last!)
        progressView.value = defaultValue
        
        self.addSubview(backView)
        let width: CGFloat = (self.bounds.size.width - 30) / CGFloat(values.count - 1)
        let height: CGFloat = 10
        for i in 0...values.count - 1 {
            let btn = UIButton.init(frame: CGRect.init(x: 15 + width*CGFloat(i) - width / 2, y: 18, width: width, height: height))
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.setTitle("\(values[i])", for: UIControlState.normal)
            self.addSubview(btn)
        }
        self.addSubview(progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func showView() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        }) { (true) in
        }
    }
    func hideView() {
        self.alpha = 1
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (true) in
            self.isHidden = true
        }
    }
    func valueChanging(sender:Any) {
    }
    func valueChanged(sender:Any) {
        for i in 0...values.count - 2 {
            let item1 = values[i]
            let item2 = values[i+1]
            if  Double(progressView.value) >= item1 && Double(progressView.value) <= item2 {
                progressView.value = (item1 + item2)/Double(2) > Double(progressView.value) ? Float(item1) : Float(item2)
                
                let index = (item1 + item2)/Double(2) > Double(progressView.value) ? i : i+1
                let value = (item1 + item2)/Double(2) > Double(progressView.value) ? item1 : item2
                changeActionComplete(index,value)
                return
            }
        }
    }
}

func enableAudioTracks(enable:Bool, inplayerItem playeritem:AVPlayerItem) {
    for item in playeritem.tracks {
        if item.assetTrack.mediaType == AVMediaTypeAudio {
            item.isEnabled = enable
        }
    }
}

