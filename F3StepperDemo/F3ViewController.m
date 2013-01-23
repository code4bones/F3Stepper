//
//  F3ViewController.m
//  F3StepperDemo
//
//  Created by Brad Benson on 1/13/13.
//  Copyright (c) 2013 Brad Benson. All rights reserved.
//


//===[ Required Headers ]================================================

// Our stuff
#import "F3Stepper.h"
#import "F3BarGauge.h"
#import "F3ViewController.h"


//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
//-------------|  F3ViewController class implementation  |---------------
//-----------------------------------------------------------------------
//-----------------------------------------------------------------------

//===[ Class extension for private-ish items ]===========================
@interface F3ViewController ()
{
    float       _flSavedVolume;
}

// User interface view properties
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet F3Stepper *fontSizeStepper;
@property (weak, nonatomic) IBOutlet F3BarGauge *volumeLevel;
@property (weak, nonatomic) IBOutlet F3Stepper *volumeStepper;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;

// User interface actions
- (IBAction)didChangeFontSize:(id)sender;
- (IBAction)didChangeVolume:(id)sender;
- (IBAction)didChangeMute:(id)sender;
@end



@implementation F3ViewController
//===[ Class Methpds ]===================================================


#pragma mark - View Lifecyle
//-----------------------------------------------------------------------
//  Method: viewDidLoad
//      Initializes the view after it is loaded from the nib
//
- (void)viewDidLoad
{
    // Call parent first
    [super viewDidLoad];
    
    // Set background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    // Initialize the font size stepper
    self.fontSizeStepper.minValue = 5.0f;
    self.fontSizeStepper.maxValue = 36.0f;
    self.fontSizeStepper.stepValue = 1.0f;
    self.fontSizeStepper.value = _fontSizeLabel.font.pointSize;
    self.fontSizeStepper.formatString = @"%0.1f pts";
    
    // Initialize the bar gauge
    self.volumeLevel.minLimit = 0.0f;
    self.volumeLevel.maxLimit = 9.9f;
    self.volumeLevel.numBars = 20;
    self.volumeLevel.value = 5.0f;
    
    // Initialize volume stepper
    // ... This doesn't use the stepper protocol and instead relies
    // ... on the value changed event.   This allows you to wire the
    // ... stepper up in IB just as you would other views.
    self.volumeStepper.minValue = 0.0f;
    self.volumeStepper.maxValue = 10.0f;
    self.volumeStepper.stepValue = 0.1f;
    self.volumeStepper.value = self.volumeLevel.value;
    self.volumeStepper.formatString = @"%0.1f db";
}


//-----------------------------------------------------------------------
//  Method: viewDidUnload
//      Called when the view is unloaded.   Cleans up misc. items
// 
- (void)viewDidUnload {
    [self setFontSizeStepper:nil];
    [self setFontSizeLabel:nil];
    [self setVolumeLevel:nil];
    [self setVolumeStepper:nil];
    [self setMuteSwitch:nil];
    [super viewDidUnload];
}


#pragma mark - UI Interface Actions
//-----------------------------------------------------------------------
//  Method: didChangeFontSize:
//      Handles value changes from font size stepper.
//
//      Note that this method is wired to the value changed
//      event, it does not receive intermediate values i.e.
//      this method is not called while the user is holding
//      down the stepper to rapidly change the value.
//
- (IBAction)didChangeFontSize:(id)sender
{
    // Update label font size
    _fontSizeLabel.font = [_fontSizeLabel.font fontWithSize:_fontSizeStepper.value];
}


//-----------------------------------------------------------------------
//  Method: didChangeMute:
//      Handles mute switch value changes
//
- (IBAction)didChangeMute:(id)sender
{
    // Is the control off?
    if(_muteSwitch.on) {
        // Yes, save value
        _flSavedVolume = _volumeStepper.value;
        _volumeStepper.value = 0.0f;
        _volumeLevel.value = 0.0f;
        _volumeStepper.enabled = NO;
    }
    else {
        // Restore the value
        _volumeLevel.value = _flSavedVolume;
        _volumeStepper.value = _flSavedVolume;
        _volumeStepper.enabled = YES;
    }
    
    [self didChangeVolume:_volumeStepper];
}


//-----------------------------------------------------------------------
//  Method: didChangeVolume:
//      Handles value change events from volume stepper view.
//
//      Note that this method is wired to the editing changed event,
//      and is therefore called as the value is changed while the
//      user is holding the stepper up or down to rapidly change
//      the value.
//
- (IBAction)didChangeVolume:(id)sender
{
    float       flNewLevel = _volumeStepper.value;      // New volume level
    
    // Adjust color as needeed
    if( flNewLevel >= 8.50f ) {
        // Danger range color
        _volumeStepper.backgroundColor = [UIColor redColor];
        _volumeStepper.textColor = [UIColor whiteColor];
    }
    else if(flNewLevel >= 6.50f ) {
        // Warning range color
        _volumeStepper.backgroundColor = [UIColor yellowColor];
        _volumeStepper.textColor = [UIColor blackColor];
    }
    else {
        _volumeStepper.backgroundColor = [UIColor whiteColor];
        _volumeStepper.textColor = [UIColor blackColor];
    }
    
    // Update the bar gauge
    _volumeLevel.value = flNewLevel;
}


#pragma mark - F3StepperDelegate protocol
//-----------------------------------------------------------------------
//  Method: stepperValueChanged:
//      Delegate method called by the F3Stepper control when
//      user changes the value.
//
//      Use of this protocol/method may be preferred when you are not
//      interested in intermediate values.   This method is called only
//      when the user has stopped changing the value on the stepper
//      and provides the ability to 
//
-(void) stepperValueChanged:(F3Stepper *)stepper;
{
    // Which stepper?
    if( stepper == _fontSizeStepper ) {
    }
}
@end
