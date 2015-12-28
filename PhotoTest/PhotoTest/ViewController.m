//
//  ViewController.m
//  PhotoTest
//
//  Created by Sujil C on 12/17/15.
//  Copyright © 2015 Sujil C. All rights reserved.
//

#import "ViewController.h"
#import "MKNetworkKit.h"


static NSString * kBoundary = @"0xKhTmLbOuNdArY";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController
{
    NSMutableArray* attachedData;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getPhoto:(id)sender {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://52.10.12.174/DataService/photo/scouting"];
    NSURLQueryItem *filters = [NSURLQueryItem queryItemWithName:@"filters" value:@"{containerNames:[\"43a72dd1-1b4f-442b-b42a-5063fc025e4b\"], fileNames:[\"insect2.jpg\"], isThumbnailOnly:true}"];
    components.queryItems = @[filters];
    NSURL *url = components.URL;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"fields"    : @"[\"filePath\"]",
                                                   @"Userid"       : @"174",
                                                   @"SessionId"       : @"526badf7-26d2-486c-97d4-32e25a91b191"
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    //NSURL *url = [NSURL URLWithString:dataSchemaURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    dispatch_semaphore_t    sem;
    __block NSData *        result;
    
    result = nil;
    sem = dispatch_semaphore_create(0);
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != NULL) {
            
        }
        if (response != NULL) {
            long contentSize = response.expectedContentLength;
        }
        if (error == nil) {
            result = data;
        }
        dispatch_semaphore_signal(sem);
        
    }] resume];
    //[postDataTask resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization
                          JSONObjectWithData: result
                          options: NSJSONReadingMutableContainers
                          error: &e];
    NSString  *stringData = [[JSON  valueForKey:@"file"] objectAtIndex:0];
    
    NSData * data = [[NSData alloc] initWithBase64EncodedString:stringData options:0];
    
    UIImage  *img = [UIImage imageWithData:data];
    
    self.imageView.image =  img;
    
    NSString *response =  [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"Response:%@", response);
    
    

    
//    NSURL *url = [NSURL URLWithString:@"http://mobilevideos.mazdausa.com/ipad/videos/CX3/2016/feature_demo/CX5_Hill_Launch_Assist.m4v"];
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    //NSURL *url = [NSURL URLWithString:dataSchemaURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"GET";
//    
//    dispatch_semaphore_t    sem;
//    __block NSData *        result;
//    
//    result = nil;
//    sem = dispatch_semaphore_create(0);
//    
//    __block long contentSize ;
//    
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        if (error != NULL) {
//            
//        }
//        if (response != NULL) {
//            contentSize = response.expectedContentLength;
//        }
//        if (error == nil) {
//            result = data;
//        }
//        dispatch_semaphore_signal(sem);
//        
//    }] resume];
//    //[postDataTask resume];
//    
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    
}
- (IBAction)postImage:(id)sender {
    
    
    
    
    
   
    
    NSMutableDictionary *postParams = nil;
    postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:101],@"organizationId",
                                                                   [NSNumber numberWithInt:201],@"farmId",
                                                                    [NSNumber numberWithInt:301],@"landId",
                                                                    @"F",@"landType",
                                                                    [NSNumber numberWithInt:200001],@"itemId",
                                                                    @"43a72dd1-1b4f-442b-b42a-5063fc025e4b",@"containerName",
                                                                  @"Pest Photos",@"caption",
                                                                  @"{}",@"context",
                                                                  @"2015-11-13T11:36:11.488668",@"createdOn",
                                                                  @"2015-11-13T11:36:11.488668",@"modifiedOn",nil];
    
    NSMutableData *formData = [NSMutableData data];
    
    [postParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     kBoundary, key, obj];
        
        [formData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    attachedData = [NSMutableArray array];
    
    NSData *the_data =  UIImageJPEGRepresentation([UIImage imageNamed:@"insect2.jpg"], 0.5);
    [self attachData:the_data forKey:@"Pest Photos" mimeType:@"image/jpeg" suggestedFileName:@"insect2.jpg"];
    
    [attachedData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisDataObject = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     kBoundary,
                                     thisDataObject[@"name"],
                                     thisDataObject[@"filename"],
                                     thisDataObject[@"mimetype"]];
        
        [formData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendData:thisDataObject[@"data"]];
        [formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [formData appendData: [[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting up the URL to post to
    NSString *urlString = @"http://52.10.12.174/DataService/photo/scouting";
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"174" forHTTPHeaderField:@"Userid"];
    [request addValue:@"526badf7-26d2-486c-97d4-32e25a91b191" forHTTPHeaderField:@"SessionId"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPBody:formData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(returnString);

    
    
}

-(void) attachData:(NSData*) data forKey:(NSString*) key mimeType:(NSString*) mimeType suggestedFileName:(NSString*) fileName {
    
    if(!fileName) fileName = key;
    
    NSDictionary *dict = @{@"data": data,
                           @"name": key,
                           @"mimetype": mimeType,
                           @"filename": fileName};
    
    [attachedData addObject:dict];
}




@end
