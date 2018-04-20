//
//  ViewController.swift
//  MagpieProto
//
//  Created by Michael Van Dyke, Sean Dougan and Gregory Uchitel on 2018-03-22.
//  Copyright © 2018 MagpieTeam. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    var data:[String] = []
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    // URL of file for persistant storage
    var fileURL:URL!
    
    
    // View did load only calls once for initialization
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        table.dataSource = self
        
        table.delegate = self
        
        // Notes title
        self.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
         self.navigationItem.largeTitleDisplayMode = .always
       
        // Navigation buttons
         let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = baseURL.appendingPathComponent("notes.txt")
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
            
        }
        data[selectedRow] = newRowText
        if newRowText == "" {
            
            data.remove(at: selectedRow)
        }
        
        table.reloadData()
        
        save()
        
    }
    
    
    @objc func addNote() {
        if table.isEditing {
            return
        }
        
        // if the titles were handled by +1
       // let name:String = "Item \(data.count + 1)"
        
        let name:String = ""
        
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        
        // any time segue it triggered, row is already selected
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        
        // save note after note is created (not empty)
           self.performSegue(withIdentifier: "detail", sender: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Handles the animation when switching to editing
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        
        //animation for deleting row
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        
        
        selectedRow = table.indexPathForSelectedRow!.row
        
        detailView.masterView = self
        detailView.setText(t: data[selectedRow])
        
    }
    
    
    
    func save() {
        //UserDefaults.standard.set(data, forKey: "notes")
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing file")
        }
    }
    
    func load() {
        if let loadedData:[String] = NSArray(contentsOf:fileURL) as? [String] {
            data = loadedData
            table.reloadData()
        }
    }
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

