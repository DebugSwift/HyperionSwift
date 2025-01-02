//
//  MeasurementLineView.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import Foundation
import UIKit

class MeasurementsInteractionView: UIView {
    
    var measurementViews: [UIView] = []
    var selectedView: UIView?
    var compareView: UIView?
    var selectedViewsStyling: [CAShapeLayer] = []
    var compareViewStyling: [CAShapeLayer] = []
    var primaryColor: UIColor = UIColor(red: 43.0/255.0, green: 87.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    var secondaryColor: UIColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    var _extension: PluginExtension?
    
    var _superview: HYPSnapshotInteractionView? {
        superview as? HYPSnapshotInteractionView
    }

    required init(_extension: PluginExtension?) {
        super.init(frame: .zero)
        self._extension = _extension
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))

        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true

        self.measurementViews = []
        self.compareViewStyling = []
        self.selectedViewsStyling = []
    }

    @objc private func tapGesture(_ tapGesture: UITapGestureRecognizer) {
        guard let mainWindow = self._extension?.attachedWindow else { return }

        let point = tapGesture.location(in: self)
        let selectedViews = PluginHelper.findSubviews(in: mainWindow, intersectingPoint: point)

        if selectedViews.first == selectedView {
            selectedView = nil
            compareView = nil
            clearCompareStyling()
            clearSelectedStyling()
            clearMeasurementViews()
            return
        } else if selectedViews.first == compareView {
            compareView = nil
            clearCompareStyling()
        } else if selectedView == nil {
            selectedView = selectedViews.first
            clearSelectedStyling()
            addBorderForSelectedView()
        } else {
            compareView = selectedViews.first
            clearCompareStyling()
            addBorderForCompareView()
        }

        displayMeasurementViews(for: selectedView, comparedTo: compareView ?? selectedView?.superview)
    }

    func viewSelected(_ selection: UIView) {
        if selection == compareView {
            compareView = nil
            clearCompareStyling()
        } else if selectedView == nil {
            selectedView = selection
            clearSelectedStyling()
            addBorderForSelectedView()
        } else if selection == selectedView {
            selectedView = nil
            compareView = nil
            clearCompareStyling()
            clearSelectedStyling()
        } else {
            compareView = selection
            clearCompareStyling()
            addBorderForCompareView()
        }

        displayMeasurementViews(for: selectedView, comparedTo: compareView ?? selectedView?.superview)
    }

    func interactionViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        _superview?.interactionViewWillTransition(to: size, with: coordinator)
        clearAllStyling()
    }

    func interactionViewDidTransition(to size: CGSize) {
        _superview?.interactionViewDidTransition(to: size)
        if let selectedView = selectedView {
            addBorderForSelectedView()
            if let compareView = compareView {
                addBorderForCompareView()
            }
            displayMeasurementViews(for: selectedView, comparedTo: compareView ?? selectedView.superview)
        }
    }

    private func displayMeasurementViews(for selectedView: UIView?, comparedTo compareView: UIView?) {
        clearMeasurementViews()

        guard let selectedView = selectedView else { return }
        let globalSelectedRect = selectedView.superview?.convert(selectedView.frame, to: self._extension?.attachedWindow)
        let globalComparisonViewRect = compareView?.superview?.convert(compareView?.frame ?? CGRect.zero, to: self._extension?.attachedWindow)

        if frame(globalSelectedRect, insideFrame: globalComparisonViewRect), let compareView {
            placeTopMeasurementBetweenSelectedView(selectedView, comparisonView: compareView)
            placeBottomMeasurementBetweenSelectedView(selectedView, comparisonView: compareView)
            placeLeftMeasurementBetweenSelectedView(selectedView, comparisonView: compareView)
            placeRightMeasurementBetweenSelectedView(selectedView, comparisonView: compareView)
        } else {
            placeTopMeasurementBetweenSelectedView(compareView ?? selectedView, comparisonView: selectedView)
            placeBottomMeasurementBetweenSelectedView(compareView ?? selectedView, comparisonView: selectedView)
            placeLeftMeasurementBetweenSelectedView(compareView ?? selectedView, comparisonView: selectedView)
            placeRightMeasurementBetweenSelectedView(compareView ?? selectedView, comparisonView: selectedView)
        }
    }

    private func addBorderForSelectedView() {
        guard let selectedView = selectedView else { return }
        let globalSelectedRect = selectedView.superview?.convert(selectedView.frame, to: self._extension?.attachedWindow)

        let path = UIBezierPath(rect: globalSelectedRect ?? CGRect.zero)
        let shape = CAShapeLayer()
        shape.bounds = self.bounds
        shape.position = self.center
        shape.lineWidth = 3
        shape.borderColor = primaryColor.cgColor
        shape.strokeColor = primaryColor.cgColor
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shape)

        selectedViewsStyling.append(shape)
        selectedViewsStyling.append(contentsOf: getLines(for: selectedView))
    }

    private func addBorderForCompareView() {
        guard let compareView = compareView else { return }
        let globalSelectedRect = compareView.superview?.convert(compareView.frame, to: self._extension?.attachedWindow)

        let path = UIBezierPath(rect: globalSelectedRect ?? .zero)
        let shape = CAShapeLayer()
        shape.bounds = self.bounds
        shape.position = self.center
        shape.lineWidth = 1
        shape.borderColor = secondaryColor.cgColor
        shape.strokeColor = secondaryColor.cgColor
        shape.lineDashPattern = [2, 2]
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shape)

        compareViewStyling.append(shape)
    }

    private func getLines(for view: UIView) -> [CAShapeLayer] {
        guard let globalSelectedRect = view.superview?.convert(view.frame, to: self._extension?.attachedWindow) else { return [] }

        let left = UIBezierPath()
        left.move(to: CGPoint(x: globalSelectedRect.origin.x, y: 0))
        left.addLine(to: CGPoint(x: globalSelectedRect.origin.x, y: self.frame.size.height))

        let right = UIBezierPath()
        right.move(to: CGPoint(x: CGRectGetMaxX(globalSelectedRect), y: 0))
        right.addLine(to: CGPoint(x: CGRectGetMaxX(globalSelectedRect), y: self.frame.size.height))

        let top = UIBezierPath()
        top.move(to: CGPoint(x: 0, y: globalSelectedRect.origin.y))
        top.addLine(to: CGPoint(x: self.frame.size.height, y: globalSelectedRect.origin.y))

        let bottom = UIBezierPath()
        bottom.move(to: CGPoint(x: 0, y: CGRectGetMaxY(globalSelectedRect)))
        bottom.addLine(to: CGPoint(x: self.frame.size.height, y: CGRectGetMaxY(globalSelectedRect)))

        let shapes = [left, top, right, bottom].map { path -> CAShapeLayer in
            let shape = CAShapeLayer()
            shape.bounds = self.bounds
            shape.position = self.center
            shape.lineWidth = 1
            shape.borderColor = primaryColor.cgColor
            shape.strokeColor = primaryColor.cgColor
            shape.path = path.cgPath
            shape.fillColor = UIColor.clear.cgColor
            shape.lineDashPattern = [3, 8]
            self.layer.addSublayer(shape)
            return shape
        }

        return shapes
    }

    private func clearAllStyling() {
        clearMeasurementViews()
        clearSelectedStyling()
        clearCompareStyling()
    }

    private func clearMeasurementViews() {
        for view in measurementViews {
            view.removeFromSuperview()
        }
        measurementViews.removeAll()
    }

    private func clearSelectedStyling() {
        for shape in selectedViewsStyling {
            shape.removeFromSuperlayer()
        }
        selectedViewsStyling.removeAll()
    }

    private func clearCompareStyling() {
        for shape in compareViewStyling {
            shape.removeFromSuperlayer()
        }
        compareViewStyling.removeAll()
    }
    
    private func frame(_ rect1: CGRect?, insideFrame rect2: CGRect?) -> Bool {
        guard let rect1 = rect1, let rect2 = rect2 else { return false }
        return rect2.contains(rect1)
    }

    private func createMeasurementLabel(withText text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = primaryColor.cgColor
        containerView.layer.masksToBounds = true

        let label = UILabel()
        label.text = text
        label.textColor = primaryColor
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.sizeToFit()

        let horizontalPadding: CGFloat = 8
        let verticalPadding: CGFloat = 2

        let labelWidth = label.frame.width + horizontalPadding * 2
        let labelHeight = label.frame.height + verticalPadding * 2

        containerView.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)

        label.frame = CGRect(x: horizontalPadding, y: verticalPadding, width: label.frame.width, height: label.frame.height)
        containerView.addSubview(label)

        containerView.center = CGPoint(x: containerView.superview?.bounds.midX ?? 0, y: containerView.superview?.bounds.midY ?? 0)

        return containerView
    }

    func placeTopMeasurementBetweenSelectedView(_ selectedView: UIView, comparisonView: UIView) {
        let globalSelectedRect = selectedView.superview!.convert(selectedView.frame, to: self._extension?.attachedWindow)
        let globalComparisonViewRect = comparisonView.superview!.convert(comparisonView.frame, to: self._extension?.attachedWindow)

        let topSelectedView = CGPoint(x: globalSelectedRect.origin.x + globalSelectedRect.size.width / 2, y: globalSelectedRect.origin.y)

        if frame(globalSelectedRect, insideFrame: globalComparisonViewRect) {
            let topCompareView = CGPoint(x: globalSelectedRect.origin.x + globalSelectedRect.size.width / 2, y: globalComparisonViewRect.origin.y)

            let topMeasurementPath = measurementPath(startPoint: topSelectedView, endPoint: topCompareView)
            addShape(forPath: topMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(topCompareView.y - topSelectedView.y)), center: CGPoint(x: topCompareView.x, y: topSelectedView.y + (topCompareView.y - topSelectedView.y) / 2))
        } else if globalSelectedRect.origin.y >= globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height {
            let belowCompareView = CGPoint(x: topSelectedView.x, y: globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height)

            let topMeasurementPath = measurementPath(startPoint: topSelectedView, endPoint: belowCompareView)
            addShape(forPath: topMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(belowCompareView.y - topSelectedView.y)), center: CGPoint(x: belowCompareView.x, y: topSelectedView.y + (belowCompareView.y - topSelectedView.y) / 2))
        }
    }

    func placeBottomMeasurementBetweenSelectedView(_ selectedView: UIView, comparisonView: UIView) {
        let globalSelectedRect = selectedView.superview!.convert(selectedView.frame, to: self._extension?.attachedWindow)
        let globalComparisonViewRect = comparisonView.superview!.convert(comparisonView.frame, to: self._extension?.attachedWindow)

        let belowSelectedView = CGPoint(x: globalSelectedRect.origin.x + (globalSelectedRect.size.width / 2), y: globalSelectedRect.origin.y + globalSelectedRect.size.height)

        if frame(globalSelectedRect, insideFrame: globalComparisonViewRect) {
            let comparisonBottom = CGPoint(x: belowSelectedView.x, y: globalComparisonViewRect.origin.y + globalComparisonViewRect.size.height)

            let bottomMeasurementPath = measurementPath(startPoint: belowSelectedView, endPoint: comparisonBottom)
            addShape(forPath: bottomMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(belowSelectedView.y - comparisonBottom.y)), center: CGPoint(x: comparisonBottom.x, y: belowSelectedView.y + ((comparisonBottom.y - belowSelectedView.y) / 2)))
        } else if belowSelectedView.y <= globalComparisonViewRect.origin.y {
            let comparisonTop = CGPoint(x: belowSelectedView.x, y: globalComparisonViewRect.origin.y)
            let bottomMeasurementPath = measurementPath(startPoint: belowSelectedView, endPoint: comparisonTop)
            addShape(forPath: bottomMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(belowSelectedView.y - comparisonTop.y)), center: CGPoint(x: comparisonTop.x, y: belowSelectedView.y + ((comparisonTop.y - belowSelectedView.y) / 2)))
        }
    }

    func placeLeftMeasurementBetweenSelectedView(_ selectedView: UIView, comparisonView: UIView) {
        let globalSelectedRect = selectedView.superview!.convert(selectedView.frame, to: self._extension?.attachedWindow)
        let globalComparisonViewRect = comparisonView.superview!.convert(comparisonView.frame, to: self._extension?.attachedWindow)

        let leftSelectedView = CGPoint(x: globalSelectedRect.origin.x, y: globalSelectedRect.origin.y + globalSelectedRect.size.height / 2)

        if frame(globalSelectedRect, insideFrame: globalComparisonViewRect) {
            let leftCompareView = CGPoint(x: globalComparisonViewRect.origin.x, y: leftSelectedView.y)

            let leftMeasurementPath = measurementPath(startPoint: leftSelectedView, endPoint: leftCompareView)
            addShape(forPath: leftMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(leftSelectedView.x - leftCompareView.x)), center: CGPoint(x: leftCompareView.x + (leftSelectedView.x - leftCompareView.x) / 2, y: leftCompareView.y))
        } else if leftSelectedView.x >= globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width {
            let rightCompareView = CGPoint(x: globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, y: leftSelectedView.y)

            let leftMeasurementPath = measurementPath(startPoint: leftSelectedView, endPoint: rightCompareView)
            addShape(forPath: leftMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(leftSelectedView.x - rightCompareView.x)), center: CGPoint(x: rightCompareView.x + (leftSelectedView.x - rightCompareView.x) / 2, y: rightCompareView.y))
        }
    }

    func placeRightMeasurementBetweenSelectedView(_ selectedView: UIView, comparisonView: UIView) {
        let globalSelectedRect = selectedView.superview!.convert(selectedView.frame, to: self._extension?.attachedWindow)
        let globalComparisonViewRect = comparisonView.superview!.convert(comparisonView.frame, to: self._extension?.attachedWindow)

        let rightSelectedView = CGPoint(x: globalSelectedRect.origin.x + globalSelectedRect.size.width, y: globalSelectedRect.origin.y + globalSelectedRect.size.height / 2)

        if frame(globalSelectedRect, insideFrame: globalComparisonViewRect) {
            let leftCompareView = CGPoint(x: globalComparisonViewRect.origin.x + globalComparisonViewRect.size.width, y: rightSelectedView.y)

            let leftMeasurementPath = measurementPath(startPoint: rightSelectedView, endPoint: leftCompareView)
            addShape(forPath: leftMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(rightSelectedView.x - leftCompareView.x)), center: CGPoint(x: rightSelectedView.x + (leftCompareView.x - rightSelectedView.x) / 2, y: leftCompareView.y))
        } else if rightSelectedView.x <= globalComparisonViewRect.origin.x {
            let leftGlobalView = CGPoint(x: globalComparisonViewRect.origin.x, y: rightSelectedView.y)

            let leftMeasurementPath = measurementPath(startPoint: rightSelectedView, endPoint: leftGlobalView)
            addShape(forPath: leftMeasurementPath)

            addMeasureLabel(value: String(format: "%0.1fpt", abs(rightSelectedView.x - leftGlobalView.x)), center: CGPoint(x: rightSelectedView.x + (leftGlobalView.x - rightSelectedView.x) / 2, y: leftGlobalView.y))
        }
    }

    func addMeasureLabel(value: String, center: CGPoint) {
        let measurementsContainer = UIView()
        measurementsContainer.translatesAutoresizingMaskIntoConstraints = false
        measurementsContainer.addSubview(createMeasurementLabel(withText: value))

        measurementsContainer.center = center
        measurementViews.append(measurementsContainer)
        
        self._extension?.attachedWindow?.addSubview(measurementsContainer)
    }

    func addShape(forPath path: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = primaryColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        compareViewStyling.append(shapeLayer)
        self._extension?.attachedWindow?.layer.addSublayer(shapeLayer)
    }
    
    func measurementPath(startPoint start: CGPoint, endPoint end: CGPoint) -> UIBezierPath {
        let vertical = start.y != end.y
        let padding: CGFloat = 3

        if vertical {
            let startLessThanEnd = start.y < end.y

            var start = start
            var end = end

            start.y += padding * (startLessThanEnd ? 1 : -1)
            end.y += padding * (startLessThanEnd ? -1 : 1)

            let path = UIBezierPath()
            path.move(to: CGPoint(x: start.x - 5, y: start.y))
            path.addLine(to: CGPoint(x: start.x + 5, y: start.y))
            path.addLine(to: CGPoint(x: start.x, y: start.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            path.addLine(to: CGPoint(x: end.x - 5, y: end.y))
            path.addLine(to: CGPoint(x: end.x + 5, y: end.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            path.addLine(to: CGPoint(x: start.x, y: start.y))

            return path
        } else {
            let startLessThanEnd = start.x < end.x

            var start = start
            var end = end

            start.x += padding * (startLessThanEnd ? 1 : -1)
            end.x += padding * (startLessThanEnd ? -1 : 1)

            let path = UIBezierPath()
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x, y: start.y - 5))
            path.addLine(to: CGPoint(x: start.x, y: start.y + 5))
            path.addLine(to: CGPoint(x: start.x, y: start.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y - 5))
            path.addLine(to: CGPoint(x: end.x, y: end.y + 5))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            path.addLine(to: CGPoint(x: start.x, y: start.y))

            return path
        }
    }
}
