//
//  ViewController.swift
//  SozlukUygulamasi
//
//  Created by İlker Kaya on 30.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    @IBOutlet weak var kelimeTableView: UITableView!
    
    var kelimeListesi = [Kelimeler]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        veritabaniKopyala()
        
        
        kelimeTableView.delegate = self
        kelimeTableView.dataSource = self
        
        searchbar.delegate = self
        
        kelimeListesi = Kelimelerdao().tumKisilerAl()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        let gidilecekVC = segue.destination as! KelimeDetayViewController
        
        gidilecekVC.kelime = kelimeListesi[indeks!]
    }
    
    func veritabaniKopyala(){
        let bundleYolu = Bundle.main.path(forResource: "sozluk", ofType: ".sqlite")
        
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
        
        let fileManager = FileManager.default
        
        let kopyanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        if fileManager.fileExists(atPath: kopyanacakYer.path){
            print("Veritabanı zaten var kopyalamaya gerek yok")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyanacakYer.path)
            }catch{
                print(error)
            }
        }
        
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelimeHucre", for: indexPath) as! KelimeTableViewCell
        
        cell.ingilizcelabel.text = kelime.ingilizce
        cell.turkcelabel.text = kelime.turkce
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toKelimeDetay", sender: indexPath.row)
        
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama Sonucu : \(searchText)")
        
        kelimeListesi = Kelimelerdao().aramaYap(ingilizce: searchText)
        
        kelimeTableView.reloadData()
    }
}

