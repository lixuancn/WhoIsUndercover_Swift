//  谁是卧底 - 人数确认
//  UndercoverViewController.swift
//  聚会游戏
//
//  Created by lane on 15/3/25.
//  Copyright (c) 2015年 lane. All rights reserved.
//

import UIKit

class UndercoverViewController: UIViewController, UITextFieldDelegate {
    
    //参与者人数
    @IBOutlet weak var gamersNumTextField: UITextField!
    
    @IBOutlet weak var undercoverNumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamersNumTextField.delegate = self
        //键盘改为数字键盘
        gamersNumTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }
    
    //游戏人数改变时，修改卧底人数的label
    @IBAction func gamersNumTextFieldEditingDidEnd(sender: UITextField) {
        undercoverNumLabel.text = "\(self.getUndercoverGamersNum(gamersNumTextField.text.toInt()))"
    }
    
    //根据人数来确定卧底人数
    func getUndercoverGamersNum(gamersTotal:Int?)->Int{
        var undercoverGamersNum:Int = 0
        if let gamersNum = gamersTotal {
            if gamersNum > 0 && gamersNum < 7 {
                undercoverGamersNum = 1
            }else if (gamersNum >= 7 && gamersNum < 10) {
                undercoverGamersNum = 2
            }else if (gamersNum >= 10 && gamersNum < 14) {
                undercoverGamersNum = 3
            }else if (gamersNum >= 14 && gamersNum < 16) {
                undercoverGamersNum = 4
            }else if gamersNum > 16 {
                undercoverGamersNum = gamersNum / 4
            }
        }
        return undercoverGamersNum
    }
    
    //返回到上页
    @IBAction func exitGameAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //点击空白处键盘消失
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        gamersNumTextField.resignFirstResponder()
    }
    
    //点击return时键盘消失
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return gamersNumTextField.resignFirstResponder()
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToUndercoverGameViewController" {
            var undercoverGameViewController = segue.destinationViewController as UndercoverGameViewController
            undercoverGameViewController.gamersNum = gamersNumTextField.text.toInt()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
