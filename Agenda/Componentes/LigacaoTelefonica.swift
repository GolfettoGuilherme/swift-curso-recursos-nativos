//
//  LigacaoTelefonica.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 06/07/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class LigacaoTelefonica: NSObject {
    
    func fazLigacao(_ alunoSelecionado:Aluno) {
        guard let numeroAluno = alunoSelecionado.telefone else { return }

        if let url = URL(string: "tel://\(numeroAluno)"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
