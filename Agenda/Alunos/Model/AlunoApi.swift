//
//  AlunoApi.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 23/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import Alamofire


//Essa classe lida somente com a API
class AlunoApi: NSObject {
    
    
    //MARK: - GET
    func recuperaAlunos(completion: @escaping () -> Void) {
        
        guard let url = Configuracao().buscarUrl() else { return }
        
        AF.request(url + "api/aluno", method: .get).responseJSON{ response in
            
            switch response.result {
            
            case .success(let data):
                
                if let resposta = data as? Dictionary<String, Any> {
                    
                    guard let listaAlunos = resposta["alunos"] as? Array<Dictionary<String,Any>> else { return }
                    
                    for aluno in listaAlunos {
                        AlunoDAO().salvaAluno(dicionarioDealuno: aluno)
                    }
                    
                    completion()
                        
                }
                
            break
                
            case.failure(let error):
                
                print(error)
                
                completion()
                
                break
            }
            
        }
    }

    
    
    //MARK: - PUT

    func salvaAlunosNoServidor(parametros:  Array<Dictionary<String, String>>) {
        guard let urlPadrao = Configuracao().buscarUrl() else { return }
        
        guard let url = URL(string: urlPadrao + "api/aluno/lista") else { return }
        //AF.request(url, method: .put, parameters:parametros)
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        
        requisicao.httpBody = json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(requisicao).response{ response in
            print(response)
        }

    }

    
    //MARK: - DELETE
    
    func deletaAluno(id:String) {
        guard let url = Configuracao().buscarUrl() else { return }
        
        AF.request(url + "api/aluno/\(id)", method: .delete).responseJSON { resposta in
            switch resposta.result {
            case .failure(let error):
                print(error)
                break
            default:
                break
            }
        }
    }

}
