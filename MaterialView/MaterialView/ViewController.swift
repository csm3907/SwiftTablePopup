//
//  ViewController.swift
//  MaterialView
//
//  Created by 60067659 on 27/01/2020.
//  Copyright © 2020 최승민. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - 화면 호출 뷰
    var myTableView: ChoiListPopupView?        // 화면 호출 변수
    // 표시 내용 List
    var listTemp = [["직접 입력"],["101호 월세"],["아들 용돈"],["생활비 입금"],["호날두 왜그랬니"],["메시와 함께라면"],["나에게로 돌아오는"]]
    // 표시 내용 List (섹션 존재시 섹션의 값을 맨 처음에 적는다.)
    var cardMessage: [[String]] = [["축하","축하합니다","졸업을 축하해요","취업을 축하합니다"],["감사","항상 고마워요","Thank You","감사합니다~"],["응원","언제나 힘내요","당신을 응원합니다"]]

    //MARK: - 테이블 뷰 호출
    @IBAction func ListPopViewCallIn(_ sender: UIButton) {
        myTableView = ChoiListPopupView.init(title: "테이블", options: listTemp, cellNibName: "", cellHeight: 43.3, cellDispCnt: 8, hasSection: false)
        myTableView?.delegate = self
        myTableView?.showInView(self, animated: true)
    }

    //MARK: - 테이블 섹션 존재 팝업 호출
    @IBAction func SectionTableCallIn(_ sender: UIButton) {
        myTableView = ChoiListPopupView.init(title: "테이블(섹션)", options: cardMessage, cellNibName: "", cellHeight: 43.3, cellDispCnt: 8, hasSection: true)
        myTableView?.delegate = self
        myTableView?.showInView(self, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension ViewController: ChoiListPopupViewDelegate {
    func touchUpInsideFromCell(_ row: Int) {
        print("row : \(row)")
    }
}

