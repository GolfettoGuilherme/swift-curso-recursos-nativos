//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit



class HomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
        
    var alunoViewController : AlunoViewController?

    var alunos:Array<Aluno> = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperaAlunos()
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    func recuperaAlunos() {
        Repositorio().recuperaAlunos { listaAlunos in
            self.alunos = listaAlunos
            self.tableView.reloadData()
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    
    @objc
    func abrirActionSheet(_longpress: UILongPressGestureRecognizer){
        if _longpress.state == .began{
            
            let alunoSelecionado = alunos[(_longpress.view?.tag)!]
            
            guard let navigation = navigationController else { return  }
            
            let menu = MenuOpcoesAlunos().configuraMenuOpcoesDoAluno(navigation: navigation, alunoSelecionado: alunoSelecionado)
            
            present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_longpress:)))
                
        let aluno = alunos[indexPath.row]
        
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
                        
                        let alunoSelecionado = self.alunos[indexPath.row]
                        
                        Repositorio().deletaAluno(aluno: alunoSelecionado)
                        
                        self.alunos.remove(at: indexPath.row)
                        
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        
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
        let alunoSelecionado = alunos[indexPath.row]
        
        alunoViewController?.aluno = alunoSelecionado
    }

    
    //MARK: - FetchedResultControllerDelegate
    
    
    
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        
        CalculaMediaApi().calculaMediaGeralDosAlunos(alunos: alunos) { dicionario in
            
            if let alerta = Notificacoes().exibeNotificaoDeMediaDosAlunos(dicionario: dicionario) {
                self.present(alerta, animated: true, completion: nil)
            }
        } falha: { error in
            print(error.localizedDescription)
        }

    }
    
    
    //MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let texto = searchBar.text {
            alunos = Filtro().filtraAlunos(listaDeAlunos: alunos, texto: texto)
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        alunos = AlunoDAO().recuperaAlunos()
        tableView.reloadData()
        
    }

    

}
