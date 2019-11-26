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
        friends.append(Friend(image: UIImage(named: "ios")!, name: "ios"))
        friends.append(Friend(image: UIImage(named: "swift")!, name: "Swift"))
        return friends
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        let SearchFriendResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchFriendResultVC") as! SearchFriendResultVC
        let friend = friends[indexPath.row]
        SearchFriendResultVC.friend = friend
        self.navigationController?.pushViewController(SearchFriendResultVC, animated: true)
    }
}
