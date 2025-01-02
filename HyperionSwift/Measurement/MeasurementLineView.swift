//
//  MeasurementLineView.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import Foundation
import UIKit

class MeasurementsView: UIView {
    private let styleManager = StyleManager()
    private lazy var measurementLabelFactory = MeasurementElementsFactory(styleManager: styleManager)
    private lazy var measurementManager = MeasurementManager(
        _extension: _extension,
        measurementFactory: measurementLabelFactory,
        styleManager: styleManager
    )

    private var _extension: PluginExtension?

    private var selectedView: UIView?
    private var compareView: UIView?

    required init(_extension: PluginExtension?) {
        super.init(frame: .zero)
        self._extension = _extension
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupGestures()
        measurementManager.setup()
    }

    public func viewSelected(_ selection: UIView) {
        handleViewSelection(selection)
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc private func tapGesture(_ tapGesture: UITapGestureRecognizer) {
        guard let mainWindow = _extension?.attachedWindow else { return }

        let point = tapGesture.location(in: self)
        let selectedViews = ViewHelper.findSubviews(in: mainWindow, intersectingPoint: point)

        handleViewSelection(selectedViews.first)
    }

    private func handleViewSelection(_ selection: UIView?) {
        if selection == compareView {
            compareView = nil
            measurementManager.clearCompareStyling()
        } else if selectedView == nil {
            selectedView = selection
            measurementManager.clearSelectedStyling()
            measurementManager.addBorder(in: self, forSelected: selectedView)
        } else if selection == selectedView {
            selectedView = nil
            compareView = nil
            measurementManager.clearCompareStyling()
            measurementManager.clearSelectedStyling()
        } else {
            compareView = selection
            measurementManager.clearCompareStyling()
            measurementManager.addBorder(in: self, forCompare: compareView)
        }

        displayMeasurementViews(for: selectedView, comparedTo: compareView ?? selectedView?.superview)
    }

    func interactionViewWillTransition(to _: CGSize, with _: UIViewControllerTransitionCoordinator) {
        measurementManager.clearAllStyling()
    }

    func interactionViewDidTransition(to _: CGSize) {
        if let selectedView = selectedView {
            measurementManager.addBorder(in: self, forSelected: selectedView)
            if compareView != nil {
                measurementManager.addBorder(in: self, forCompare: compareView)
            }
            displayMeasurementViews(for: selectedView, comparedTo: compareView ?? selectedView.superview)
        }
    }

    private func displayMeasurementViews(for selectedView: UIView?, comparedTo compareView: UIView?) {
        measurementManager.clearMeasurementViews()

        guard let selectedView = selectedView else { return }

        let globalSelectedRect = selectedView.superview?.convert(selectedView.frame, to: _extension?.attachedWindow)
        let globalComparisonViewRect = compareView?.superview?.convert(compareView?.frame ?? CGRect.zero, to: _extension?.attachedWindow)

        let viewsToMeasure: (UIView, UIView)
        if measurementManager.frame(globalSelectedRect, insideFrame: globalComparisonViewRect) {
            viewsToMeasure = (selectedView, compareView ?? selectedView)
        } else {
            viewsToMeasure = (compareView ?? selectedView, selectedView)
        }

        placeMeasurements(for: viewsToMeasure)
    }

    private func placeMeasurements(for views: (UIView, UIView)) {
        let (view1, view2) = views

        measurementManager.placeTopMeasurementBetweenSelectedView(view1, comparisonView: view2)
        measurementManager.placeBottomMeasurementBetweenSelectedView(view1, comparisonView: view2)
        measurementManager.placeLeftMeasurementBetweenSelectedView(view1, comparisonView: view2)
        measurementManager.placeRightMeasurementBetweenSelectedView(view1, comparisonView: view2)
    }
}
