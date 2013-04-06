//
//  POAPinyin.h
//  POA
//
//  Created by haung he on 11-7-18.
//  Copyright 2011年 huanghe. All rights reserved.
//

#ifndef POAPinyin_h
#define POAPinyin_h

#import <Foundation/Foundation.h>

/***

 1.大小 pinyin最小了,POAPinyin的声明就快500行了.
 2.速度 其实三者差不多,但是不要用POAPinyin原生的那个convert,那个每次都遍历查找很慢.
 3.对比 pinyin只能取得汉字对应拼音的首字母,PYMethod原本是应用于股票查询的,它的拼音个数少于POAPinyin.
 　　　　对于这个汉字"嗯",我拼音输入法是"en"打出来的,PYMethod得到的是EN,但是POAPinyin得到的是NG,百度百科也读NG.....
 4.原理
 　　pinyin是把unicode中汉字部分的首字母全部提取到数组,取得时候 拼音数组[汉字的unicode值-unicode中起始汉字值]就直接得到了.
 　　PYMethod是把unicode转成GBK,然后根据GBK高低位两个值确定对应拼音的位置得到拼音
 　　POAPinyin是把所有拼音与之对应的汉字组成一个表,到时候往这个表里查询(原生convert方法)
 　　　　　　改进的quickConvert方法是先得到一个汉字unicode值的上下限,然后转换上面的表成 unicode--拼音 这样的表,查询的时候就是哈希查找,更快,要是这个unicode不连续就会有很大的问题了(这个表里面果然缺了字:"乬乮乲仍兙兛兝兞兡兣匁厑厼叾唜唞唟啹嗧囍堎塄娘嬢岃巪愣扔朰楞特猤瓧瓩瓰瓱瓸瓼甅畓睖碐礽稜脦膶芿薐蟘貣辸酿醸釀鋱铽").这个函数还会跳过一些非ascii符号.另一个方法stringConvert修复了非ascii码这个问题.使用的时候最好把上面提到的字加进表里.
 
***/

@interface POAPinyin : NSObject {
    
}

+ (NSString *) convert:(NSString *) hzString;//输入中文，返回拼音。

//  added by setimouse@gmail.com 改进方法
+ (NSString *)quickConvert:(NSString *)hzString;

// 后加
+ (NSMutableArray *) ConvertToArray:(NSString *) hzString;

+ (void)clearCache;

+(NSString*) stringConvert:(NSString*)hzString;

@end

#endif
