//
//  Localizacao.swift
//  Agenda
//
//  Created by Guilherme Golfetto on 07/06/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {
    
    func localizAlunoNoWaze(_ alunoSelecionado: Aluno) {
        
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
            guard let enderecoDoluno = alunoSelecionado.endereco else { return  }

            Localizacao().convertEnderecoEmCoordenadas(endereco: enderecoDoluno) { localizacaoEncontrada in

                let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)

                let url: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"

                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func convertEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local: CLPlacemark) -> Void){
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { listaDeLocalizacoes, erro in
            if let localizacao = listaDeLocalizacoes?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino {
        
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        
        pino.title = titulo
        pino.color = cor
        pino.icon = icone
        
        return pino
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is Pino {
            let annotationView = annotation as! Pino
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title)
            
            pinoView?.annotation = annotationView
            pinoView?.glyphImage = annotationView.icon
            pinoView?.markerTintColor = annotationView.color
            
            return pinoView
            
        }
        return nil
    }

}
