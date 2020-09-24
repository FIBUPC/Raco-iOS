//
//  NoticiesTableViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import FeedKit
import SafariServices
import SwiftSoup
import Alamofire
import AlamofireImage

class NoticiesTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let parser = FeedParser(URL: URL(string: feedURL)!)
    var news: [RSSFeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    
                    // Grab the parsed feed directly as an optional rss, atom or json feed object
                    self.news = (feed.rssFeed?.items)!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! NoticiaTableViewCell
        cell.titleLabel.text = news[indexPath.row].title
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let now = df.string(from: news[indexPath.row].pubDate!)
        cell.dataPublicadaLabel.text = now
        
        let html: String = news[indexPath.row].description!
        let doc: Document = try! SwiftSoup.parse(html)
        let link: Element = try! doc.select("img").first()!
        let linkHref: String = try! link.attr("src");
        
        Alamofire.request(linkHref).responseImage { response in
            if case .success(let image) = response.result {
                cell.newsImageView.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = news[indexPath.row].link
        
        if let url = URL(string: urlString!) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self as? SFSafariViewControllerDelegate
            
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
