//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Mitchell Murphy on 4/27/16.
//  Copyright © 2016 Mitch Murphy. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")
        
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell?.imageView?.image = meme.memeImage
        cell?.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        _ = detailViewController.view
        
        let meme: Meme = appDelegate.memes[indexPath.row]
        detailViewController.imageView.image = meme.memeImage
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
