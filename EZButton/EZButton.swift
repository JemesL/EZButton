//
//  EZButton.swift
//  EZButton
//
//  Created by Jemesl on 2019/9/16.
//  Copyright © 2019 Jemesl. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum EZButtonDistribution {
    // 左图 右字
    case leftIconRightTitle
    // 左字 右图
    case leftTitleRightIcon
    // 上图 下字
    case topIconBottomTitle
    // 上字 下图
    case topTitleBottomIcon
}

// 内容对其方式
enum EZButtonAlignemnt {
    case topCenter
    case leftCenter
    case bottomCenter
    case rightCenter
    case center
    case leftTop
    case leftBottom
    case rightTop
    case rightBottom
}

// TODO: EZButton.title 的内边距可设置功能
// 自定义button 可代替 UIButton, 可灵活布局内部内容
class EZButton: UIControl {

    fileprivate var hasIcon: Bool { get { return icon.image != nil } }
    fileprivate var hasText: Bool { get { return title.text != nil } }

    // ************ 可设置 title 和 icon 的属性(非 .text & .image) ************
    // 不可以通过title 来设置text
    lazy var title = UILabel()
    // 不可以通过icon 来设置image
    lazy var icon = UIImageView()
    
    var bg = UIView()

    // ************ 可设置 EZButton 相关属性 ************
    // 设置图片: 如果为nil, 则不渲染icon
    var image: UIImage? {
        didSet {
            icon.image = image
            setNeedsLayout()
        }
    }
    // 设置文字: 如果为nil, 则不渲染title
    var text: String? {
        didSet {
            title.text = text
            setNeedsLayout()
        }
    }
    // 对其方式
    var alignemnt: EZButtonAlignemnt = .center { didSet { setNeedsLayout() } }
    // 排布方式
    var distribution: EZButtonDistribution = .leftTitleRightIcon  { didSet { setNeedsLayout() } }
    // 内容边距
    var edge = UIEdgeInsetsMake(0, 0, 0, 0) { didSet { setNeedsLayout() } }
    // title 和icon 之间的间距
    var space: CGFloat = 10 { didSet { setNeedsLayout() } }
    // icon 大小
    var imageSize: CGSize = CGSize(width: 10, height: 10)  { didSet { setNeedsLayout() } }
    
    var offset: CGFloat = 0 { didSet { setNeedsLayout() } }
    
    override var backgroundColor: UIColor? {
        didSet {
            self.bg.backgroundColor = self.backgroundColor
        }
    }

    // ************ 可获取 EZButton 相关属性 ************
    // 获取宽度
    var adoptWidth: CGFloat {
        get {
            return calWidth()
        }
    }
    
    // 获取高度
    var adoptHeight: CGFloat {
        get {
            return calHeight()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentConstraints()
    }
    
    @objc func injected() {
        setupViews()
        updateContentConstraints()
    }
}

// MARK: - 宽高计算
extension EZButton {
    fileprivate func getTitleWidth() -> CGFloat {
        return (title.text?.getLabelWidth(font: (title.font)!, height: 0) ?? 0) + 1
    }

    fileprivate func getTitleHeight() -> CGFloat {
        return title.text?.getLabelHeight(font: (title.font)!, width: getTitleWidth()) ?? 0
    }

    fileprivate func getIconWidth() -> CGFloat {
        return imageSize.width
    }

    fileprivate func getIconHeight() -> CGFloat {
        return imageSize.height
    }
    
    private func calWidth() -> CGFloat {
        switch distribution {
        case .leftTitleRightIcon, .leftIconRightTitle:
            var width: CGFloat = 0
            if hasText { width += getTitleWidth() }
            if hasIcon { width += getIconWidth() }
            if hasText && hasIcon { width += space }
            width += edge.left + edge.right
            return width
        case .topTitleBottomIcon, .topIconBottomTitle:
            var width: CGFloat = 0
            var textWidth: CGFloat = 0
            var iconWidth: CGFloat = 0
            if hasText { textWidth = getTitleWidth() }
            if hasIcon { iconWidth = getIconWidth() }
            width = max(textWidth, iconWidth)
            width += edge.left + edge.right
            print(width)
            return width
        }
    }
    
