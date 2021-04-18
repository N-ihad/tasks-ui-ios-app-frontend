//
//  ParallelSystemViewController.swift
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
class ParallelSystemViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let dimension3ImageView = UIImageView.makeMethodResultImageView34tasks3d()
    private let dimension2ImageView = UIImageView.makeMethodResultImageView34tasks() // 1500x600
    private let dimensionTableImageView = UIImageView.makeMethodResultImageView34tasks3d(width: 786, height: 266) // 1964x665

    //----------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        style()
        layout()
        onGenerateImage()
    }

    //----------------------------------------------------------------------------
    func onGenerateImage()
    {
        view.makeToastActivity(.center)
        AF.request(
            "http://127.0.0.1:5000/generate-parallel-system-images",
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default)
            .responseJSON
            {
                [weak self]
                response in

                defer
                {
                    self?.view.hideToastActivity()
                }

                guard let value = response.value as? [String: AnyObject] else
                {
                    print("Error getting the data from response")
                    return
                }

                var images = value["data"] as! [String]
                images = images.map({ $0.removeExtraCharsBase64NoMutating() })

                var dataDecoded: Data = Data(base64Encoded: images[0], options: .ignoreUnknownCharacters)!
                var decodedimage = UIImage(data: dataDecoded)
                self?.dimension3ImageView.image = decodedimage

                dataDecoded = Data(base64Encoded: images[1], options: .ignoreUnknownCharacters)!
                decodedimage = UIImage(data: dataDecoded)
                self?.dimension2ImageView.image = decodedimage
                
                dataDecoded = Data(base64Encoded: images[2], options: .ignoreUnknownCharacters)!
                decodedimage = UIImage(data: dataDecoded)
                self?.dimensionTableImageView.image = decodedimage
            }
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Parallel System"
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

        let vStackView = UIStackView(arrangedSubviews: [dimension3ImageView, dimension2ImageView, dimensionTableImageView])
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.alignment = .center
        vStackView.spacing = 82

        contentView.addSubview(vStackView)
        vStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        vStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        vStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 332)
    }
}


