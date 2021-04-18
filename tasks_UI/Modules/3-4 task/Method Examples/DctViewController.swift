//
//  DctViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/18/21.
//

import UIKit
import FloatingButton
import AHDownloadButton
import PureLayout
import MaterialComponents.MaterialButtons
import Alamofire
import Toast_Swift

fileprivate let timerTimeInterval = 2

//============================================================================
class DctViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let methodResultImageView = UIImageView.makeMethodResultImageView34tasks()
    private let methodResultStatisticsImageView = UIImageView.makeMethodResultImageView34tasks()

    //----------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        style()
        layout()
    }

    //----------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool)
    {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerTimeInterval), target: self, selector: #selector(onGenerateImage), userInfo: nil, repeats: true)
    }

    //----------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool)
    {
        timer.invalidate()
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateImage()
    {
        AF.request(
            "http://127.0.0.1:5000/generate-dct-example-images",
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default)
            .responseJSON
            {
                [weak self]
                response in

                guard let value = response.value as? [String: AnyObject] else
                {
                    print("Error getting the data from response")
                    return
                }

                var images = value["data"] as! [String]
                images = images.map({ $0.removeExtraCharsBase64NoMutating() })

                var dataDecoded: Data = Data(base64Encoded: images[0], options: .ignoreUnknownCharacters)!
                var decodedimage = UIImage(data: dataDecoded)
                self?.methodResultImageView.image = decodedimage

                dataDecoded = Data(base64Encoded: images[1], options: .ignoreUnknownCharacters)!
                decodedimage = UIImage(data: dataDecoded)
                self?.methodResultStatisticsImageView.image = decodedimage
            }
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "DCT"
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

        let vStackView = UIStackView(arrangedSubviews: [methodResultImageView, methodResultStatisticsImageView])
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.alignment = .center
        vStackView.spacing = 32

        contentView.addSubview(vStackView)
        vStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        vStackView.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
