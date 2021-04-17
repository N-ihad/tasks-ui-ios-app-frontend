//
//  ThirdTaskViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/17/21.
//

import UIKit
import FloatingButton
import AHDownloadButton
import PureLayout
import MaterialComponents.MaterialButtons
import Alamofire
import Toast_Swift

//============================================================================
class ThirdTaskViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let methodsResultImageViews = [
        UIImageView.makeMethodResultImageView(),
        UIImageView.makeMethodResultImageView(),
        UIImageView.makeMethodResultImageView(),
        UIImageView.makeMethodResultImageView(),
        UIImageView.makeMethodResultImageView(),
        UIImageView.makeMethodResultImageView(),
    ]

    //----------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        style()
        layout()
        scheduledTimerWithTimeInterval()
    }

    //----------------------------------------------------------------------------
    func scheduledTimerWithTimeInterval()
    {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(onGenerateImages), userInfo: nil, repeats: true)
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateImages()
    {
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Third Task"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }

    //----------------------------------------------------------------------------
    func layout()
    {
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()

        scrollView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: scrollView)
    }
}
