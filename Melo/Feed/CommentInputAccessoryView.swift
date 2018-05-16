//
//  CommentInputAccessoryView.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/4/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSend(for comment: String)
    func didHug(for cell: CommentInputAccessoryView)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    var post: Post?
            
    func clearCommentTextView() {
        commentTextView.text = nil
        showPlaceholderLabel()
    }
    
    func clearKeyboard() {
        commentTextView.resignFirstResponder()
    }
    
    let commentTextView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        //text.placeholder = "Add a reframe..."
        text.textAlignment = .left
        text.backgroundColor = #colorLiteral(red: 1, green: 0.9589243531, blue: 0.9180416465, alpha: 1)
        text.layer.cornerRadius = 50/2
        text.layer.masksToBounds = true
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 16)
        text.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 64)
        //text.borderStyle = .none
        return text
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add a response..."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    let sendButton: UIButton = {
        let send = UIButton(type: .system)
        //let sendButton = UIImageView(image: #imageLiteral(resourceName: "arrowUp"))
        send.translatesAutoresizingMaskIntoConstraints = false
        send.setImage(UIImage(named: "send-button"), for: .normal)
        //send.setTitle("Send", for: .normal)
        send.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.3725490196, blue: 0.937254902, alpha: 1), for: .normal)
        send.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        send.addTarget(self, action: #selector(handlePostComment), for: .touchUpInside)
        return send
    }()
    
        let hugButton: UIButton = {
        let hug = UIButton()
        hug.translatesAutoresizingMaskIntoConstraints = false
        hug.backgroundColor = #colorLiteral(red: 1, green: 0.9589243531, blue: 0.9180416465, alpha: 1)
        hug.setImage(UIImage (named: "smiley-icon"), for: .normal)
        hug.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        hug.layer.cornerRadius = 22
        hug.layer.masksToBounds = true
        hug.addTarget(self, action: #selector(handleHug), for: .touchUpInside)
        return hug
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        
        addSubview(commentTextView)
        addSubview(sendButton)
        addSubview(hugButton)
        addSubview(placeholderLabel)

        if #available(iOS 11.0, *) {
            commentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            hugButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        }
        else {
        }
        
        commentTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        commentTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: hugButton.leadingAnchor, constant: 8)
        
        placeholderLabel.leadingAnchor.constraint(equalTo: commentTextView.leadingAnchor, constant: 18).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: self.commentTextView.centerYAnchor).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: self.commentTextView.trailingAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.commentTextView.bottomAnchor, constant: -22).isActive = true
        
        hugButton.leadingAnchor.constraint(equalTo: self.commentTextView.trailingAnchor, constant: 10).isActive = true
        hugButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        hugButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        hugButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        //hugButton.centerYAnchor.constraint(equalTo: self.commentTextView.centerYAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: .UITextViewTextDidChange, object: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handleTextChanged() {
        placeholderLabel.isHidden = !self.commentTextView.text.isEmpty
    }
    
    @objc func handlePostComment() {
        guard let commentText = commentTextView.text else {return}
        delegate?.didSend(for: commentText)
        
    }
    
    @objc func handleHug() {
        print("You have been hugged")
        delegate?.didHug(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

