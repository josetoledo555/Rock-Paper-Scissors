//
//  ViewController.h
//  Rock-Paper-Scissors
//
//  Created by jose pena toledo on 3/1/14.
//  Copyright (c) 2014 jose pena toledo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,NSURLConnectionDelegate>
{
    NSMutableData* receivedData;
    NSMutableString *currentNodeContent;
    NSMutableArray  *elementArray;
}
@property (strong, nonatomic) IBOutlet UIPickerView *pickerRPS;
- (IBAction)btnPlay:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblResult;
@property (strong,nonatomic)NSArray* arrayRPS;
@property (strong,nonatomic)NSString* parameter;
@end
