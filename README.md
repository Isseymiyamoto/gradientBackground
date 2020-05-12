## はじめに

初のQiita投稿になります。

Swiftを勉強し始めて、3ヶ月強とまだ日は浅いですが、
悪戦苦闘した部分等について忘備録的な意味も含め今後記事を書いていければと思います！

コードの書き方等、何かと至らない点があるかと思いますが、
お気づきのところあれば是非アドバイスくださると助かります！！


## 完成形



GIFだとなんか色汚い感がありますね、悲しい。。

## 対象者

・ iOSアプリ開発初心者の方
・ Navigation Bar をカスタムしたいなと思っている方
・ Apple Music の歌詞表示画面のbackgroundみたいな色出してえと思ってる方()
・ CSSでlinear-gradient()を多用していた方

## 開発環境

・ Xcode Version 11.3 (11C29)
・ Swift5


## 概要

**NavigationBarの背景に綺麗なグラデーションを設定しよう！！**
ただそれだけです。。
いや、あまりに味気ないので背景色をランダムで変えるUIButtonも一応設置しました。

**実装方法**ですが、
**グラデーションから画像を生成して、backgroundImageとしてセットする** というものになります

SceneDelegate.swift等の設定説明は省いております。
もし諸設定も見たいという方がいましたら、最後にGithubのURLを貼っておくのでそちらを参照してください！！

それではやってきましょー

## あらかたのUI準備・設定

まず、あらかたのUIの準備・設定を最初にチャチャっとやります。

プロパティの設定はクロージャー記法で書いています
{}内が無名関数となっていて、()の箇所で{}を関数と捉えて直接評価しています
関数の中身をその場で実行したんでーっていう感じです

```ViewController.swift

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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
        // 以下カスタム関数。Layout.swiftに記載
        // viewの中心に配置
        ChangeColorButton.center(inView: view)
        // width, heightの設定
        ChangeColorButton.setDimensions(width: view.frame.width - 64, height: 60)
    }

    // MARK: - Selectors
    
    @objc func handleChangeBackgroundColor(){
        // navigationBarの背景色を変える処理
    }

}

```


## [本題]グラデーションから画像を生成、背景画像としてセットする

さて、いよいよ本題の部分に入ります。

ここでは、グラデーションから画像を生成、背景画像としてセットするべく2つのカスタム関数を作成します。
役割としては以下になります。

1. **navigationBarと同サイズ(safeAreaを含む)のCAGradientLayerを作成 → 2.を用いて画像セットする関数**
2. **CAGradientLayerからImageを作成する関数**


```ViewController.swift
    

    // 関数1    
    func configureNavigationBar(color1: CGColor, color2: CGColor ){

        // navigationBarがちゃんとあるか確認
        if let navigationBar = self.navigationController?.navigationBar {
            
            // CAGradientLayerの初期化
            let gradient = CAGradientLayer()
            
            // gradientがnavigationBar + safeAreaと同サイズになるよう設定
            var bounds = navigationBar.bounds
            bounds.size.height += self.additionalSafeAreaInsets.top
            gradient.frame = bounds

            // グラデーションに使用する色の設定
            gradient.colors = [color1, color2]
            
            // グラデーションの開始・終了ポイント位置を直接指定(0-1で指定する)
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            
            if let image = getImageFrom(gradientLayer: gradient) {
                // 関数2を用いて生成したimageをセットする
                navigationBar.setBackgroundImage(image, for: .default)
            }
        }
    }
    
    // 関数2
    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?

        // 以下定型文/コピペコード
        // gradientLayerと同サイズの描画環境CurrentContextに設定
        UIGraphicsBeginImageContext(gradientLayer.frame.size)

        // さっき作成した描画環境ほんまにある？
        if let context = UIGraphicsGetCurrentContext() {
            // レイヤーをcontextに描画する
            gradientLayer.render(in: context)
            // 描画されたcontextをimageに変換してresize
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }

        // 最初に設定したCurrentContextをスタックメモリー上からさようなら
        UIGraphicsEndImageContext()

        // UIImageをreturn
        return gradientImage
    }
}

```


## Buttonで色をランダムに変更

最後におまけ的に、Buttonをタップするとランダムに背景色を変更するといういらん機能を実装して終わります。

1. プロパティにcolorsというCGColorの配列を用意
2. 0〜配列の要素数-1からrandomに整数を生成して、先ほどの関数2の引数にそれを打ち込みます

本当に不必要なので、完成形のコードを貼る形で終わります。



```ViewController.swift
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
```

## まとめ

いかがでしたでしょうか？
いい感じにグラデーションかかりましたでしょうか？
Swiftを学びはじめた当初にこの問題にぶち当たり、結構時間食ったので是非誰かがこのコードコピペしてくれたら報われます

いやいや説明訳わかりませんやん。という方すみません
これから精進いたします。


## 参考にさせていただいた記事

・ [UIGraphicsBeginImageContextを脱魔術させる](https://qiita.com/yosshi4486/items/127fcb6b63dc0cd6f84a)
・ [Swift CAGradientLayer でグラデーションの色や方向を指定する方法](https://medium.com/@bj1024/swift-cagradientlayer-direct-c09e5e370f69)










