//
//  ViewController.swift
//  Drag&Drop
//
//  Created by Wexford on 09/02/17.
//  Copyright © 2017 Wexford. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    //Variable to save location on touch
    var location = CGPoint(x: 0, y: 0)
    
    //Original position of images
    var origiPosImage1: CGPoint? = nil
    var origiPosImage2: CGPoint? = nil
    var origiPosImage3: CGPoint? = nil
    
    //Array to store the frames where the images fit in
    var marcos: [UIImageView] = []
    
    //Var for the player
    var player = AVAudioPlayer()

    //Boolean variables to validate that the image is already in position
    var Cat_M = false,Dog_M = false,Bird_M = false
    
    //Var to validate the touch is always in an image
    var imageSelected = false
    
    //Var to modify image
    private var tempTransform: CGAffineTransform!
    
    //Outlets iMages
    @IBOutlet weak var iMagen1: UIImageView!
    @IBOutlet weak var iMagen2: UIImageView!
    @IBOutlet weak var iMagen3: UIImageView!
    
    //Outlets Frames
    @IBOutlet weak var Marco_1: UIImageView!
    @IBOutlet weak var Marco_2: UIImageView!
    @IBOutlet weak var Marco_3: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Save images positions
        origiPosImage1 = iMagen1.frame.origin
        origiPosImage2 = iMagen2.frame.origin
        origiPosImage3 = iMagen3.frame.origin
        
        //Add frames to array
        marcos.append(Marco_1)
        marcos.append(Marco_2)
        marcos.append(Marco_3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in(touches){
            
            //Saves the location of the touch
            location = touch.location(in: self.view)
            
            //What image was chosen? -- Then, makes it bigger and shows a shadow
            
            if iMagen1.frame.contains(location){
                iMagen1.center = location
                iMagen1.layer.shadowOpacity = 0.8
                tempTransform = iMagen1.transform
                iMagen1.transform = iMagen1.transform.scaledBy(x: 1.2, y: 1.2)
                imageSelected = true
            }
            
            else if iMagen2.frame.contains(location){
                iMagen2.center = location
                iMagen2.layer.shadowOpacity = 0.8
                tempTransform = iMagen2.transform
                iMagen2.transform = iMagen2.transform.scaledBy(x: 1.2, y: 1.2)
                imageSelected = true
            }
            
            else if iMagen3.frame.contains(location){
                iMagen3.center = location
                iMagen3.layer.shadowOpacity = 0.8
                tempTransform = iMagen3.transform
                iMagen3.transform = iMagen3.transform.scaledBy(x: 1.2, y: 1.2)
                imageSelected = true
            }
            
         
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in(touches){
            location = touch.location(in: self.view)
            
               //Makes the frames shine when an image is over
            
               for marco in marcos{
                    
                    if ( (marco.frame.contains(iMagen1.center))
                         || (marco.frame.contains(iMagen2.center))
                            || (marco.frame.contains(iMagen3.center))){
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            marco.alpha = 0.9
                        })
                    }else{
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            marco.alpha = 0.6
                        })
                    }
                }
            
            //Moves the image to the touch point every time.
            
            if iMagen1.frame.contains(location){
                iMagen1.center = location
                
            }
            
            else if iMagen2.frame.contains(location){
                iMagen2.center = location
                
            }
            
            else if iMagen3.frame.contains(location){
                iMagen3.center = location
                
            }
            
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Was the image dropped in the right frame?-- Then, either matched or unmatched, a function is called depending on that, a sound is played and the control variable is changed.
        
        if(imageSelected == true){
        
            if (Cat_M == false){
                if Marco_1.frame.contains(iMagen1.center){
                    matched(marco: Marco_1, imagen: iMagen1)
                    playSoundDS(name: "cat_s")
                    Cat_M = true
                }else{
                    unmatched(imagen: iMagen1,origen: origiPosImage1!, marco: Marco_1)
                }
            }
            
            if(Dog_M == false){
                if Marco_2.frame.contains(iMagen2.center){
                    matched(marco: Marco_2, imagen: iMagen2)
                    playSoundDS(name: "dog_s")
                    Dog_M = true
                }else{
                    unmatched(imagen: iMagen2,origen: origiPosImage2!, marco: Marco_2)
                }
            }
            
            if(Bird_M == false){
                if Marco_3.frame.contains(iMagen3.center){
                    matched(marco: Marco_3, imagen: iMagen3)
                    playSoundDS(name: "bird_s")
                    Bird_M = true
                }else{
                    unmatched(imagen: iMagen3,origen: origiPosImage3!, marco: Marco_3)
                }
            }
            
        }
        
        
}
    
    //The image is in the right frame: The function receives tow parameters, the image and the frame, makes an animation to set and resize the image.
    func matched(marco: UIImageView, imagen: UIImageView){
        UIView.animate(withDuration: 1, animations: { () -> Void in
            marco.alpha = 1
            imagen.center = marco.center
            imagen.layer.shadowOpacity = 0
            imagen.transform = self.tempTransform
        })
        imageSelected = false
    }
    
    //The image is NOT in the right frame: The function receives three parameters, the image, its origin position and the frame, it makes an animation to resize and send back the image to its initial position.
    func unmatched(imagen: UIImageView, origen: CGPoint, marco: UIImageView){
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            imagen.frame.origin = origen
            marco.alpha = 0.6
            imagen.layer.shadowOpacity = 0
            imagen.transform = self.tempTransform
        }, completion: nil)
        imageSelected = false
    }
    
    
    //Play sound from Assets
    func playSoundDS(name: String){
        let sound: NSDataAsset
        sound = NSDataAsset(name: name)!
        
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            player.play()
        }catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
    }
}


