//
// Created by neon on 15/7/17.
// Copyright (c) 2015 neon. All rights reserved.
//

#import "TNDES.h"



@implementation TNDES
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSString *base64EncodedString = [[plainText dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        NSData *encryptData = [[NSData alloc]initWithBase64EncodedString:base64EncodedString options:0];
        plainTextBufferSize = [encryptData length];
        vplainText = [encryptData bytes];
    }
    else
    {
        plainTextBufferSize = [plainText length];
        vplainText = (const void *) [plainText UTF8String];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    //    const unsigned char *initializeVactorString = (const unsigned char *)[@"ASAF@DG#" cStringUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       [key UTF8String],
                       kCCKeySize3DES,
                       iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
        NSLog(@"SUCCESS");
    }
    else{
        if (ccStatus == kCCParamError) return @"PARAM ERROR";
        else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
        else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
        else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
        else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
        else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    }
    
    NSString *result;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [ [NSString alloc] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];

                result=[GTMBase64 stringByEncodingData:myData];
    }
    NSLog(@"%@",result);
    return result   ;
    
}




+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[@"test" UTF8String];//des加密 公钥目前没有
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));

    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding ,
                       vkey,
                       kCCKeySize3DES,
                        iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}












// 加密方法
+ (NSString*)encrypt:(NSString*)plainText {
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    
    uint8_t *bufferPtr = NULL;
    
    size_t bufferPtrSize = 0;
    
    size_t movedBytes = 0;
    
    
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    
    
    const void *vkey = (const void *) [@"test 123" UTF8String];//des 加密 出错
    

    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding|kCCOptionECBMode,
//                       [key UTF8String],
//                       kCCKeySize3DES,
//                       IV,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    
    return result;
}


// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText {
    
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    
    size_t plainTextBufferSize = [encryptData length];
    
    const void *vplainText = [encryptData bytes];
    
    
    
    CCCryptorStatus ccStatus;
    
    uint8_t *bufferPtr = NULL;
    
    size_t bufferPtrSize = 0;
    
    size_t movedBytes = 0;
    
    
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    
    
    const void *vkey = (const void *) [@"test 123" UTF8String];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));

    
    
    
    ccStatus = CCCrypt(kCCDecrypt,
                       
                       kCCAlgorithm3DES,
                       
                       kCCOptionPKCS7Padding,
                       
                       vkey,
                       
                       kCCKeySize3DES,
                       
                       iv,
                       
                       vplainText,
                       
                       plainTextBufferSize,
                       
                       (void *)bufferPtr,
                       
                       bufferPtrSize,
                       
                       &movedBytes);
    
    
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                        
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    return result;
}  






@end
