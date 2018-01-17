//
//  ViewController.swift
//  EmojiPhoto
//
//  Created by Xue Yu on 1/12/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate,
UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self.dropZone)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centeredAt: dropPoint)
            }
        }
    }
    
    
    func addLabel(with attributedString: NSAttributedString, centeredAt point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        dropZone.addSubview(label)
    }
    
    var emojis = "😀🎁✈️🎱🍎🐶🐝☕️🎼🚲♣️👨‍🎓✏️🌈🤡🎓👻☎️".map { String($0) }

    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            // https://stackoverflow.com/questions/45684720/dragging-from-a-collection-view-works-on-the-ipad-but-not-on-the-iphone-how-co
            emojiCollectionView.dragInteractionEnabled = true

        }
    }
    
    // MARK: - data source
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    // section 0 as adding emoji or plus button
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return emojis.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? EmojiCollectionViewCell {
                let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font:font])
                emojiCell.label.attributedText = text
            }
            return cell
        } else if addingEmoji {
            // if we're adding emoji, we'll put the input cell there
            // and whenever this addingEmoji is true, we'll reload section 0
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiInputCell", for: indexPath)
            
            if let inputCell = cell as? TextFieldCollectionViewCell {
                inputCell.resignationHanlder = { [weak self, unowned inputCell] in
                    if let text = inputCell.textField.text {
                        self?.emojis = (text.map{ String($0) } + self!.emojis).uniquified
                    }
                    self?.addingEmoji = false
                    self?.emojiCollectionView.reloadData()
                }
            }
            
            return cell
        } else {
            
            // if we're not adding emoji, we'll put add button there
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
            return cell
            
        }

    }
    
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    // when input, make the size wider
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    

    // MARK: - UICollectionViewDelegate
    
    // actually this calls out the keyboard
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldCollectionViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }
    // MARK:  - drag delegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // disable dragging when adding emoji
        if !addingEmoji {
            let attributedString = NSAttributedString(string: emojis[indexPath.item], attributes: [.font:font])
            let item = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            return [item]
        } else {
            return []
        }
    }
    
    // MARK: - drop delegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MAKR: - adding emoji
    
    private var addingEmoji = false
    
    @IBAction func addEmoji() {
        addingEmoji = true
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }


}

extension Array where Element: Equatable {
    var uniquified: [Element] {
        var elements = [Element]()
        forEach { if !elements.contains($0) { elements.append($0) } }
        return elements
    }
}

