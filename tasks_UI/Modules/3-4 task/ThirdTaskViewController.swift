//
//  ThirdTaskViewController.swift
//  tasks_UI
//
//  Created by Nihad on 4/17/21.
//

import UIKit
import QuickTableViewController

//============================================================================
class ThirdTaskViewController: QuickTableViewController
{
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
        title = "3-4 Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .blue
    }

    //----------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool)
    {
    }

    //----------------------------------------------------------------------------
    func setTableContents()
    {
        tableContents = [
            Section(title: "Method Examples", rows: [
                TapActionRow(text: "Histogram", action: { [weak self] _ in self?.navigationController?.pushViewController(HistViewController(), animated: true) }),
                TapActionRow(text: "DFT", action: { [weak self] _ in self?.navigationController?.pushViewController(DftViewController(), animated: true) }),
                TapActionRow(text: "DCT", action: { [weak self] _ in self?.navigationController?.pushViewController(DctViewController(), animated: true) }),
                TapActionRow(text: "Scale", action: { [weak self] _ in self?.navigationController?.pushViewController(ScaleViewController(), animated: true) }),
                TapActionRow(text: "Gradient", action: { [weak self] _ in self?.navigationController?.pushViewController(GradientViewController(), animated: true) }),
            ]),
            Section(title: "Parameter Selection", rows: [
                TapActionRow(text: "Histogram", action: { [weak self] _ in self?.navigationController?.pushViewController(HistParameterSelectionViewController(), animated: true) }),
                TapActionRow(text: "DFT", action: { [weak self] _ in self?.navigationController?.pushViewController(DftParameterSelectionViewController(), animated: true) }),
                TapActionRow(text: "DCT", action: { [weak self] _ in self?.navigationController?.pushViewController(DctParameterSelectionViewController(), animated: true) }),
                TapActionRow(text: "Scale", action: { [weak self] _ in self?.navigationController?.pushViewController(ScaleParameterSelectionViewController(), animated: true) }),
                TapActionRow(text: "Gradient", action: { [weak self] _ in self?.navigationController?.pushViewController(GradientParameterSelectionViewController(), animated: true) }),
            ]),
            Section(title: "Parallel System", rows: [
                TapActionRow(text: "Parallel System", action: { [weak self] _ in self?.navigationController?.pushViewController(ParallelSystemViewController(), animated: true) }),
            ]),
        ]
    }
}
