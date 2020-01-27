//
//  SHBListPopupView.swift
//  GlobalSol
//
//  Created by Choi on 18/07/2019.
//  Copyright © 2019 Choi Seung Min. All rights reserved.
//

import UIKit

//MARK: - Protocol
@objc
protocol ChoiListPopupViewDelegate {
    @objc optional func touchUpInsideFromCell(_ row: Int)
    @objc optional func touchUpInsideFromCell(_ row: Int, _ section: Int)
}

class ChoiListPopupView : UIView, UITableViewDataSource, UITableViewDelegate, ChoiListPopupViewDelegate {
    
    //MARK: - Outlet
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var viewBottomSheet: UIView!
    @IBOutlet private weak var viewBottomSheetHeightConst: NSLayoutConstraint!
    @IBOutlet private weak var viewTitle: UIView!
    @IBOutlet private weak var viewTable: UITableView!
    @IBOutlet private weak var txtTitle: UILabel!
    
    //MARK: 전역변수
    private var arrOptions: [[String]] = []
    private var cellNibName: String = ""
    private var cellDispCount: CGFloat = 0
    private var cellHeight: CGFloat = 0
    private var safeTop: CGFloat = 20
    private var safeBottom: CGFloat = 0
    private var hasSection: Bool = false
    
    var delegate: ChoiListPopupViewDelegate?
    
    //MARK: - initialize
    /**
     title : 타이틀
     options : 표시할 데이터
     cellNibName : Xib명
     cellHeight : cell 높이값
     cellWidth : cell 넓이값
     cellDispCnt : 보여줄 셀 갯수 (테이블 뷰 높이를 조절함)
     hasSection : 섹션 존재여부
     */
    init(title:String, options: [[String]], cellNibName: String, cellHeight: CGFloat, cellDispCnt: CGFloat, hasSection: Bool) {
        super.init(frame: UIScreen.main.bounds)
        let view = Bundle.main.loadNibNamed("ChoiListPopupView", owner: self, options: nil)?.first as? UIView
        guard view != nil else {
            print("ChoiListPopupView Not Loaded")
            return
        }
        
        if cellNibName == "" {
            self.cellNibName = "ChoiListPopupBaseTableViewCell"
            self.cellHeight = 41
        } else {
            self.cellNibName = cellNibName
            self.cellHeight = cellHeight
        }
        
        self.arrOptions = options
        if hasSection == false {
            self.cellDispCount = cellDispCnt > CGFloat(self.arrOptions.count) ? CGFloat(self.arrOptions.count) : cellDispCnt
        } else {
            self.cellDispCount = cellDispCnt
        }

        self.hasSection = hasSection
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            self.safeTop = window?.safeAreaInsets.top ?? 0
            self.safeBottom = window?.safeAreaInsets.bottom ?? 0
        }
        
        view!.frame = UIScreen.main.bounds
        self.addSubview(view!)
        self.txtTitle.text = title
        
        let bounds = UIScreen.main.bounds
        let safeAreaHeight: CGFloat = bounds.height - self.safeTop - self.safeBottom
        var viewHeight: CGFloat = self.cellHeight * CGFloat(self.cellDispCount) + self.viewTitle.frame.height
        
        if viewHeight > safeAreaHeight {
            viewHeight = safeAreaHeight
        }
        
        self.viewBottomSheetHeightConst.constant = viewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Button Event
    @IBAction private func touchUpInsideFromButton(_ sender: UIButton) {
        switch sender.tag {
        // Background
        case 10:
            self.fadeOut()
            break
            
        // 닫기
        case 100:
            self.fadeOut()
            break
            
        default:
            break
        }
    }
    
    //MARK: - show & hide
    func showInView(_ vc:UIViewController, animated:Bool) {
        vc.view.addSubview(self)
        
        if animated {
            self.fadeIn()
        }
    }
    
    func fadeIn() {
        self.viewBottomSheet.transform = CGAffineTransform.init(translationX: 0, y: self.viewBottomSheetHeightConst.constant + self.safeBottom)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewBottomSheet.transform = CGAffineTransform.init(translationX: 0, y: 0)
        })
    }
    
    func fadeOut() {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewBottomSheet.transform = CGAffineTransform.init(translationX: 0, y: self.viewBottomSheetHeightConst.constant + self.safeBottom)
        }, completion: completion)
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.hasSection == false {
            return 1
        } else {
            return arrOptions.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.hasSection == true {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: self.cellHeight))
            let label = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width - 15, height: self.cellHeight - 5))

            //MARK: - Section 의 폰트 변경시 아래의 폰트를 변경해주세요.
            label.font = UIFont.systemFont(ofSize: 22)
            label.text = arrOptions[section][0]
            view.addSubview(label)
            view.backgroundColor = .white
            return view
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.hasSection == true {
            return self.cellHeight
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasSection == false {
            return self.arrOptions.count
        } else {
            return arrOptions[section].count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellNibName)
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(self.cellNibName, owner: self, options: nil)?.first as? UITableViewCell
        }

        if self.hasSection == false {
            let row: Int = indexPath.row
            let arr: [String] = self.arrOptions[row]
            var tmpLbl : UILabel? = nil
            let labels = cell?.contentView.subviews.compactMap { $0 as? UILabel }

            let lblCnt: Int = labels?.count ?? 0

            for i in 0..<lblCnt {
                tmpLbl = labels![i]
                tmpLbl?.text = arr[i]
            }

            cell!.selectionStyle = .none
            cell!.backgroundColor = .clear

            return cell!
        } else {
            let section: Int = indexPath.section
            var arr: [String] = self.arrOptions[section]
            arr.removeFirst()
            cell?.textLabel?.text = arr[indexPath.row]

            cell!.selectionStyle = .none
            cell!.backgroundColor = .clear

            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.hasSection == false {
            self.fadeOut()
            if self.delegate != nil {
                self.delegate?.touchUpInsideFromCell?(indexPath.row)
            }
        } else {
            self.fadeOut()
            if self.delegate != nil {
                self.delegate?.touchUpInsideFromCell?(indexPath.row + 1, indexPath.section)
            }
        }
    }
}
