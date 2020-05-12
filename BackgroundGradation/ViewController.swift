//
//  ViewController.swift
//  BackgroundGradation
//
//  Created by 宮本一成 on 2020/05/11.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var ChangeColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleChangeBackgroundColor), for: .touchUpInside)
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.yellow.cgColor,
                          UIColor.systemPink.cgColor, UIColor.darkGray.cgColor, UIColor.systemGreen.cgColor,
                          UIColor.black.cgColor, UIColor.lightGray.cgColor]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar(color1: UIColor.red.cgColor, color2: UIColor.blue.cgColor)
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        // navigationBarに関する諸設定
        self.title = "Gradient Color"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        
        // viewの背景色
        view.backgroundColor = .white
        
        // buttonの配置
        view.addSubview(ChangeColorButton)
        ChangeColorButton.center(inView: view)
        ChangeColorButton.setDimensions(width: view.frame.width - 64, height: 60)
    }
    
    func configureNavigationBar(color1: CGColor, color2: CGColor ){
        
        if let navigationBar = self.navigationController?.navigationBar {
            let gradient = CAGradientLayer()
            var bounds = navigationBar.bounds
            bounds.size.height += self.additionalSafeAreaInsets.top
            gradient.frame = bounds
            gradient.colors = [color1, color2]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            
            if let image = getImageFrom(gradientLayer: gradient) {
                // navigationBarに生成したimageをセットする
                navigationBar.setBackgroundImage(image, for: .default)
            }
        }
    }
    
    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    // MARK: - Selectors
    
    @objc func handleChangeBackgroundColor(){
        // navigationBarの色を変える処理をかく
        let random1 = Int.random(in: 0 ..< colors.count)
        let random2 = Int.random(in: 0 ..< colors.count)
        
        configureNavigationBar(color1: colors[random1], color2: colors[random2])
    }
    
    
}

