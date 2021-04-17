//
//  ViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/15/21.
//

import UIKit
import PureLayout
import MaterialComponents.MaterialButtons
import Alamofire
import Toast_Swift

let themeButtonColor = UIColor(red: 0.29, green: 0.00, blue: 0.92, alpha: 1.00)
let themeImagePlaceholderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)

var parameters: [String: Any] = [
    "facePart" : "face"
]

//============================================================================
class TemplateMatchingViewController: UIViewController
{
    private var timer = Timer()
    private var choosenFaceParts: Set<FacePart> = []
    private var choosenFacePart = FacePart.face
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let templateImageView: UIImageView = {
        let templateImageView = UIImageView.makeMethodResultImageView()
        templateImageView.image = UIImage(named: "0.jpg")!

        return templateImageView
    }()
    
    private lazy var generateTemplateButton: MDCButton = MDCButton.makeButton(withTitle: "Generate", target: self, andSelector: #selector(onGenerateTemplate))
    
    private let methodsNameLabels = [
        UILabel.makeMethodLabel(withText: "TM_CCOEFF"),
        UILabel.makeMethodLabel(withText: "TM_CCOEFF_NORMED"),
        UILabel.makeMethodLabel(withText: "TM_CCORR"),
        UILabel.makeMethodLabel(withText: "TM_CCORR_NORMED"),
        UILabel.makeMethodLabel(withText: "TM_SQDIFF"),
        UILabel.makeMethodLabel(withText: "TM_SQDIFF_NORMED"),
    ]
    
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

        setNavigationBar()
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
        if let randomElement = choosenFaceParts.randomElement()
        {
            choosenFacePart = randomElement
        }
    
        parameters["facePart"] = choosenFacePart.rawValue

        AF.request(
            "http://127.0.0.1:5000/generate-images",
            method: .get,
            parameters: parameters,
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
    @objc func onSettingsTapped()
    {
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .pageSheet
        settingsViewController.delegate = self

        present(settingsViewController, animated: true)
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateTemplate()
    {
        view.makeToastActivity(.center)

        AF.request(
            "http://127.0.0.1:5000/generate",
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
    func setNavigationBar()
    {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear")!, style: .plain, target: self, action: #selector(onSettingsTapped))
        settingsButton.tintColor = .black
        navigationItem.rightBarButtonItem = settingsButton
    }

    //----------------------------------------------------------------------------
    func style()
    {
        title = "Template Matching"
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
        for ((label, imageView), _) in zip(zip(methodsNameLabels, methodsResultImageViews), range)
        {
            let vStackView = UIStackView(arrangedSubviews: [label, imageView])
            vStackView.axis = .vertical
            vStackView.distribution = .fill
            vStackView.alignment = .leading
            vStackView.spacing = 3
            firstRowStackView.addArrangedSubview(vStackView)
        }
        
        let secondRowStackView = UIStackView()
        secondRowStackView.axis = .horizontal
        secondRowStackView.distribution = .fill
        secondRowStackView.alignment = .center
        secondRowStackView.spacing = 8

        range = [1, 2, 3, 4, 5, 6]
        for ((label, imageView), i) in zip(zip(methodsNameLabels, methodsResultImageViews), range)
        {
            if i < 4 { continue }
            let vStackView = UIStackView(arrangedSubviews: [label, imageView])
            vStackView.axis = .vertical
            vStackView.distribution = .fill
            vStackView.alignment = .leading
            vStackView.spacing = 3
            secondRowStackView.addArrangedSubview(vStackView)
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

//        contentView.addSubview(vStackView)
//        vStackView.autoPinEdge(.top, to: .bottom, of: generateTemplateButton, withOffset: 20)
//        vStackView.autoAlignAxis(toSuperviewAxis: .vertical)
//        vStackView.autoPinEdge(.bottom, to: .bottom, of: contentView)
    }
}

// MARK: - SettingsViewControllerDelegate
//============================================================================
extension TemplateMatchingViewController: SettingsViewControllerDelegate
{
    //----------------------------------------------------------------------------
    func SettingsViewControllerDidFinish(_ choosenFaceParts: Set<FacePart>)
    {
        guard !choosenFaceParts.isEmpty else
        {
            return
        }

        self.choosenFaceParts = choosenFaceParts
    }
}

