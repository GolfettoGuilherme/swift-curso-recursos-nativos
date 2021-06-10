//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorDeResultado: NSFetchedResultsController<Aluno>?
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var alunoViewController : AlunoViewController?
    var mensagem = Mensagem()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno(filtro:String = ""){
        
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        if verificaFiltro(filtro) {
            pesquisaAluno.predicate = filtraAluno(filtro)
        }
        
        gerenciadorDeResultado = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        gerenciadorDeResultado?.delegate = self
        
        do{
            try gerenciadorDeResultado?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func filtraAluno(_ filtro: String) -> NSPredicate {
        return NSPredicate(format: "nome CONTAINS %@", filtro)
    }
    
    func verificaFiltro(_ filtro: String) -> Bool {
        if filtro.isEmpty {
            return false
        }
        return true
    }
    
    @objc
    func abrirActionSheet(_longpress: UILongPressGestureRecognizer){
        if _longpress.state == .began{
            
            guard let alunoSelecionado = gerenciadorDeResultado?.fetchedObjects?[(_longpress.view?.tag)!] else { return }
            
            let menu = MenuOpcoesAlunos().configuraMenuOpcoesDoAluno (completion: { opcao in
                
                switch opcao{
                case .sms:
                    
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                    
                case .ligacao:
                    guard let numeroAluno = alunoSelecionado.telefone else { return }
                    
                    if let url = URL(string: "tel://\(numeroAluno)"), UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    break
                case .waze:
                    
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
                        guard let enderecoDoluno = alunoSelecionado.endereco else { return  }
                        
                        Localizacao().convertEnderecoEmCoordenadas(endereco: enderecoDoluno) { localizacaoEncontrada in
                            
                            let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            
                            let url: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        }
                    }
                    
                    break
                case .mapa:
                    
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                
                    break
                }
                
                
                
                
            })
            self.present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorDalistaDeAlunos = gerenciadorDeResultado?.fetchedObjects?.count else{ return 0 }
        return contadorDalistaDeAlunos
        
        //pela definição moderna de Alcoolismo
        //você ja está um Alcoolatra Guilherme
        // ¯\_(ツ)_/¯
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_longpress:)))
        
        guard let aluno = self.gerenciadorDeResultado?.fetchedObjects![indexPath.row] else { return cell }
        
        cell.configuraCelula(aluno)
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            AutenticacaoLocal().autorizaUsuario { autenticado in
                
                if autenticado {
                    
                    //precisa estar na thread principal
                    DispatchQueue.main.async {
                        guard let alunoSelecionado = self.gerenciadorDeResultado?.fetchedObjects?[indexPath.row] else { return }
                        
                        self.contexto.delete(alunoSelecionado)
                        
                        do{
                            try self.contexto.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    //metodo chamado quando o usuario clicou em um elemento da lista (ja tem um segue para isso no storyboard)
    //vai servir para quando o usuario clicar num elemento da lista e carregar a tela de Edição de aluno
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = self.gerenciadorDeResultado?.fetchedObjects![indexPath.row] else { return }
        
        alunoViewController?.aluno = alunoSelecionado
    }

    
    //MARK: - FetchedResultControllerDelegate
    
    //usado para avisar pra tabelview que teve alteraçao na listagem de alunos
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .delete:
                guard let indexPath = indexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .fade)
                break
            default:
                tableView.reloadData()
            }
    }
    
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        
        guard let listaAluno = gerenciadorDeResultado?.fetchedObjects else { return  }
        
        CalculaMediaApi().calculaMediaGeralDosAlunos(alunos: listaAluno) { dicionario in
            
            if let alerta = Notificacoes().exibeNotificaoDeMediaDosAlunos(dicionario: dicionario) {
                self.present(alerta, animated: true, completion: nil)
            }
        } falha: { error in
            print(error.localizedDescription)
        }

    }
    
    
    //MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nomeDoAluno = searchBar.text else { return }
        
        recuperaAluno(filtro: nomeDoAluno)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recuperaAluno()
        tableView.reloadData()
    }

    

}
