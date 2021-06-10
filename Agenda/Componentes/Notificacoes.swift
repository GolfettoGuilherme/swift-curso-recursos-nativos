//
//  Notificacoes.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 07/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificaoDeMediaDosAlunos(dicionario : Dictionary<String, Any>) -> UIAlertController? {
        if let media = dicionario["media"] as? String{
            let alerta = UIAlertController(title: "Atencao", message: "a media geral dos alunos é \(media)", preferredStyle: .alert)
            let botao = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(botao)
            
            return alerta
        }
        return nil
    }
    

}
