//
//  DataHandler.swift
//  NewShowTracker
//
//  Created by Louis Harris on 2/28/18.
//  Copyright © 2018 Louis Harris. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class DataHandler{
    
    
    static func logIn(email:String, password:String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage:String?) -> Void){
        print("login")
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user, error) in if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    static func signUp(username:String, email:String, password:String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage:String?)-> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in if error != nil{
            onError(error!.localizedDescription)
            return
            }
            
            let uid = user?.uid
            
            self.setUserInfo(username: username, email: email, uid: uid!, onSuccess: onSuccess)
        })
    }
    
    static func setUserInfo(username:String, email:String, uid:String, onSuccess: @escaping() -> Void){
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username":username, "email":email])
        
        onSuccess()
    }
    
    struct URLConfig {
        static var ROOT_URL = "https://showtracker-b0a1c.firebaseio.com"
    }
    
    static func sendDataToDatabase(shareArray:[String], storageID:String, userID:String, onSuccess: @escaping(_ isSuccess:Bool, String?) -> ()){
        //create node in database
        let ref = Database.database().reference()
        let listReference = ref.child("Lists")
        let newListID = listReference.childByAutoId().key
        
        //Problem: newListID is always different so list will never exist.
        //New Problem: need current user to get the unique ID so I need a UIKit but DataHandler isn't a view controller. I could make a function in Firstview controller but not supposed to do network calls in viewcontroller.
        let newListReference = listReference.child(newListID)
        //adding childs to post
        newListReference.setValue(["List":shareArray, "StorageID":storageID, "User":userID], withCompletionBlock:{(error,ref) in if error != nil{
            ProgressHUD.showError(error!.localizedDescription)
            return
            }
        })
        onSuccess(true, newListID)
    }
    
}

