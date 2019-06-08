//
//  PostUI.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire


class PostUI {
    var delegate : PostViewController
    var scrollBar : UIScrollView!
    var likeNoLabel = UILabel(frame: .zero)
    var commentView = UIView(frame: .zero)
    var commentText = UITextField(frame: .zero)
    var likeButton = UIButton(type: .custom)
    var isPostLiked = false
    var countPostLikes = -1
    var peopleCommentsView = UIView(frame: .zero)
    var myDisposeBag = DisposeBag()
    var cursurY : CGFloat = 20
    let marginX : CGFloat = 20
    let marginY : CGFloat = 20
    var postImage = UIImageView()
    var commentHeight : CGFloat = 0
    init (_ vc : PostViewController){
        self.delegate = vc
        self.subscribeToPostDetail()
    }
    
    @objc func sendComment(_ sender : Any){
        self.delegate.view.endEditing(true)
        Spinner.start()
        (sender as! UIButton).setDisable()
        let aParameter = ["shop_id":"\(NetworkManager.shared.postDetailObs.value.shopId!)","post_id":"\(NetworkManager.shared.postDetailObs.value.id!)","body":"\(commentText.text!)"]
        print("Sending comment .... : ",aParameter)
        NetworkManager.shared.run(API: "send-comment", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: false)
        let commentSendDisp = NetworkManager.shared.commentSendingSuccessful
            .filter({$0 == true})
            .subscribe(onNext: { [unowned self] (succeed) in
                self.delegate.alert(Message: "نظر شما ثبت شد")
                NetworkManager.shared.commentSendingSuccessful = BehaviorRelay<Bool>(value: false)
                self.commentText.text = ""
                (sender as! UIButton).setEnable()
                self.delegate.getPostData()
                Spinner.stop()
            })
        commentSendDisp.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(commentSendDisp)
        
        let statusDisp = NetworkManager.shared.status
            .filter({$0 == CallStatus.error || $0 == CallStatus.InternalServerError})
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { innerStatus in
                Spinner.stop()
                (sender as! UIButton).setEnable()
            })
        statusDisp.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(statusDisp)
    }
    
    func subscribeToPostDetail(){
        let sharedPostObs = NetworkManager.shared.postDetailObs
            //.share(replay: 1, scope: .whileConnected)
            .observeOn(MainScheduler.instance)
            .filter({$0.id != nil && $0.shopId != nil})
            .subscribe(onNext: { aPostDetail in
                let aCommentsArray = aPostDetail.comments
                print("Updating/Building POSTVIEW  ")
                self.isPostLiked = aPostDetail.isLiked!
                if self.countPostLikes == -1 {
                    self.countPostLikes = aPostDetail.countLike!
                }
                print("isPostLiked : ",self.isPostLiked,"  self.countPostLikes : ",self.countPostLikes)
                DispatchQueue.main.async {
                    self.buildPostView(With: aPostDetail)
                    self.buildCommentView(With: aCommentsArray ?? [])
                }
            }
        )
        sharedPostObs.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(sharedPostObs)
    }
    
    func buildPostView(With innerPost : Post){
        cursurY = 20
        var postView = UIView(frame: .zero)
        for aSubView in self.delegate.postScrollView.subviews{
            aSubView.removeFromSuperview()
        }
        self.delegate.postTitleLabelInHeader.text = innerPost.title ?? "بدون عنوان"
        let aFont = UIFont(name: "Shabnam-FD", size: 13)
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.postScrollView.layer.insertSublayer(gradient, at: 0)
        self.delegate.postScrollView.semanticContentAttribute = .forceRightToLeft
        postView = UIView(frame: CGRect(x: self.marginX, y: self.cursurY, width: self.delegate.postScrollView.frame.width-2*self.marginX, height: self.delegate.postScrollView.frame.width-2*15))
        postView.backgroundColor = UIColor.white
        postView.layer.shadowColor = UIColor(hex: 0xD6D7D9).cgColor
        postView.layer.shadowOffset = CGSize(width: 3, height: 3)
        postView.layer.shadowRadius = 3
        postView.layer.shadowOpacity = 0.2
        postImage = UIImageView(frame: CGRect(x: self.marginX, y: self.marginX, width: postView.frame.width-2*self.marginX, height: postView.frame.height-2*self.marginX))
        postView.addSubview(postImage)
        if innerPost.image != "" && innerPost.image != nil {
            if innerPost.image != nil {
                let imageStrUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + innerPost.image!
                //print("*PostUI : Reading : ",imageStrUrl)
                let imageCastedURL = URL(string: imageStrUrl)
                if imageCastedURL != nil {
                    postImage.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageCastedURL!, ImageName: innerPost.image!)
                }else{
                    print("PostUI : Post Image can not be casted.")
                }
            }
        }else{
            //print("*PostUI : innerPost is nil! \(innerPost.image)")
            postImage.image = UIImage(named: "logo_shape")
            postImage.contentMode = .scaleToFill
        }
        self.delegate.postScrollView.addSubview(postView)
        self.cursurY = self.cursurY + postView.frame.height + self.marginY
        
        let buttonDim : CGFloat = 30
        let titleLabelHeight : CGFloat = buttonDim//40
        let titleLabel = UILabel(frame: CGRect(x: self.marginX, y: self.cursurY, width: self.delegate.postScrollView.frame.width-2*self.marginX, height: titleLabelHeight))
        titleLabel.text = innerPost.title
        titleLabel.font = aFont
        titleLabel.textColor = UIColor(hex: 0x515152)
        titleLabel.numberOfLines = 1
        titleLabel.semanticContentAttribute = .forceRightToLeft
        titleLabel.contentMode = .right
        
        self.delegate.postScrollView.addSubview(titleLabel)
        self.cursurY = self.cursurY + titleLabelHeight + self.marginY
        
        let contentString = innerPost.content
        let contentLabelHeight = contentString?.height(withConstrainedWidth: self.delegate.postScrollView.frame.width-2*self.marginX, font: aFont!) ??  (4 * buttonDim)
        let contentLabel = UILabel(frame: CGRect(x: self.marginX, y: self.cursurY, width: self.delegate.postScrollView.frame.width-2*self.marginX, height: contentLabelHeight))
        contentLabel.font = aFont
        contentLabel.textColor = UIColor(hex: 0x515152)
        contentLabel.text = contentString
        contentLabel.contentMode = .right
        contentLabel.numberOfLines = 3
        contentLabel.semanticContentAttribute = .forceRightToLeft
        self.delegate.postScrollView.addSubview(contentLabel)
        self.cursurY = self.cursurY + contentLabelHeight + self.marginY
        
        var cursorX = self.marginX
        //print("innerPost : ",innerPost)
        print("innerPostLIKE : ",innerPost.isLiked)
        if innerPost.isLiked == false {
            likeButton.setImage(UIImage(named: "icon_like"), for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "icon_like_dark"), for: .normal)
        }
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        likeButton.frame = CGRect(x: cursorX, y: self.cursurY, width: buttonDim, height: buttonDim)
        self.delegate.postScrollView.addSubview(likeButton)
        cursorX = cursorX + buttonDim + self.marginX/2
        print("innerPost.countLike : ",innerPost.countLike,"  ",countPostLikes)
        var likeNoString = "\(innerPost.countLike ?? 0)"
        if countPostLikes != -1 {
            likeNoString = "\(self.countPostLikes)"
        }
        print("likeNoString : ",likeNoString)
        let likeNoWidth = likeNoString.width(withConstrainedHeight: buttonDim, font: aFont!)
        likeNoLabel = UILabel(frame: CGRect(x: cursorX, y: self.cursurY, width: likeNoWidth, height: buttonDim))
        likeNoLabel.font = aFont
        likeNoLabel.textColor = UIColor(hex: 0xD6D7D9)
        likeNoLabel.text = likeNoString
        likeNoLabel.contentMode = .center
        self.delegate.postScrollView.addSubview(likeNoLabel)
        cursorX = cursorX + likeNoWidth + (self.marginX * 2)
        
        let commentButton = UIButton(type: .custom)
        commentButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        commentButton.frame = CGRect(x: cursorX, y: self.cursurY, width: buttonDim, height: buttonDim)
        self.delegate.postScrollView.addSubview(commentButton)
        cursorX = cursorX + buttonDim + self.marginX/2
        
        let commentNoString = "\(innerPost.comments?.count ?? 0)"
        //print("commentNoString : ",commentNoString)
        let commentNoWidth = commentNoString.width(withConstrainedHeight: buttonDim, font: aFont!)
        let commentNoLabel = UILabel(frame: CGRect(x: cursorX, y: self.cursurY, width: commentNoWidth, height: buttonDim))
        commentNoLabel.font = aFont
        commentNoLabel.textColor = UIColor(hex: 0xD6D7D9)
        commentNoLabel.text = commentNoString
        commentNoLabel.contentMode = .center
        self.delegate.postScrollView.addSubview(commentNoLabel)
        
        /*
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: "postMenu"), for: .normal)
        menuButton.frame = CGRect(x: self.delegate.postScrollView.frame.width-self.marginX-buttonDim, y: self.cursurY, width: buttonDim*0.75, height: buttonDim*0.75)
        self.delegate.postScrollView.addSubview(menuButton)
         */
        
        
        
        cursorX = cursorX + buttonDim + self.marginX/2

        self.cursurY = self.cursurY + buttonDim + self.marginY*2
        cursorX = self.marginX
        
        let sendCommentButton = UIButton(type: .custom)
        sendCommentButton.setImage(UIImage(named: "icon_send_comment"), for: .normal)
        sendCommentButton.backgroundColor = UIColor(hex: 0x515152)
        sendCommentButton.frame = CGRect(x: cursorX, y: self.cursurY, width: buttonDim*1.6, height: buttonDim*1.6)
        sendCommentButton.imageEdgeInsets = UIEdgeInsetsMake(sendCommentButton.frame.width*2/7, sendCommentButton.frame.width*2/7, sendCommentButton.frame.width*2/7, sendCommentButton.frame.width*2/7)
        sendCommentButton.layer.cornerRadius = 5
        sendCommentButton.adjustsImageWhenHighlighted = true
        sendCommentButton.addTarget(self, action: #selector(self.sendComment(_:)), for: .touchUpInside)
        self.delegate.postScrollView.addSubview(sendCommentButton)
        cursorX = cursorX + sendCommentButton.frame.width + self.marginX/2
        
        let rowRect : CGRect = CGRect(x: cursorX, y: self.cursurY, width: self.delegate.postScrollView.frame.width-cursorX-self.marginX, height: sendCommentButton.frame.height)
        (self.commentView,self.commentText) = rowRect.buildARowView(Image: "icon_comment", Selectable: false, PlaceHolderText: "ثبت نظر")
        self.delegate.postScrollView.addSubview(self.commentView)
        self.cursurY = self.cursurY + self.marginY + rowRect.height
    }
    
    @objc func toggleLike(_ sender : Any){
        Spinner.start()
        (sender as! UIButton).isEnabled = false
        let aParameter = ["shop_id":"\(NetworkManager.shared.postDetailObs.value.shopId!)","post_id":"\(NetworkManager.shared.postDetailObs.value.id!)"]
        print("Toggling Like/Unlike .... : ",aParameter)
        NetworkManager.shared.run(API: "like-dislike", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: false)
        let toggleLikeDisp = NetworkManager.shared.toggleLiked
            .observeOn(MainScheduler.instance)
            .filter({$0 != ToggleStatus.UNKNOWN})
            .subscribe(onNext: { [unowned self] (toggleStatus) in
                print("*Toggling... : ",self.likeNoLabel.text ?? "NIL")
                (sender as! UIButton).isEnabled = true
                DispatchQueue.main.async {
                    print("self.likeNoLabel.text : ",self.likeNoLabel.text ?? "NIL")
                    print("Current countPostLines : ",self.countPostLikes)
                    print("ToggleStatus : ",toggleStatus)
                    
                    if toggleStatus == ToggleStatus.NO && self.isPostLiked {
                        self.countPostLikes = self.countPostLikes - 1
                    }else if toggleStatus == ToggleStatus.YES && !self.isPostLiked {
                        self.countPostLikes = self.countPostLikes + 1
                    }else{
                        print("NOT UPDATING POST because : ",toggleStatus,"  ",self.isPostLiked)
                        Spinner.stop()
                        return
                        //self.delegate.alert(Message: "دسترسی به شبکه موقتاْ قطع شد")
                    }
                    self.likeNoLabel.text = "\(self.countPostLikes)"
                    print("After Apply self.likeNoLabel.text : ",self.likeNoLabel.text ?? "NIL")
                    print("After Apply countPostLines : ",self.countPostLikes)
                    
                    if self.isPostLiked {
                        self.likeButton.setImage(UIImage(named: "icon_like_dark"), for: .normal)
                    }else{
                        self.likeButton.setImage(UIImage(named: "icon_like"), for: .normal)
                    }
                    self.likeNoLabel.setNeedsDisplay()
                    print("  *Toggled... : ",self.likeNoLabel.text ?? "NIL")
                }
                
                if NetworkManager.shared.postDetailObs.value.isLiked.map({if $0 {return ToggleStatus.YES}else{return ToggleStatus.NO}}) != toggleStatus {
                    //Like is updating
                    print("Updating post data...")
                    var postDet = NetworkManager.shared.postDetailObs.value
                    postDet.isLiked = !(postDet.isLiked ?? false)
                    NetworkManager.shared.postDetailObs.accept(postDet)
                }
                NetworkManager.shared.toggleLiked = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
            })
        toggleLikeDisp.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(toggleLikeDisp)
        
        let statusDisp = NetworkManager.shared.status
            .filter({$0 == CallStatus.error || $0 == CallStatus.InternalServerError})
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { innerStatus in
                Spinner.stop()
                (sender as! UIButton).isEnabled = true
            })
        statusDisp.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(statusDisp)
    }
    
    func userIsCommentOwner(Comment aComment : Comment)->Bool{
        //print("Checking Comment owner commentuser: ",aComment.username ?? "NIL" ," LoginUser : ",LoginKey.shared.username)
        if aComment.username == LoginKey.shared.username {
            return true
        }else{
            return false
        }
    }
    
    func getComment(ByID commentID : Int)-> Comment?{
        for aComment in NetworkManager.shared.postDetailObs.value.comments ?? [Comment]() {
            if aComment.comment_id == commentID {
                return aComment
            }
        }
        return nil
    }
    
    @objc func menuOnCommentTapped(_ sender : Any){
        let menuButton = (sender as! UIButton)
        let abuse = "گزارش تخلف"
        let del = "حذف نظر"
        let edit = "ویرایش نظر"
        //let close = "بستن منو"
        let menuList = [abuse]
        let selectedComment = getComment(ByID: menuButton.tag)
        guard selectedComment != nil else {
            self.delegate.alert(Message: "اطلاعات این نظر کامل نیست")
            return
        }
        
        if userIsCommentOwner(Comment: selectedComment!) {
            // This Facility is not yet implemented on Back-End
            //print("SELF COMMENT DETECTED")
            //menuList = [abuse,del,edit]
        }
        
        let controller = menuLister(menuList) {
            (selectedOption) in
            switch selectedOption {
            case abuse : self.reportCommentAbuse(Comment : selectedComment!);break
            case del : self.deleteComment(Comment : selectedComment!);break
            case edit : self.editComment(Comment : selectedComment!);break
            default :
                print("Should not get here, but if it gets its fine! really!")
            }
        }
        controller.preferredContentSize = CGSize(width: 150, height: 100)
        self.delegate.showPopup(controller, sourceView: menuButton)
    }
    
    func reportCommentAbuse(Comment aComment : Comment){
        guard aComment.comment_id != nil else {
            self.delegate.alert(Message: "نظر قابل ریپورت کردن نیست")
            return
        }
        
        let aParameter = ["comment_id":"\(aComment.comment_id!)"]
        NetworkManager.shared.run(API: "report-comment", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
        NetworkManager.shared.serverMessageObs = BehaviorRelay<String>(value: "")
        let messageDisp = NetworkManager.shared.serverMessageObs
            .subscribe(onNext: {amessage in
                self.delegate.alert(Message: amessage)
                //NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        messageDisp.disposed(by: myDisposeBag)
        self.delegate.disposeList.append(messageDisp)
    }
    
    func deleteComment(Comment aComment : Comment){
        
    }
    func editComment(Comment aComment : Comment){
        
    }

    func buildCommentView(With comments : [Comment]){
        if peopleCommentsView.superview != nil {
            peopleCommentsView = UIView(frame: .zero)
            peopleCommentsView.removeFromSuperview()
        }
        if comments.count == 0 {return}
        //print("Comments to Load : ",comments)
        peopleCommentsView = UIView(frame: CGRect(x: self.marginX, y: self.cursurY, width: self.delegate.postScrollView.frame.width - 2*self.marginX, height: 200))
        peopleCommentsView.backgroundColor = UIColor(hex: 0xF7F7F7)
        let profilePicturedim = peopleCommentsView.frame.width/10
        let usernameFont = UIFont(name: "Shabnam-Bold-FD", size: 12)
        let commentFont = UIFont(name: "Shabnam-FD", size: 12)
        var commentCursurY : CGFloat = self.marginY
        for aComment in comments {
            let menuButtonWidth = profilePicturedim / 2
            let commentWidth : CGFloat = peopleCommentsView.frame.width - profilePicturedim - 3*self.marginX - menuButtonWidth
            
            let menuButton = UIButton(type: .custom)
            menuButton.frame = CGRect(x: self.marginX, y: commentCursurY+(menuButtonWidth/2), width: menuButtonWidth, height: menuButtonWidth)
            menuButton.setImage(UIImage(named: "postMenu"), for: .normal)
            menuButton.addTarget(self, action: #selector(menuOnCommentTapped), for: .touchUpInside)
            menuButton.tag = aComment.comment_id ?? 0
            
            peopleCommentsView.addSubview(menuButton)
            
            let usernameLabel = UILabel(frame: CGRect(x: (self.marginX*3/2)+menuButtonWidth, y: commentCursurY, width: commentWidth, height: profilePicturedim))
            usernameLabel.font = usernameFont
            usernameLabel.textColor = UIColor(hex: 0xD6D7D9)
            usernameLabel.contentMode = .right
            usernameLabel.semanticContentAttribute = .forceRightToLeft
            usernameLabel.text = (aComment.first_name ?? "")+" "+(aComment.last_name ?? "")
            peopleCommentsView.addSubview(usernameLabel)
            let profilePictureImageView = UIImageView(frame: CGRect(x: 3*self.marginX+usernameLabel.frame.width, y: commentCursurY, width: profilePicturedim, height: profilePicturedim))
            profilePictureImageView.backgroundColor = UIColor.white
            profilePictureImageView.layer.cornerRadius = (profilePicturedim / 2) - 2
            profilePictureImageView.image = UIImage(named: "icon_profile_03")
            profilePictureImageView.contentMode = .scaleAspectFill
            profilePictureImageView.clipsToBounds = true
            if aComment.image != nil {
                let imageStr = NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+aComment.image!
                if let imageUrl = URL(string: imageStr) {
                    profilePictureImageView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "icon_profile_03"), filter: nil)
                }
            }
            
            peopleCommentsView.addSubview(profilePictureImageView)
            commentCursurY = commentCursurY + self.marginY/3 + profilePicturedim
            var commentHeight = profilePicturedim
            if let commentText = aComment.body {
                commentHeight = commentText.height(withConstrainedWidth: commentWidth, font: commentFont!)
            }
            
            let commentBody = UILabel(frame: CGRect(x: self.marginX+menuButtonWidth, y: commentCursurY, width: commentWidth, height: commentHeight))
            commentBody.font = commentFont
            commentBody.numberOfLines = 10
            commentBody.textColor = UIColor(hex: 0x515152)
            commentBody.contentMode = .right
            commentBody.semanticContentAttribute = .forceRightToLeft
            commentBody.text = aComment.body ?? "نظری ندارم"
            peopleCommentsView.addSubview(commentBody)
            commentCursurY = commentCursurY + self.marginY + commentHeight
        }
        peopleCommentsView.frame = CGRect(x: self.marginX, y: self.cursurY, width: peopleCommentsView.frame.width, height: commentCursurY)
        self.delegate.postScrollView.contentSize = CGSize(width: self.delegate.postScrollView.frame.width, height: (commentCursurY+self.cursurY)*1.2)
        self.delegate.postScrollView.addSubview(peopleCommentsView)
    }
}
