// HTTP Request服务类
//  RequestService.swift
//  聚会游戏
//
//  Created by lane on 15/3/18.
//  Copyright (c) 2015年 lane. All rights reserved.
//

import UIKit
import Alamofire


class RequestService : NSObject{
    
    func request(url:String, methodString:String="GET", successCallBack:(returnData:AnyObject
        ) -> Void) -> Void {
        var params:[String : AnyObject]?
        var method:Alamofire.Method?
        if methodString == "GET" {
            method = Alamofire.Method.GET
        }else if methodString == "POST" {
            method = Alamofire.Method.POST
        }
        if let m = method{
            Alamofire.request(m, url, parameters: params).responseJSON { (request, response, returnData, error) in
                // 出错误时
                if(error != nil) {
                    println("Error: \(error)")
                    println(request)
                    println(response)
                //没出错时
                }else{
                    successCallBack(returnData: returnData!)
                }
            }
        }
    }
}
