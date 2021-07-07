//
//  Configuracao.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 06/07/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Configuracao: NSObject {
    
    func buscarUrl() -> String {
        
        guard let caminhoPraPlist = Bundle.main.path(forResource: "Info", ofType: "plist") else { return "" }
        
        guard let dicionario = NSDictionary(contentsOfFile: caminhoPraPlist) else { return "" }
        
        guard let urlPadrao = dicionario["URLPadrao"] as? String else { return "" }
        
        return urlPadrao
    }

}
