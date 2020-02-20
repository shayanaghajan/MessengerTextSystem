//
//  ViewController.swift
//  SampleTextBox
//
//  Created by Shayan Aghajan on 2/15/20.
//  Copyright © 2020 Shayan Aghajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBackground: UIView!
    @IBOutlet weak var textBoxView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBoxBottomConstraint: NSLayoutConstraint!
    
    var textContainer: [String]?
    
    let maxTextViewLines = 5
    let minTextViewContainerHeight: CGFloat = 34.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.register(UINib(nibName: "BubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "BubbleCell")
        
        textBoxView.layer.shadowColor = UIColor.gray.cgColor
        textBoxView.layer.shadowOpacity = 0.1
        textBoxView.layer.shadowRadius = 1
        
        textViewBackground.layer.cornerRadius = 10
        
        textViewBackground.layer.borderWidth = 0.1
        textViewBackground.layer.borderColor = UIColor.black.cgColor
        textViewBackground.layer.masksToBounds = true
    }
    
    @objc func keyboardHandler(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if notification.name.rawValue == "UIKeyboardWillShowNotification" {
                textBoxBottomConstraint.constant = -keyboardSize.height
            } else {
                textBoxBottomConstraint.constant = 0
            }
        }
    }
    
    //MARK: Handling TextView and TextBox
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write..." {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.sizeThatFits(CGSize(width: textView.frame.width, height: 34.0))
            textViewHeightContraint.constant = 34.0
        } else {
            textView.textColor = UIColor.black
            let textViewVerticalInset = textView.textContainerInset.bottom + textView.textContainerInset.top
            let fontLineHeight = textView.font?.lineHeight
            let maxHeight = ((fontLineHeight ?? 0) * CGFloat(maxTextViewLines)) + textViewVerticalInset
            let sizeThatFits = textView.sizeThatFits(CGSize(width: textView.frame.size.width,height:  CGFloat.greatestFiniteMagnitude))
            
            if sizeThatFits.height < minTextViewContainerHeight {
                textViewHeightContraint.constant = minTextViewContainerHeight
                textView.isScrollEnabled = false
            } else if sizeThatFits.height < maxHeight {
                textViewHeightContraint.constant = sizeThatFits.height
                textView.isScrollEnabled = false
            } else {
                textViewHeightContraint.constant = maxHeight
                textView.isScrollEnabled = true
            }
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.paragraphSpacingBefore = 2
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15.0)]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    
    @IBAction func doSendText(_ sender: UIButton) {
        self.textView.text = "Write..."
        self.textView.textColor = UIColor.gray
        self.textView.resignFirstResponder()
        textContainer = [String]()
        textContainer?.append(textView.text)
        tableView.reloadData()
    }
}

//MARK: UITableView is Here
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textContainer?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleCell", for: indexPath) as? BubbleTableViewCell {
            cell.cellText.text = textContainer?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
