//
//  MapaViewController.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 07/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var mapa: MKMapView!
    
    //MARK: - Variaveis
    var aluno: Aluno?
    lazy var localizacao = Localizacao()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = getTitulo()
        self.localizacaoInicial()
        self.localizarAluno()
        mapa.delegate = localizacao
    }
    
    //MARK: - metodos

    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
        Localizacao().convertEnderecoEmCoordenadas(endereco: "Rua Vergueiro, 3185 - Vila Mariana, São Paulo ") { (localizacaoEncontrada) in
            
            let pino = Localizacao().configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada, cor: .black, icone: UIImage(named: "icon_caelum"))
            
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            
            self.mapa.setRegion(regiao, animated: true)
            print(pino)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func localizarAluno() {
        if let aluno = aluno {
            Localizacao().convertEnderecoEmCoordenadas(endereco: aluno.endereco!) { localizacaoEncontrada in
                
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                
                self.mapa.addAnnotation(pino)
            }
        }
        
    }

   
    

}
