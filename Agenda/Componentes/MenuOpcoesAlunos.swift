//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 04/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit


class MenuOpcoesAlunos: NSObject {
    
    func configuraMenuOpcoesDoAluno(navigation: UINavigationController, alunoSelecionado: Aluno) -> UIAlertController {
        
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        
        guard let viewController = navigation.viewControllers.last else { return menu }
        
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { acao in
            Mensagem().enviaSMS(alunoSelecionado, controller: viewController)
        }
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { acao in
            LigacaoTelefonica().fazLigacao(alunoSelecionado)
        }
        
        let waze = UIAlertAction(title: "Abrir no Waze", style: .default) { acao in
            Localizacao().localizAlunoNoWaze(alunoSelecionado)
        }
        
        let mapa = UIAlertAction(title: "Mostrar no Mapa", style: .default) { acao in
            let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
            mapa.aluno = alunoSelecionado
            navigation.pushViewController(mapa, animated: true)
        }
        
        let abrirPaginaWeb = UIAlertAction(title: "Abrir pagina", style: .default) { acao in
            Safari().abrePaginaWeb(alunoSelecionado, controller: viewController)
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addAction(sms)
        menu.addAction(ligacao)
        menu.addAction(waze)
        menu.addAction(mapa)
        menu.addAction(abrirPaginaWeb)
        menu.addAction(cancelar)
        
        
        return menu
    }

}
