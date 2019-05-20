//
//  ViewController.swift
//  MokouVoiceForGitHub
//
//  Created by 戸高新也 on 2019/05/21.
//  Copyright © 2019 戸高新也. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var player = AVAudioPlayer()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var segmentedControll: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["応答1","応答2","暴言","名言","マリカ"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .white
        sc.setTitleTextAttributes([NSAttributedString.Key.font :UIFont.systemFont(ofSize: UIDevice.current.iPad ? 20 : 12)], for: .normal)
        sc.addTarget(self, action: #selector(handleVoicesChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var voicesArray = [[String]]()

    var playedOnce  = false
    
    private let outou1Names =  [
        "あれぇ！？","うー☆","キター","ギュアアアアア","よっしゃ荒せ","笑い声","俺このチャンスを待っててん",
        "血も涙も無い","んーごめんごめんごめん","おかしいおかしいないないない","僕に謝罪してください",
        "なんてパワーだずんずん押し上げてくる","あれれれれれれれれ","すんませんすんませんすんませんすんません"
        ,"許して頂けますでしょうか","楽しいですか夏休みの方は","僕の逆鱗に触れました","全部嘘です"
        ,"ほらねぇ！？","なんで分かるか教えて欲しい？","おちえない！","あ？","おーん","やめなぁい"
    ]
    
    private let outou2Names = [
        "おはようございます","おはようございます！","挨拶くらいちゃんとやろうや","もこうだぁ"
        ,"よろしくお願いします","はいもしもし","ナニ？","涙目になんなって"
        ,"さようなら","こんばんわ","おい","はい","はい！","ヒルナンデス観たんですけれども","なんか、あるんすか...","あーはいはいはい"
    ]
    
    private let bougenNames = [
        "放送始めるなり何だお前","なぁ書いてるやつこれなぁ","ヤフミだのうんこちゃんだの","始める前から配信者の気分損ねんなよ",
        "しばき倒すすぞこのクソガキが","謝罪しろ今すぐ","クソが","ク、クソが","クソが！","クソガンモ！",
        "びびらすなシャバ僧が","ふざけんなよお前ぇ","ふっざっけんなよマジでおい","大人しくしてりゃいい気になりおってコラ",
        "ヴォイ！","綺麗事抜かすな！","バカですか？","リアルファイトしようぜ","クズだよお前は","ラムの実はねぇよ！",
        "頭の中お花畑だこいつは","なんやこの深海魚！","しばくぞオラァ！！","あー！ふざけんなよまじでー！"]
    
    private let meigenNames = [
        "勇気の切断","冷凍ビームしかありえない","変態型の厨ポケが厨ポケじゃないとかいうやつおるけど","氷の礫のPPは１にすべき","先方猿濃厚","人に作らせて搾取するのが一番なんですわぁ","真の強者は不意打ちを外さない","常人なら今頃Wiiぶっ壊してるわ","重くないかその称号","謝罪をしないということ事態が謝罪である","偶然から必然への昇華となる","起死回生の降参","何やこの厨パァ","マンダは初手竜舞や","マンダの流星群は強い","はいお湯ー","なんか焼却的だなぁ", "うんたんうんたんうんたん！","アクセントはしにあります","舞い降りろ急所の神よ","八割七部一輪","騙っとんちゃうぞこら！","糞葉寿司","耐久型ポケモン涙目"]
    
    private let marikaNames = [
        "ふざけんなよええ加減にせえよ","空気読めお前","人種差別すんなよお前らぁ","あぽろどけお前","ほんまクソゲーやなこれぇ","あーもうなんで狙ってくんねんガキがコラ","キター○ね！","俺がペロペロしてあげようかな","俺ってロリコンなんかいなひょっとしたら","もーだからぁ”ー","あ”ーもうくそハゲェ","いやぁ”ー","もーほんま最後のアイテムで結局決まるんじゃねぇかこのゲーム","○ねよ、○すぞ？","ヘタクソがよぉ〜","ほんまにしーおらー","これ当たったらマジしばく","やーめた","なんでこんな下手くそなん俺","う”ーーなんか今ラグったな","もー本当に嫌いすぎてやべぇ","ふざけんな盗人がよぉ","何に当たったか説明してまず今のなぁ","えーお前そこであたるかよぉ〜"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(segmentedControll)
        
        voicesArray = [outou1Names,outou2Names,bougenNames,meigenNames,marikaNames]
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.register(VoiceCell.self, forCellWithReuseIdentifier: cellId)
        
        segmentedControll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        segmentedControll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        segmentedControll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        segmentedControll.heightAnchor.constraint(equalToConstant: UIDevice.current.iPad ? 80 : 60).isActive = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector:#selector(appMovedToBackground) , name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    @objc func appMovedToBackground(){
        if playedOnce{
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    
    @objc func handleVoicesChange(){
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VoiceCell
        cell.voiceNameLabel.text = String(voicesArray[segmentedControll.selectedSegmentIndex][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voicesArray[segmentedControll.selectedSegmentIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let leftRightPadding = UIDevice.current.iPad ? view.frame.width * 0.05 : view.frame.width * 0.05
        let interSpacing = UIDevice.current.iPad ? view.frame.width * 0.07 : view.frame.width * 0.07
        let width = view.frame.width
        
        let cellWidth = UIDevice.current.iPad ? (width - leftRightPadding * 2 - interSpacing * 3) /  4 - 10 : (width - leftRightPadding * 2 - interSpacing * 3) / 4
        
        return .init(width: cellWidth, height: cellWidth)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let leftRightPadding = UIDevice.current.userInterfaceIdiom == .pad ? view.frame.width * 0.05 :
            view.frame.width * 0.05
        
        return .init(top: 16, left: leftRightPadding, bottom: 16, right: leftRightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        playedOnce = true
        
        let audioPath = Bundle.main.path(forResource: voicesArray[segmentedControll.selectedSegmentIndex][indexPath.row], ofType: "mp3")
        let audioUrl = URL(fileURLWithPath: audioPath!)
        
        do {
            
            try player = AVAudioPlayer(contentsOf: audioUrl)
            player.play()
            
        }catch{
            
            print(error)
            
        }
    }
}


