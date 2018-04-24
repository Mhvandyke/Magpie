//
//  DetailViewController.swift
//  MagpieProto
//
//  Created by Michael Van Dyke, Sean Dougan and Gregory Uchitel on 2018-03-22.
//  Copyright © 2018 MagpieTeam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    
    
    var text:String = ""
    
    var masterView:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.text = text
          self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // Button to change to create note
    @IBAction func buttonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Links the Note Entity with the Object Context
        let note = NoteEnt(context: context)
         note.content = contentTextField.text!
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // object currently recieving events
        textView.becomeFirstResponder()
    }
    
    func setText (t:String){
        
        text = t
        if isViewLoaded {
            textView.text = t
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        masterView.newRowText = textView.text
        textView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
