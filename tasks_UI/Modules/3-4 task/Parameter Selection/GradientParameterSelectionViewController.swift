//
//  GradientParameterSelectionViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/19/21.
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
class GradientParameterSelectionViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let bestParameter = UILabel.makeMethodLabel(withText: "             Лучший параметр: ")
    private let numberOfEtalons = UILabel.makeMethodLabel(withText: "             Количество эталонов: ")
    private let numberOfTestImages = UILabel.makeMethodLabel(withText: "             Количество тестовых изображений: ")
    private let bestScore = UILabel.makeMethodLabel(withText: "             Лучший результат: ")
    
    private let methodResult3dImageView = UIImageView.makeMethodResultImageView34tasks3d()

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
            "http://127.0.0.1:5000/generate-gradient-parameter-selection-image",
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

                var image = value["data"] as! String
                image.removeExtraCharsBase64()

                let dataDecoded: Data = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                self?.methodResult3dImageView.image = decodedimage

                var str = value["best_parameter"] as! String
                self?.bestParameter.text! += str

                str = value["number_of_etalons"] as! String
                self?.numberOfEtalons.text! += str
                
                str = value["number_of_test_images"] as! String
                self?.numberOfTestImages.text! += str

                str = value["best_score"] as! String
                self?.bestScore.text! += str
                
                self?.view.hideToastActivity()
            }
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Gradient Parameter Selection"
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

        let vStackView = UIStackView(arrangedSubviews: [bestParameter, numberOfEtalons, numberOfTestImages, bestScore, methodResult3dImageView])
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.alignment = .leading
        vStackView.spacing = 8

        contentView.addSubview(vStackView)
        vStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        vStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        vStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 124)
    }
}