    private func calHeight() -> CGFloat {
        switch distribution {
        case .leftTitleRightIcon, .leftIconRightTitle:
            var height: CGFloat = 0
            var textHeight: CGFloat = 0
            var iconHeight: CGFloat = 0
            if hasText { textHeight = getTitleHeight() }
            if hasIcon { iconHeight = getIconHeight() }
            height = max(textHeight, iconHeight)
            height += edge.top + edge.bottom
            return height
        case .topTitleBottomIcon, .topIconBottomTitle:
            var height: CGFloat = 0
            if hasText { height += getTitleHeight() }
            if hasIcon { height += getIconHeight() }
            if hasText && hasIcon { height += space }
            height += edge.top + edge.bottom
            return height
        }
    }
}

// MARK: - 约束布局
extension EZButton {
    fileprivate func setupViews() {
        backgroundColor = .lightGray
        bg.backgroundColor = .white
        addSubview(bg)
        
        bg.addSubview(title)
        bg.addSubview(icon)
    }
    
    fileprivate func updateContentConstraints() {
        print("updateContentConstraints")
        guard superview != nil else { return }

        if !hasText && !hasIcon {
            updateNoneConstraints()
            return
        }
        // 只有文字的情况
        if hasText && !hasIcon {
            updateOnlyTitleConstraints()
            return
        }
        // 只有icon的情况
        if hasIcon && !hasText {
            updateOnlyIconConstraints()
            return
        }
        // 既有文字也有icon
        switch distribution {
        case .leftTitleRightIcon, .leftIconRightTitle :
            updateLeftRightConstraints()
        case .topIconBottomTitle, .topTitleBottomIcon:
            updateTopBottomConstraints()
        }
    }

    fileprivate func updateNoneConstraints() {
        
        bg.snp.removeConstraints()
        title.snp.removeConstraints()
        icon.snp.removeConstraints()
        icon.isHidden = true
        title.isHidden = true
//        bg.isHidden = true
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(edge)
        }
    }

