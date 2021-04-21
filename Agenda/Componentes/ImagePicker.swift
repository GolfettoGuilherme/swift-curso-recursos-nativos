//
//  ImagePicker.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 21/04/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionada {
    func imagepickerFotoSelecionada(_ foto: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Atributos
    
    
    var delegate: ImagePickerFotoSelecionada?
    
    
    //MARK: - Métodos

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        delegate?.imagepickerFotoSelecionada(foto)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //passando uma closure como parametro para quem chamar o metodo resolver o que fazer
    func menuDeOpcoes(completion: @escaping(_ opcao:MenuOpcoes) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Tirar Foto", style: .default) { (acao) in
            completion(MenuOpcoes.camera)
        }
        
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            completion(MenuOpcoes.biblioteca)
        }
        
            
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        menu.addAction(camera)
        menu.addAction(biblioteca)
        menu.addAction(cancelar)
        
        
        return menu
    }
}
