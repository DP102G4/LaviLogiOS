//
//  SearchFriendVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class SearchFriendVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friends = [Friend]()
    
    // 儲存搜尋結果資料
    var searchFriends = [Friend]()
    // 是否要顯示搜尋後資料
    var search = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        friends = getFriends()
        
        /* 取用editButtonItem會回傳Edit/Done自動切換的按鈕。點擊Edit按鈕會呼叫viewController.setEditing(Bool, Bool)，也可自訂按鈕，點擊後呼叫setEditing(true, animated: true)以達到同樣效果，結束時呼叫setEditing(false, animated: true) */
        navigationItem.rightBarButtonItem = editButtonItem
        // editButtonItem = 系統常數 不能隨便命名
        // leftBarButtonItem = 左邊
        // rightBarButtonItem = 右邊
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchFriends = friends.filter({ (friend) -> Bool in
                return friend.name.uppercased().contains(text.uppercased())
            })
            search = true
        }
        tableView.reloadData()
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    // 取得測試資料
    func getFriends() -> [Friend] {
        var friends = [Friend]()
        friends.append(Friend(image: UIImage(named: "ios")!, name: "蔡英文"))
        friends.append(Friend(image: UIImage(named: "swift")!, name: "韓國瑜"))
        return friends
    }
}

extension SearchFriendVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search {
            return searchFriends.count
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friend : Friend
        if search {
            friend = searchFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        let cellId = "friendCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FriendCell
        cell.ivFriend?.image = friend.image
        cell.lbFriend.text = friend.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Identifier必須設定與Indentity inspector的Storyboard ID相同 */
        let searchFriendResultVC = self.storyboard?.instantiateViewController(withIdentifier: "searchFriendResultVC") as! SearchFriendResultVC
        let friend = friends[indexPath.row]
        searchFriendResultVC.friend = friend
        self.navigationController?.pushViewController(searchFriendResultVC, animated: true)
    }
    
    /* 設定可否編輯資料列 */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
         if indexPath.row == 1{
             return false
         }
         //使第二個資料無法修改
        
        return true
    }
    
    /* 修改確定後，判斷編輯模式並作出回應 */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 按下Delete按鈕
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            /* 提供array，儲存著欲刪除資料的indexPath。如果只刪除一筆資料，array內存放一個indexPath元素即可 */
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /* 設定可否移動資料列 */
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* 指定資料列從來源位置移動到目的位置 */
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let friend = friends[fromIndexPath.row]
        /* 必須先移除後新增資料，順序不可顛倒 */
        friends.remove(at: fromIndexPath.row) // 不是移除資料 是移除參數
        friends.insert(friend, at: to.row) // 參照移到另一個位子
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
