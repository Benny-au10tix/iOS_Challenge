//
//  DogeViewController.swift
//  Candidate App
//
//  Created by Assaf Halfon on 30/05/2021.
//

import UIKit

class DogeViewController: UIViewController {
    
    struct ViewModel {
        let cmcDataFetcher = CMCDataFetcher()
        let imageDownloader = ImageDownloader()
        
        var dogeImageUrl: String {
            "http://static.coindesk.com/wp-content/uploads/2021/04/dogecoin-710x458.jpg"
        }
        var imageData: Data?
        var cmcResponse: CMCResponse?
        var quote: CMCResponse.Quote? {
            cmcResponse?.data.first?.value.quote.first?.value
        }
        
        var priceString: String? {
            guard let price = self.quote?.price else {
                return nil
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            
            return formatter.string(from: price as NSNumber)
        }
        
        var change: Double? {
            self.quote?.percent_change_24h
        }
    
    }
    
    // MARK: - Properties
    
    private var vm = ViewModel()
    
    private var changeLabel: UILabel!
    private var priceLabel: UILabel!
    private weak var imageView: UIImageView!
    
    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dogecoin to the Moon 🚀"
        
        fetchData()
    }
    
    //MARK: - UI Builder
    
    private func buildUI() {
        self.view.backgroundColor = .white
        self.buildQuoteUI()
        self.buildImageView()
    }
    
    private func buildQuoteUI() {
        let priceLabel = UILabel(frame: .zero)
        priceLabel.font = .systemFont(ofSize: 80)
        priceLabel.textColor = .black
        
        let changeLabel = UILabel(frame: .zero)
        changeLabel.font = .systemFont(ofSize: 24)
        changeLabel.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [priceLabel,changeLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        
        self.view.addSubview(stackView)
        [
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
        ].forEach { $0.isActive = true }
            
        self.priceLabel = priceLabel
        self.changeLabel = changeLabel
    }
    
    private func buildImageView() {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        [
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ].forEach{ $0.isActive = true }
        
        self.imageView = imageView
    }
    
    //MARK: -
    
    private func refreshUI() {
        guard let priceString = vm.priceString,
              let change = self.vm.change else {
            return
        }
        
        priceLabel.text = "DOGE to USD is:" + priceString
        changeLabel.text = String(format: "%.2f %%", change)
        if change > 0 {
            changeLabel.textColor = .green
        } else if change < 0 {
            changeLabel.textColor = .red
        } else {
            changeLabel.textColor = .black
        }
        
        imageView.image = UIImage(data: vm.imageData!)
    }
    
    private func fetchData() {
        vm.cmcDataFetcher.fetchQuote(for: .dogeCoin) { result in
            switch result {
            case .failure(let error):
                self.handle(error: error)
            case .success(let cmcResponse):
                self.vm.cmcResponse = cmcResponse
                self.refreshUI()
            }
        }
        
        vm.imageDownloader.download(from: vm.dogeImageUrl) { result in
            switch result {
            case .failure(let error):
                self.handle(error: error)
            case .success(let data):
                self.vm.imageData = data
            }
        }
    }

    private func handle(error: Error) {
        let alert = UIAlertController(title: "Operation failed", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
