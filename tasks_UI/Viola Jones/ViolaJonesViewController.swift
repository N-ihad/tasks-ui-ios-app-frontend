//
//  ViolaJonesViewController.swift
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
class ViolaJonesViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let templateImageView = UIImageView.makeMethodResultImageView()
    
    private lazy var generateTemplateButton: MDCButton = MDCButton.makeButton(withTitle: "Generate", target: self, andSelector: #selector(onGenerateTemplate))
    
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
//        scheduledTimerWithTimeInterval()
    }

    //----------------------------------------------------------------------------
    func scheduledTimerWithTimeInterval()
    {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(onGenerateImages), userInfo: nil, repeats: true)
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateImages()
    {
        AF.request(
            "http://127.0.0.1:5000/generate-images",
            method: .get,
            encoding: URLEncoding.default)
            .responseJSON
            {
                [weak self]
                response in

                guard let value = response.value as? [String: AnyObject] else
                {
                    return
                }

                var images = value["data"] as! [String]
                images = images.map({ $0.removeExtraCharsBase64NoMutating() })
                
                guard let strongSelf = self else
                {
                    return
                }

                for (image, imageView) in zip(images, strongSelf.methodsResultImageViews)
                {
                    let dataDecoded: Data = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    imageView.image = decodedimage
                }
            }
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateTemplate()
    {
        view.makeToastActivity(.center)

        AF.request(
            "http://127.0.0.1:5000/generate",
            method: .get,
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
                    return
                }

                var strData = value["data"] as! String
                strData.removeExtraCharsBase64()

                let dataDecoded: Data = Data(base64Encoded: strData, options: .ignoreUnknownCharacters)!

                let decodedimage = UIImage(data: dataDecoded)

                self?.templateImageView.image = decodedimage
            }
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Viola Jones"
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

        contentView.addSubview(templateImageView)
        templateImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 40)
        templateImageView.autoAlignAxis(toSuperviewAxis: .vertical)

        contentView.addSubview(generateTemplateButton)
        generateTemplateButton.autoPinEdge(.top, to: .bottom, of: templateImageView, withOffset: 40)
        generateTemplateButton.autoAlignAxis(toSuperviewAxis: .vertical)

        let firstRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.distribution = .fill
        firstRowStackView.alignment = .center
        firstRowStackView.spacing = 8

        var range = [1, 2, 3]
        for (imageView, _) in zip(methodsResultImageViews, range)
        {
            firstRowStackView.addArrangedSubview(imageView)
        }
        
        let secondRowStackView = UIStackView()
        secondRowStackView.axis = .horizontal
        secondRowStackView.distribution = .fill
        secondRowStackView.alignment = .center
        secondRowStackView.spacing = 8

        range = [1, 2, 3, 4, 5, 6]
        for (imageView, i) in zip(methodsResultImageViews, range)
        {
            if i < 4 { continue }
            secondRowStackView.addArrangedSubview(imageView)
        }
        
        let rowsStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        rowsStackView.axis = .vertical
        rowsStackView.distribution = .fill
        rowsStackView.alignment = .center
        rowsStackView.spacing = 8

        contentView.addSubview(rowsStackView)
        rowsStackView.autoPinEdge(.top, to: .bottom, of: generateTemplateButton, withOffset: 20)
        rowsStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        rowsStackView.autoPinEdge(.bottom, to: .bottom, of: contentView)
    }
}
