//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 04/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAluno {
    case sms
    case ligacao
    case waze
    case mapa
}

class MenuOpcoesAlunos: NSObject {
    
    func configuraMenuOpcoesDoAluno(completion: @escaping(_ opcao: MenuActionSheetAluno) -> Void) -> UIAlertController {
        
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { acao in
            completion(.sms)
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { acao in
            completion(.ligacao)
        }
        
        let waze = UIAlertAction(title: "Abrir no Waze", style: .default) { acao in
            completion(.waze)
        }
        
        let mapa = UIAlertAction(title: "Mostrar no Mapa", style: .default) { acao in
            completion(.mapa)
        }
        
        menu.addAction(sms)
        menu.addAction(ligacao)
        menu.addAction(waze)
        menu.addAction(mapa)
        menu.addAction(cancelar)
        
        
        return menu
    }

}