    fileprivate func updateOnlyIconConstraints() {
        cleanContraints(displayTitle: false, diplayIcon: true)
        icon.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero).priority(.high)
            make.size.equalTo(imageSize)
        }
    }
    
    fileprivate func updateOnlyTitleConstraints() {
        cleanContraints(displayTitle: true, diplayIcon: false)
        title.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    fileprivate func updateLeftRightConstraints() {
        cleanContraints(displayTitle: true, diplayIcon: true)
        var leftView: UIView?
        var rightView: UIView?
        if distribution == .leftTitleRightIcon {
            leftView = title
            rightView = icon
        } else if distribution == .leftIconRightTitle {
            leftView = icon
            rightView = title
        }
        
        guard let left = leftView, let right = rightView else { return }
        
        left.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.left.equalTo(0)
            make.top.greaterThanOrEqualTo(0).priority(.low)
            make.bottom.lessThanOrEqualTo(0).priority(.low)
            if distribution == .leftIconRightTitle {
                make.size.equalTo(self.imageSize)
            }
            if alignemnt == .topCenter || alignemnt == .leftTop || alignemnt == .rightTop {
                make.top.equalTo(right).offset(offset)
            } else if alignemnt == .bottomCenter || alignemnt == .leftBottom || alignemnt == .rightBottom {
                make.bottom.equalTo(right).offset(offset)
            } else {
                make.centerY.equalTo(right)
            }

        }
        right.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.left.equalTo(left.snp.right).offset(self.space)
            make.top.greaterThanOrEqualTo(0).priority(.low)
            make.bottom.lessThanOrEqualTo(0).priority(.low)
            make.right.equalTo(0)
            if distribution == .leftTitleRightIcon {
                make.size.equalTo(self.imageSize)
            }
        }
    }
    
    fileprivate func updateTopBottomConstraints() {
        cleanContraints(displayTitle: true, diplayIcon: true)
        
        var topView: UIView?
        var bottomView: UIView?
        if distribution == .topTitleBottomIcon {
            topView = title
            bottomView = icon
        } else if distribution == .topIconBottomTitle {
            topView = icon
            bottomView = title
        }
        
        guard let top = topView, let bottom = bottomView else { return }
        top.snp.makeConstraints {[weak self] make in
            guard let self = self else { return }
            make.left.greaterThanOrEqualTo(0).priority(.low)
            make.right.lessThanOrEqualTo(0).priority(.low)
            make.top.equalTo(0)
            if distribution == .topIconBottomTitle {
                make.size.equalTo(self.imageSize)
            }
            
            switch alignemnt {
            case .leftCenter, .leftBottom, .leftTop:
                make.left.equalTo(bottom).offset(offset)
            case .rightCenter, .rightBottom, .rightTop:
                make.right.equalTo(bottom).offset(offset)
            default:
                make.centerX.equalTo(bottom)
            }
        }
        bottom.snp.makeConstraints {[weak self] make in
            guard let self = self else { return }
            make.top.equalTo(top.snp.bottom).offset(self.space)
            make.left.greaterThanOrEqualTo(0).priority(.low)
            make.right.lessThanOrEqualTo(0).priority(.low)
            make.bottom.equalTo(0)
            if distribution == .topTitleBottomIcon {
                make.size.equalTo(self.imageSize)
            }
        }
    }
    
    func cleanContraints(displayTitle: Bool, diplayIcon: Bool) {
        
        title.snp.removeConstraints()
        icon.snp.removeConstraints()
        icon.isHidden = !diplayIcon
        title.isHidden = !displayTitle
    
        updateBGConstraints()
    }
    
    func updateBGConstraints() {
        bg.snp.removeConstraints()
        bg.snp.makeConstraints { make in
            if distribution == .leftIconRightTitle || distribution == .leftTitleRightIcon {
                let maxHeight = max(getIconHeight(), getTitleHeight())
                make.height.equalTo(maxHeight)
            } else {
                let maxWidth = max(getIconWidth(), getTitleWidth())
                make.width.equalTo(maxWidth)
            }

            if alignemnt == .topCenter {
                setBG(make: make, dirctionArr: (true, false, false, false))
                make.centerX.equalToSuperview()
            }
            if alignemnt == .leftCenter {
                setBG(make: make, dirctionArr: (false, true, false, false))
                make.centerY.equalToSuperview()
            }
            if alignemnt == .bottomCenter {
                setBG(make: make, dirctionArr: (false, false, true, false))
                make.centerX.equalToSuperview()
            }
            if alignemnt == .rightCenter {
                setBG(make: make, dirctionArr: (false, false, false, true))
                make.centerY.equalToSuperview()
            }
            if alignemnt == .center {
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                setBG(make: make, dirctionArr: (false, false, false, false))
            }
            if alignemnt == .leftTop {
                setBG(make: make, dirctionArr: (true, true, false, false))
            }
            if alignemnt == .leftBottom {
                setBG(make: make, dirctionArr: (false, true, true, false))
            }
            if alignemnt == .rightTop {
                setBG(make: make, dirctionArr: (true, false, false, true))
            }
            if alignemnt == .rightBottom {
                setBG(make: make, dirctionArr: (false, false, true, true))
            }
        }
        
        func setBG(make: ConstraintMaker, dirctionArr: (Bool, Bool, Bool, Bool)) {
            let (top, left, bottom, right) = dirctionArr
            
            let _ = top ? make.top.equalTo(edge.top) : make.top.greaterThanOrEqualTo(edge.top)
            let _ = left ? make.left.equalTo(edge.left) : make.left.greaterThanOrEqualTo(edge.left)
            let _ = bottom ? make.bottom.equalTo(-edge.bottom) : make.bottom.lessThanOrEqualTo(-edge.bottom)
            let _ = right ? make.right.equalTo(-edge.right) : make.right.lessThanOrEqualTo(-edge.right)
        }

    }
}
