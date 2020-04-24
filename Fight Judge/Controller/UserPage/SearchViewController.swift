//
//  SearchViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/12.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchUserTableViewCellDelegate {
    
    var users = [NCMBUser]()
    
    var followingUserIds = [String]()
    
    var searchBar: UISearchBar!
    var cellNumber : Int!
    
    @IBOutlet var searchUserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setSearchBar()
        
        searchUserTableView.dataSource = self
        searchUserTableView.delegate = self
        
        // カスタムセルの登録
        let nib = UINib(nibName: "SearchUserTableViewCell", bundle: Bundle.main)
        searchUserTableView.register(nib, forCellReuseIdentifier: "SearchUserTableViewCell")
        
        // 余計な線を消す
        searchUserTableView.tableFooterView = UIView()
        
        searchUserTableView.rowHeight = 85
        
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField

//        textFieldInsideSearchBar?.textColor = .white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsers(searchText: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showUserViewController = segue.destination as! ShowUserViewController
        let selectedIndex = searchUserTableView.indexPathForSelectedRow!
        let userName = users[selectedIndex.row].object(forKey: "userName") as? String
        showUserViewController.userName = userName
        showUserViewController.selectedUser = users[selectedIndex.row]
    }
    
    
//    func setSearchBar() {
//        // NavigationBarにSearchBarをセット
//        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
//            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
//            searchBar.delegate = self
//            searchBar.placeholder = "ユーザーを検索"
//            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
//            navigationItem.titleView = searchBar
//            navigationItem.titleView?.frame = searchBar.frame
//            self.searchBar = searchBar
//        }
//    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadUsers(searchText: nil)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadUsers(searchText: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTableViewCell") as! SearchUserTableViewCell
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + users[indexPath.row].objectId
        let image = UIImage(named: "placeholder.jpg")
        
        self.cellNumber = indexPath.row
        
        cell.userImageView.kf.setImage(with: URL(string: userImageUrl),placeholder: image)
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
        cell.userImageView.layer.masksToBounds = true
        
        cell.userNameLabel.text = users[indexPath.row].object(forKey: "displayName") as? String
        cell.displayNameLabel.text = users[indexPath.row].object(forKey: "userName") as? String
        cell.selfIntroduceLabel.text = users[indexPath.row].object(forKey: "introduction") as? String
        
        // Followボタンを機能させる
        cell.tag = indexPath.row
        cell.delegate = self
        
        if followingUserIds.contains(users[indexPath.row].objectId) == true {
            cell.followButton.isHidden = true
        } else {
            cell.followButton.isHidden = false
        }
        
        return cell
    }
    
    //cellが押された時に画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toWatchUserPage", sender: nil)
        //選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
       
    
    func didTapFollowButton(tableViewCell: UITableViewCell, button: UIButton) {
        let userName = users[tableViewCell.tag].object(forKey: "userName") as? String
        let message = userName! + "をフォローしますか？"
        let alert = UIAlertController(title: "フォロー", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.follow(selectedUser: self.users[tableViewCell.tag])
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func follow(selectedUser: NCMBUser) {
        let object = NCMBObject(className: "Follow")
        if let currentUser = NCMBUser.current() {
            object?.setObject(currentUser, forKey: "user")
            object?.setObject(selectedUser, forKey: "following")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    self.loadUsers(searchText: nil)
                }
            })
        } else {
            // currentUserが空(nil)だったらログイン画面へ
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
    }
    
    func loadUsers(searchText: String?) {
        guard let currentUser = NCMBUser.current() else {
                    // ログインに戻る
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    // ログインしていない状態の保持(AppDelegateの"isLogin"の宣言より)
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                    return
                }
        let query = NCMBUser.query()
        // 自分を除外
        query?.whereKey("objectId", notEqualTo: NCMBUser.current().objectId)
        // 退会済みアカウントを除外
        query?.whereKey("active", notEqualTo: false)

        // 検索ワードがある場合
        if let text = searchText {
            query?.whereKey("userName", equalTo: text)
        }

        // 新着ユーザー50人だけ拾う
        query?.limit = 50
        query?.order(byDescending: "createDate")

        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 取得した新着50件のユーザーを格納
                self.users = result as! [NCMBUser]

                self.loadFollowingUserIds()
            }
        })
    }
    
    func loadFollowingUserIds() {
        let query = NCMBQuery(className: "Follow")
        query?.includeKey("user")
        query?.includeKey("following")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.followingUserIds = [String]()
                for following in result as! [NCMBObject] {
                    let user = following.object(forKey: "following") as! NCMBUser
                    self.followingUserIds.append(user.objectId)
                }
                
                self.searchUserTableView.reloadData()
            }
        })
    }
    
}
