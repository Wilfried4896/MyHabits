//
//  ProgressBarCollectionCellCollectionViewCell.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 26.08.2022.
//

import UIKit

class ProgressBarCollectionViewCell: UICollectionViewCell {

    static let identifier = "ProgressBarCollectionCell"
    weak var delegateProgress: HabitsCollectionCellDelegate?
    
    private var progress: Float {
        HabitsStore.shared.todayProgress
    }
    
    var indexPath: IndexPath?
    
    private lazy var progressLabel: UILabel = {
        let progress = UILabel()
        progress.font = .systemFont(ofSize: 20, weight: .semibold)
        progress.textColor = .systemGray
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    private lazy var procenteLabel: UILabel = {
        let procente = UILabel()
        procente.font = .systemFont(ofSize: 20, weight: .semibold)
        procente.textColor = .systemGray
        procente.translatesAutoresizingMaskIntoConstraints = false
        return procente
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .systemPurple
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 5
        progressView.backgroundColor = .systemGray4
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configurationProgress()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurationProgress() {
        contentView.addSubview(procenteLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressView)

        NSLayoutConstraint.activate([

            //progressLabelConstraint
            progressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),

            //procenteLabelConstraint
            procenteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            procenteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            //progressViewConstraint
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            progressView.heightAnchor.constraint(equalToConstant: 7)
        ])
    }
    
    func progressViewSetProgress(_ progress: Float) {
        progressLabel.text = "Всё получится!"
        progressView.setProgress(progress, animated: true)
        procenteLabel.text = "\(Int(progress * 100)) %"
    }
    
    func updateProgress() {
        procenteLabel.text = "\(Int(progress * 100)) %"
        progressView.setProgress(progress, animated: true)
    }
}
