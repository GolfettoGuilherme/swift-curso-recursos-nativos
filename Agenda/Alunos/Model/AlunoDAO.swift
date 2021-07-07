//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 24/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import CoreData
//essa classe lida somente com o Core Data
class AlunoDAO: NSObject {
    
    var gerenciadorDeResultado: NSFetchedResultsController<Aluno>?
    
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func recuperaAlunos() -> Array<Aluno>{
        
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultado = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
                
        do{
            try gerenciadorDeResultado?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listaAluno = gerenciadorDeResultado?.fetchedObjects else { return [] }
        
        return listaAluno
        
    }
    
    
    func salvaAluno(dicionarioDealuno: Dictionary<String, Any>) {
        
        var aluno:NSManagedObject?
        
        guard let id = UUID(uuidString: dicionarioDealuno["id"] as! String) else { return }
        
        let alunos = recuperaAlunos().filter() { $0.id == id }
        
        if alunos.count > 0 {
            
            guard let alunoEncontrado = alunos.first else { return  }
            aluno = alunoEncontrado
            
        } else{
            
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto)
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto)
            
        }
        
        
        aluno?.setValue(id, forKey: "id")
        aluno?.setValue(dicionarioDealuno["nome"] as? String, forKey: "nome")
        aluno?.setValue(dicionarioDealuno["endereco"] as? String, forKey: "endereco")
        aluno?.setValue(dicionarioDealuno["telefone"] as? String, forKey: "telefone")
        aluno?.setValue(dicionarioDealuno["site"] as? String, forKey: "site")
        
        guard let nota = dicionarioDealuno["nota"] else { return  }
        
        if nota is String {
            
            aluno?.setValue((dicionarioDealuno["nota"]! as! NSString).doubleValue, forKey: "nota")
            
        } else{
            
            let conversaoDeNota = String(describing: nota)
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota")
            
        }
        
        
        atualizContexto()

    }
    
    func deletaAluno(aluno: Aluno){
        
        contexto.delete(aluno)
        
        atualizContexto()
    }
    
    func atualizContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}
