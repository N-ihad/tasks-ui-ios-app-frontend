//
//  ViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/15/21.
//

import UIKit
import PureLayout
import Alamofire
import Toast_Swift

let themeButtonColor = UIColor(red: 0.29, green: 0.00, blue: 0.92, alpha: 1.00)
let themeImagePlaceholderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
fileprivate let timerTimeInterval = 2

var parameters: [String: Any] = [
    "facePart" : "face"
]

fileprivate let spacing: CGFloat = 16

var choosenFaceParts: Set<FacePart> = [.face]

//============================================================================
class TemplateMatchingViewController: UIViewController
{
    private var timer = Timer()
    private var choosenFacePart = FacePart.face
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let currentlySearchingLabel: UILabel = {
        let currentlySearchingLabel = UILabel.makeMethodLabel(withText: "Currently searching:")
        currentlySearchingLabel.font = UIFont.boldSystemFont(ofSize: 28)
        currentlySearchingLabel.isHidden = true

        return currentlySearchingLabel
    }()

    private let currentlySearchingActiveFacePart = UILabel.makeMethodLabel(withText: "Face")

    private lazy var currentlySearchingVerticalStackView = UIStackView(arrangedSubviews: [currentlySearchingLabel])

    private let templateImageView: UIImageView = {
        let templateImageView = UIImageView.makeMethodResultImageView()
        templateImageView.image = UIImage(named: "general.jpg")!

        return templateImageView
    }()
    
    private let searchingFilterLabel: UILabel = {
        let searchingFilterLabel = UILabel.makeMethodLabel(withText: "Searching filter:")
        searchingFilterLabel.font = UIFont.boldSystemFont(ofSize: 28)

        return searchingFilterLabel
    }()

    private lazy var searchFilterVerticalStackView = UIStackView()
    private let faceLabel = UILabel.makeMethodLabel(withText: FacePart.face.rawValue.capitalized)
    private let upperFaceLabel = UILabel.makeMethodLabel(withText: "Upper Face")
    private let eyesLabel = UILabel.makeMethodLabel(withText: FacePart.eyes.rawValue.capitalized)
    private let noseLabel = UILabel.makeMethodLabel(withText: FacePart.nose.rawValue.capitalized)
    private let mouthLabel = UILabel.makeMethodLabel(withText: FacePart.mouth.rawValue.capitalized)
    
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
    }

    //----------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool)
    {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerTimeInterval), target: self, selector: #selector(onGenerateImages), userInfo: nil, repeats: true)
    }

    //----------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool)
    {
        timer.invalidate()
    }

    //----------------------------------------------------------------------------
    @objc func onGenerateImages()
    {
        if let randomElement = choosenFaceParts.randomElement()
        {
            choosenFacePart = randomElement
        }
    
        currentlySearchingLabel.text = choosenFacePart == .upperFace ? "Upper Face" : choosenFacePart.rawValue.capitalized

        searchFilterVerticalStackView.arrangedSubviews.forEach
        {
            arrangedSubview in

            let currentlyChoosenFacePartLabel = (arrangedSubview as! UILabel)

            if currentlyChoosenFacePartLabel.text == currentlySearchingLabel.text || currentlyChoosenFacePartLabel.text == (currentlySearchingLabel.text! + " 🟢")
            {
                currentlyChoosenFacePartLabel.text! = currentlySearchingLabel.text! + " 🟢"
            }
            else
            {
                currentlyChoosenFacePartLabel.text = currentlyChoosenFacePartLabel.text!.replacingOccurrences(of: " 🟢", with: "")
            }
        }

        templateImageView.image = UIImage(named: choosenFacePart.rawValue + ".jpg")

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

        currentlySearchingVerticalStackView.axis = .vertical
        currentlySearchingVerticalStackView.distribution = .fill
        currentlySearchingVerticalStackView.alignment = .leading
        currentlySearchingVerticalStackView.spacing = 3
        currentlySearchingVerticalStackView.addArrangedSubview(faceLabel)

        contentView.addSubview(currentlySearchingVerticalStackView)
        currentlySearchingVerticalStackView.autoPinEdge(.right, to: .left, of: templateImageView, withOffset: -32)
        currentlySearchingVerticalStackView.autoAlignAxis(.firstBaseline, toSameAxisOf: templateImageView)

        searchFilterVerticalStackView.axis = .vertical
        searchFilterVerticalStackView.distribution = .fill
        searchFilterVerticalStackView.alignment = .leading
        searchFilterVerticalStackView.spacing = 3
        searchFilterVerticalStackView.addArrangedSubview(faceLabel)

        contentView.addSubview(searchingFilterLabel)
        searchingFilterLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 40)
        searchingFilterLabel.autoPinEdge(.left, to: .right, of: templateImageView, withOffset: 32)

        contentView.addSubview(searchFilterVerticalStackView)
        searchFilterVerticalStackView.autoPinEdge(.top, to: .bottom, of: searchingFilterLabel, withOffset: 8)
        searchFilterVerticalStackView.autoPinEdge(.left, to: .right, of: templateImageView, withOffset: 32)

        let firstRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.distribution = .fill
        firstRowStackView.alignment = .center
        firstRowStackView.spacing = spacing

        var range = [1, 2, 3]
        for ((label, imageView), _) in zip(zip(methodsNameLabels, methodsResultImageViews), range)
        {
            let vStackView = UIStackView(arrangedSubviews: [label, imageView])
            vStackView.axis = .vertical
            vStackView.distribution = .fill
            vStackView.alignment = .leading
            vStackView.spacing = 8
            firstRowStackView.addArrangedSubview(vStackView)
        }
        
        let secondRowStackView = UIStackView()
        secondRowStackView.axis = .horizontal
        secondRowStackView.distribution = .fill
        secondRowStackView.alignment = .center
        secondRowStackView.spacing = spacing

        range = [1, 2, 3, 4, 5, 6]
        for ((label, imageView), i) in zip(zip(methodsNameLabels, methodsResultImageViews), range)
        {
            if i < 4 { continue }
            let vStackView = UIStackView(arrangedSubviews: [label, imageView])
            vStackView.axis = .vertical
            vStackView.distribution = .fill
            vStackView.alignment = .leading
            vStackView.spacing = 8
            secondRowStackView.addArrangedSubview(vStackView)
        }
        
        let rowsStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        rowsStackView.axis = .vertical
        rowsStackView.distribution = .fill
        rowsStackView.alignment = .center
        rowsStackView.spacing = spacing

        contentView.addSubview(rowsStackView)
        rowsStackView.autoPinEdge(.top, to: .bottom, of: templateImageView, withOffset: 32)
        rowsStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        rowsStackView.autoPinEdge(.bottom, to: .bottom, of: contentView)
    }
}

