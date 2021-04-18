//
//  SymmetryLinesViewController.swift
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

fileprivate let spacing: CGFloat = 16
fileprivate let timerTimeInterval = 4

//============================================================================
class SymmetryLinesViewController: UIViewController
{
    private var timer = Timer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let templateImageView = UIImageView.makeMethodResultImageView()
    
    private let methodResultImageViews = [
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
    }

    //----------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool)
    {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerTimeInterval), target: self, selector: #selector(onGenerateSymmetryLinesImages), userInfo: nil, repeats: true)
    }

    //----------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool)
    {
        timer.invalidate()
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateSymmetryLinesImages()
    {
        AF.request(
            "http://127.0.0.1:5000/generate-symmetry-lines-images",
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

                for (image, imageView) in zip(images, strongSelf.methodResultImageViews)
                {
                    let dataDecoded: Data = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    UIView.animate(withDuration: 1)
                    {
                        imageView.image = decodedimage
                    }
                }
            }
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Symmetry Lines"
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

        let firstRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.distribution = .fill
        firstRowStackView.alignment = .center
        firstRowStackView.spacing = spacing

        var range = [1, 2, 3]
        for (imageView, _) in zip(methodResultImageViews, range)
        {
            firstRowStackView.addArrangedSubview(imageView)
        }

        let secondRowStackView = UIStackView()
        secondRowStackView.axis = .horizontal
        secondRowStackView.distribution = .fill
        secondRowStackView.alignment = .center
        secondRowStackView.spacing = spacing

        range = [1, 2, 3, 4, 5, 6]
        for (imageView, i) in zip(methodResultImageViews, range)
        {
            if i < 4 { continue }
            secondRowStackView.addArrangedSubview(imageView)
        }
        
        let rowsStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        rowsStackView.axis = .vertical
        rowsStackView.distribution = .fill
        rowsStackView.alignment = .center
        rowsStackView.spacing = spacing

        contentView.addSubview(rowsStackView)
        rowsStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        rowsStackView.autoAlignAxis(toSuperviewAxis: .vertical)
//        rowsStackView.autoPinEdge(.bottom, to: .bottom, of: contentView)
    }
}
