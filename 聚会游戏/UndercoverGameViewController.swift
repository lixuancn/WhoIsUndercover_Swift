//  谁是卧底 - 游戏开始
//  UndercoverGameViewController.swift
//  聚会游戏
//
//  Created by lane on 15/3/25.
//  Copyright (c) 2015年 lane. All rights reserved.
//

import UIKit
//import MobileCoreServices.framework

class UndercoverGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate {
    
    //参与人数
    var gamersNum:Int?
    //卧底人数
    var undercoverNum:Int?
    //死亡人数
    var dieGamerNum = 0
    //头像列表
    var headImageList:[UIImage] = []
    //collectionCell ID
    var cellId:String = "collectionViewId"
    //玩家头像imageView的tag
    var imageViewTag:Int = 1
    //玩家编号Label的tag
    var gamerCodeLabelTag:Int = 2
    //当前状态，2是游戏中，1是正在录入头像
    var currentStatus:Int = 1
    //当前正在修改的headImageList的key
    var currentEditingHeadImageListKey:Int?
    //未拍照的玩家列表
    var gamersNoCamera:[Int] = []
    //即将要票死的玩家
    var willDieGamer:Int?
    //当前回合数
    var roundNum = 1
    
    //label 游戏当前剩余人数
    @IBOutlet weak var remainGamerNumLabel: UILabel!
    //当前回合数
    @IBOutlet weak var roundNumLabel: UILabel!
    //collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //根据人数获取卧底人数
        if let gamerNum = gamersNum {
            undercoverNum = UndercoverViewController().getUndercoverGamersNum(gamersNum)
        }else{
            println("人数错误")
            return
        }
        //卧底人数校验
        if undercoverNum == 0 || undercoverNum == nil {
            println("人数错误")
            return
        }
        //collectionView的代理和数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        //初始化头像
        for i in 0..<self.gamersNum! {
            initHeadImage(headImageListIndex: nil)
        }
        UIAlertView(title: "开始自拍啦～", message: "请点击一个初始头像替换成自己美美的照片吧，不满意可以重照哦", delegate: nil, cancelButtonTitle: "我要拍照！").show()
        
    }
    
    //点击开始游戏
    @IBAction func startGameButtonAction(sender: AnyObject) {
        //当前状态为游戏中
        self.currentStatus = 2
        //隐藏开始按钮
        startGameButton.hidden = true
        //当前回合数和剩余人数
        roundNumLabel.hidden = false
        remainGamerNumLabel.hidden = false
        updateLabel((gamersNum! - dieGamerNum), roundsNum: self.roundNum)
    }

    //返回总cell数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gamersNum!
    }
    //初始化collectionView Cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as UICollectionViewCell
        var imageView = cell.viewWithTag(imageViewTag) as UIImageView
        var gamerCodeLabel = cell.viewWithTag(self.gamerCodeLabelTag) as UILabel
        //建立ImageView
        imageView.image = headImageList[indexPath.row]
        gamerCodeLabel.text = "\((indexPath.row+1))号玩家"
        //讲当前用户加入到未拍照的队列中
        self.gamersNoCamera.append(indexPath.row)
        return cell
    }
    
    //按下头像的时候
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.currentEditingHeadImageListKey = indexPath.row
        //如果在头像录入阶段，按头像则重新拍照
        if self.currentStatus == 1 {
            //删除头像数组对应的值
            self.getHeadImageByCamera()
        //如果在游戏中，按头像则票出局
        }else if self.currentStatus == 2 {
            //弹出提示框
            UIAlertView(title: "票死他", message: "确定要将\((indexPath.row+1))号玩家票出局吗？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消").show()
        }
    }
    
    //票死提示框的delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            if let key = self.currentEditingHeadImageListKey {
                //死亡人头像改变
                var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("weibo", ofType: "png")!)!
                headImageList[key] = image
                //死亡人数加一
                self.dieGamerNum++
                //回合数加一
                self.roundNum++
                //刷新collectionView
                self.collectionView.reloadData()
                //刷新Label
                updateLabel((gamersNum! - dieGamerNum), roundsNum: self.roundNum)
                self.currentEditingHeadImageListKey = nil
            }
        }
    }
    
    //调用相机 - 获取照片
    func getHeadImageByCamera(){
        var c = UIImagePickerController()
        c.delegate = self
        //从相册获取
        c.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(c, animated: true, completion: nil)
    }
    
    //选择照片后的回调
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        //如果是已拍照，但要编辑的
        if let key = self.currentEditingHeadImageListKey {
            self.headImageList[key] = image
            self.currentEditingHeadImageListKey = nil
        //如果是未拍照的
        }else if self.gamersNoCamera.startIndex != self.gamersNoCamera.endIndex {
            var index = gamersNoCamera.removeAtIndex(self.gamersNoCamera.startIndex)
            self.headImageList[index] = image
        }
        self.collectionView.reloadData()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //生成头像  如果传参则替换旧数据，不传参则加新值
    func initHeadImage(headImageListIndex index:Int?){
        var path:String?
        var image:UIImage?
        var ofType:String?
        var imageName:String?
        imageName = "headImage"
        ofType = "jpg"
        path = NSBundle.mainBundle().pathForResource(imageName, ofType: ofType)
        image = UIImage(contentsOfFile: path!)
        if let key = index {
            headImageList[key] = image!
        }else{
            headImageList.append(image!)
        }
    }
    
    func updateLabel(remainGamerNum:Int, roundsNum:Int){
        remainGamerNumLabel.text = "剩余\(remainGamerNum)人"
        roundNumLabel.text = "第\(roundsNum)回合"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
