//
//  LoginViewController.swift
//  safeID
//
//  Created by Jorge Luis Perales on 28/10/15.
//  Copyright © 2015 Jorge Luis Perales. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet var loginTouchID: UIButton!
    
    var context = LAContext()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // loginTouchID.hidden = true
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
            loginTouchID.hidden = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func loginTouchIDAction(sender: UIButton) {
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Logging in with Touch ID", reply: { (success: Bool, error: NSError? ) -> Void in
            
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        if success {
                            self.performSegueWithIdentifier("dismissLogin", sender: self)
                        }
                        
                        if error != nil {
                            var message: String
                            var showAlert: Bool
                            
                            switch(error!.code) {
                            case LAError.AuthenticationFailed.rawValue:
                                message = "There was a problem verifying your identity."
                                showAlert = true
                                break;
                            case LAError.UserCancel.rawValue:
                                message = "You pressed cancel."
                                showAlert = true
                                break;
                            case LAError.UserFallback.rawValue:
                                message = "You pressed password."
                                showAlert = true
                                break;
                            default:
                                showAlert = true
                                message = "Touch ID may not be configured."
                                break;
                            }
                            
                            let alertView = UIAlertController(title: "Error", message: message as String, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
                            alertView.addAction(okAction)
                            if showAlert {
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                        }
                    
                    })
            
            })
            
        } else {
            let alertView = UIAlertController(title: "Error", message: "Touch ID not available" as String, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
