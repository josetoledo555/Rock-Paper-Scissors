//
//  ViewController.m
//  Rock-Paper-Scissors
//
//  Created by jose pena toledo on 3/1/14.
//  Copyright (c) 2014 jose pena toledo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize arrayRPS;
@synthesize parameter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //default values
    self.arrayRPS = [NSArray arrayWithObjects:@"Rock",@"Paper",@"Scissors", nil];
    self.parameter=@"rock";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)btnPlay:(id)sender {
    NSURLRequest *theRequest=[NSURLRequest
                              requestWithURL:[NSURL URLWithString:
                                              [NSString stringWithFormat:@"http://roshambo.herokuapp.com/throws/%@",self.parameter]]
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:60.0];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (con) {
        receivedData=[NSMutableData data];
    } else {
        //something bad happened, implement error handling
    }
}

#pragma mark PickerView
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 3;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    return [self.arrayRPS objectAtIndex:row];
    
}

// row selected
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    NSLog(@"Selected Row %d", row);
    switch(row)
    {
            
        case 0:
            NSLog(@"Row 0");
            self.parameter=@"rock";
            
            break;
        case 1:
            NSLog(@"Row 1");
            self.parameter=@"paper";

            break;
        case 2:
            NSLog(@"Row 2");
            self.parameter=@"scissors";

            break;

    }
    
}

#pragma mark NSUrlConnectionDelegate
-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response
{
    if (receivedData == NULL) {
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData setLength:0];
    NSLog(@"didReceiveResponse: responseData length:(%d)", receivedData.length);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSString *responseText = [[NSString alloc] initWithData:receivedData encoding: NSASCIIStringEncoding];
    NSLog(@"Response: %@", responseText);
    [self parseHTML:responseText];
    
}


#pragma mark parseHTML
-(void)parseHTML:(NSString*)strHTML{
    //expected response: <h2>You won! The computer threw scissors.</h2>
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[strHTML dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//h2"];
    TFHppleElement *element = [elements objectAtIndex:0];
    NSString *rawResult = [element raw];
    //remove tags
    rawResult=[rawResult stringByReplacingOccurrencesOfString:@"<h2>" withString:@""];
    rawResult=[rawResult stringByReplacingOccurrencesOfString:@"</h2>" withString:@""];

    //update label
    self.lblResult.text=rawResult;
}

@end
