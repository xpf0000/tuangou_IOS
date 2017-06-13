//
//  Public.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import Foundation

let TmpDirURL = Bundle.main.resourceURL!.appendingPathComponent("html")
let APPBlueColor = "11c1f3".color()
let datepicker = DatePicker.init(.dateAndTime)
let ImagePrefix = "http://oonby7g6e.bkt.clouddn.com/"

let SW = UIScreen.main.bounds.size.width
let SH = UIScreen.main.bounds.size.height

let BaseHtml = "<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" +
    "<head>\r\n" +
    "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n" +
    "<meta http-equiv=\"Cache-Control\" content=\"no-cache\" />\r\n" +
    "<meta content=\"telephone=no\" name=\"format-detection\" />\r\n" +
    "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0\">\r\n" +
    "<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />\r\n" +
    "<title>活动简介</title>\r\n" +
    "<style>\r\n" +
    "body {background-color: #FFFFFF}\r\n" +
    "table {border-right:1px dashed #D2D2D2;border-bottom:1px dashed #D2D2D2}\r\n" +
    "table td{border-left:1px dashed #D2D2D2;border-top:1px dashed #D2D2D2}\r\n" +
    "img {width:100%;height: auto}\r\n" +
    "</style>\r\n</head>\r\n<body>\r\n"+"[XHTMLX]"+"\r\n</body>\r\n</html>"