// MARK: - SettingsViewControllerDelegate
//============================================================================
extension TemplateMatchingViewController: SettingsViewControllerDelegate
{
    //----------------------------------------------------------------------------
    func SettingsViewControllerDidFinish(_ _choosenFaceParts: Set<FacePart>)
    {
        while let first = searchFilterVerticalStackView.arrangedSubviews.first
        {
            searchFilterVerticalStackView.removeArrangedSubview(first)
            first.removeFromSuperview()
        }

        guard !_choosenFaceParts.isEmpty else
        {
            choosenFacePart = .face
            searchFilterVerticalStackView.removeArrangedSubview(upperFaceLabel)
            searchFilterVerticalStackView.removeArrangedSubview(eyesLabel)
            searchFilterVerticalStackView.removeArrangedSubview(noseLabel)
            searchFilterVerticalStackView.removeArrangedSubview(mouthLabel)
            searchFilterVerticalStackView.addArrangedSubview(faceLabel)
            return
        }

        if !choosenFaceParts.contains(.face)
        {
            searchFilterVerticalStackView.removeArrangedSubview(faceLabel)
        }
        else
        {
            searchFilterVerticalStackView.addArrangedSubview(faceLabel)
        }
        
        if !choosenFaceParts.contains(.upperFace)
        {
            searchFilterVerticalStackView.removeArrangedSubview(upperFaceLabel)
        }
        else
        {
            searchFilterVerticalStackView.addArrangedSubview(upperFaceLabel)
        }
        
        if !choosenFaceParts.contains(.eyes)
        {
            searchFilterVerticalStackView.removeArrangedSubview(eyesLabel)
        }
        else
        {
            searchFilterVerticalStackView.addArrangedSubview(eyesLabel)
        }
        
        if !choosenFaceParts.contains(.nose)
        {
            searchFilterVerticalStackView.removeArrangedSubview(noseLabel)
        }
        else
        {
            searchFilterVerticalStackView.addArrangedSubview(noseLabel)
        }
        
        if !choosenFaceParts.contains(.mouth)
        {
            searchFilterVerticalStackView.removeArrangedSubview(mouthLabel)
        }
        else
        {
            searchFilterVerticalStackView.addArrangedSubview(mouthLabel)
        }
    }
}

