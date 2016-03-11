//
//  KeyChain.cpp
//  KeyChain Plugin for Unity
//
//  Created by huaye on 2016/03/11.
//  Copyright 2016 huaye. All rights reserved.
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import <UIKit/UIKit.h>
#import <Security/Security.h>

#define SERVICE_NAME    @"my_service_name"
#define IDENTIFIER      @"my_app_identifier"
#define ACOUNT_ID       @"my_account"

extern "C" {
    int _Get(const char *account);
    int _Update(const char *account);
    int _Delete(const char *account);
    char* _Get_Device_id();
}

int _Delete(const char *account)
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [query setObject:(id)[NSString stringWithCString:account encoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
    
    OSStatus err = SecItemDelete((CFDictionaryRef)query);
    
    return err;
}

int _Update(const char *account, const char *password)
{
    NSMutableDictionary* attributes = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    NSData* passwordData = [[NSString stringWithCString:password encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [query setObject:(id)[NSString stringWithCString:account encoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
    [query setObject:SERVICE_NAME forKey:(id)kSecAttrService];
    [query setObject:[IDENTIFIER dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
    
    OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, NULL);
    
    if (err == noErr) {
        // update item
        attributes = [NSMutableDictionary dictionary];
        [attributes setObject:passwordData forKey:(id)kSecValueData];
        [attributes setObject:[NSDate date] forKey:(id)kSecAttrModificationDate];
        
        err = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributes);
        return (int)err;
        
    } else if (err == errSecItemNotFound) {
        // add new item
        
        attributes = [NSMutableDictionary dictionary];
        [attributes setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [attributes setObject:(id)[NSString stringWithCString:account encoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
        [attributes setObject:passwordData forKey:(id)kSecValueData];
        [attributes setObject:SERVICE_NAME forKey:(id)kSecAttrService];
        [attributes setObject:[IDENTIFIER dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
        [attributes setObject:[NSDate date] forKey:(id)kSecAttrCreationDate];
        [attributes setObject:[NSDate date] forKey:(id)kSecAttrModificationDate];
        [attributes setObject:@"Device ID(Huaye)" forKey:(id)kSecAttrDescription];
        err = SecItemAdd((CFDictionaryRef)attributes, NULL);
        return (int)err;
        
    } else {
        return (int)err;
    }
}

int _Get(const char *account, char* password)
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [query setObject:(id)[NSString stringWithCString:account encoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
    [query setObject:SERVICE_NAME forKey:(id)kSecAttrService];
    [query setObject:[IDENTIFIER dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    CFDataRef cfresult = NULL;
    OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef*)&cfresult);
    
    if (err == noErr) {
        NSData* passwordData = (__bridge_transfer NSData *)cfresult;
        const char* str = [[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding] UTF8String];
        password = strdup(str);
    } else if(err == errSecItemNotFound) {
    }
    return err;
}

char* _Get_Device_id()
{
    NSMutableDictionary* attributes = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [query setObject:ACOUNT_ID forKey:(id)kSecAttrAccount];
    [query setObject:SERVICE_NAME forKey:(id)kSecAttrService];
    [query setObject:[IDENTIFIER dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    CFDataRef cfresult = NULL;
    OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef*)&cfresult);
    
    if (err == noErr) {
        NSData* passwordData = (__bridge_transfer NSData *)cfresult;
        const char* str = [[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding] UTF8String];
        char *password = strdup(str);
        
        NSLog(@"load uuid:%@", [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]);
        return password;
    } else if(err == errSecItemNotFound) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        NSString* newpass = (__bridge_transfer NSString *)uuidStringRef;
        
        attributes = [NSMutableDictionary dictionary];
        [attributes setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [attributes setObject:ACOUNT_ID forKey:(id)kSecAttrAccount];
        [attributes setObject:[newpass dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
        [attributes setObject:SERVICE_NAME forKey:(id)kSecAttrService];
        [attributes setObject:[IDENTIFIER dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
        [attributes setObject:[NSDate date] forKey:(id)kSecAttrCreationDate];
        [attributes setObject:[NSDate date] forKey:(id)kSecAttrModificationDate];
        [attributes setObject:@"Device ID(Huaye)" forKey:(id)kSecAttrDescription];
        err = SecItemAdd((CFDictionaryRef)attributes, NULL);
        
        if (err == noErr) {
            NSLog(@"create uuid:%@", newpass);
            const char* str = [newpass UTF8String];
            char *password = strdup(str);
            return password;
        }
        return NULL;
    }
    return NULL;
}
