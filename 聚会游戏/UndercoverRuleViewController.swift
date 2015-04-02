//  谁是卧底 - 游戏规则
//  UndercoverRuleViewController.swift
//  聚会游戏
//
//  Created by lane on 15/3/25.
//  Copyright (c) 2015年 lane. All rights reserved.
//

import UIKit

class UndercoverRuleViewController: UIViewController {

    @IBOutlet weak var ruleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //拉去远程数据
        RequestService().request("http://www.lanecn.com/test/getGameRuleForUndercover", methodString: "GET") { (returnData) -> Void in
            self.success(returnData as NSDictionary)
        }
    }
    //拉去服务器数据成功
    func success(json:NSDictionary!){
        var errCode:Int = json["errCode"] as Int
        var errMsg:String = json["errMsg"] as String
        var ret:String? = json["data"] as? String
        
        //判断后端是否返回data字段
        if ret == nil {
            println("后端返回数据不完整")
            return
        }
        //校验返回错误码
        if errCode != 0 {
            println("报错了！\(errMsg)[\(errCode)]")
            return
        }else{
            ruleTextView.textAlignment = NSTextAlignment.Left
            ruleTextView.text = ret
        }
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
