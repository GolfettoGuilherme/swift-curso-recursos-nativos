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
