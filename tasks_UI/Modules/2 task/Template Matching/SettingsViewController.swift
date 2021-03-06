//
//  SettingsViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/17/21.
//

import UIKit
import QuickTableViewController

//============================================================================
enum FacePart: String
{
    case face
    case upperFace
    case eyes
    case nose
    case mouth
}

//============================================================================
protocol SettingsViewControllerDelegate: class
{
    func SettingsViewControllerDidFinish(_ choosenFaceParts: Set<FacePart>)
}

//============================================================================
class SettingsViewController: QuickTableViewController
{
    weak var delegate: SettingsViewControllerDelegate?

    //----------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        style()
        setTableContents()
    }

    //----------------------------------------------------------------------------
    func style()
    {
        view.backgroundColor = .blue
    }

    //----------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool)
    {
        delegate?.SettingsViewControllerDidFinish(choosenFaceParts)
    }

    //----------------------------------------------------------------------------
    func setTableContents()
    {
        tableContents = [
          Section(title: "Choose face part", rows: [
            SwitchRow(text: "Face", switchValue: choosenFaceParts.contains(.face), action: onSwitchTap(.face)),
            SwitchRow(text: "Upper face", switchValue: choosenFaceParts.contains(.upperFace), action: onSwitchTap(.upperFace)),
            SwitchRow(text: "Eyes", switchValue: choosenFaceParts.contains(.eyes), action: onSwitchTap(.eyes)),
            SwitchRow(text: "Nose", switchValue: choosenFaceParts.contains(.nose), action: onSwitchTap(.nose)),
            SwitchRow(text: "Mouth", switchValue: choosenFaceParts.contains(.mouth), action: onSwitchTap(.mouth)),
          ])
        ]
    }

    //----------------------------------------------------------------------------
    private func onSwitchTap(_ facePart: FacePart) -> (Row) -> Void {
      {
        row in

        let row = row as! SwitchRow

        if row.switchValue
        {
            choosenFaceParts.insert(facePart)
        }
        else
        {
            choosenFaceParts.remove(facePart)
        }
      }
    }
}
