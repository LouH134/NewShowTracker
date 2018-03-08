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
}

