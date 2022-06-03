//
//  MapaViewController.swift
//  FireBase
//
//  Created by mac16 on 30/05/22.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapaMV: MKMapView!
    
    //Variables
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    
    var altitud: Double?
    
    // Manager para usar GPS
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manager.delegate = self
        mapaMV.delegate = self
        mapaMV.mapType = .hybrid
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        //Mejorar la presicion de la ubicacion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Monitorear en todo momento la ubicacion
        manager.startUpdatingLocation()
        //localizar()
    }
    
    @IBAction func localizarBtn(_ sender: Any) {
        let overlays = mapaMV.overlays
        mapaMV.removeOverlays(overlays)
        mapaMV.removeAnnotations(mapaMV.annotations)
        let alerta = UIAlertController(title: "Ubicacion", message: "Latitud: \(latitud ?? 0.0), Longitud: \(longitud ?? 0.0), Altitud: \(altitud ?? 0.0)", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default)
        
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
        
        //Hacer zoom al mapa a la ubicacion del usuario
        let locaclizacion = CLLocationCoordinate2D(latitude: latitud ?? 0, longitude: longitud ?? 0)
        let spanMapa = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: locaclizacion, span: spanMapa)
        
        mapaMV.setRegion(region, animated: true)
        mapaMV.showsUserLocation = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("5515 Melrose Ave, Los Angeles, CA 90038, Estados Unidos") { (places: [CLPlacemark]?, error: Error?) in
            guard let destinoRuta = places?.first?.location else { return }
            let lugar = places?.first
            let anotacion = MKPointAnnotation()
            anotacion.coordinate = (lugar?.location?.coordinate)!
            anotacion.title = "Hollywood Hills"
            
            //Crear span, nivel de zoom al mapa
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
            
            //Agregar anotacion al mapa
            self.mapaMV.setRegion(region, animated: true)
            self.mapaMV.addAnnotation(anotacion)
            
            self.trazarRuta(coordenadasDestino: destinoRuta.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .blue
        return renderizado
    }
    
    func trazarRuta(coordenadasDestino: CLLocationCoordinate2D){
        
        guard let coordOrigen = manager.location?.coordinate else { return }
        
        //Origen destino
        let origenPlaceMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenadasDestino)
        
        //Objeto tipo mapkititem
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        //Solicitar ruta
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        
        //Còmo se va a viajar
        solicitudDestino.transportType = .automobile
        
        //calcular nuevas rutas
        solicitudDestino.requestsAlternateRoutes = true
        
        let direcciones = MKDirections(request: solicitudDestino)
        direcciones.calculate { (respuesta, error) in
            //Respuesta segura
            guard let respuestaSegura = respuesta else {
                if let error = error {
                    print("Error al calcular la ruta \(error.localizedDescription)")
                    let alerta = UIAlertController(title: "Error", message: "Error al trazar la ruta", preferredStyle: .alert)
                    let accionAceptar = UIAlertAction(title: "OK", style: .default)
                    
                    alerta.addAction(accionAceptar)
                    self.present(alerta, animated: true)
                }
                return
            }
            if let ruta = respuestaSegura.routes.first {
                self.mapaMV.addOverlay(ruta.polyline)
                self.mapaMV.setVisibleMapRect((ruta.polyline.boundingMapRect), animated: true)
            }
        }
    }

}

extension MapaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Numero de ubicaciones \(locations.count)")
        
        //Crear Ubicacion
        guard let ubicacion = locations.first else {
            return
        }
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        altitud = ubicacion.altitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener ubicacion")
        let alerta = UIAlertController(title: "Error", message: "Error al obtener la ubicacion", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default)
        
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    
}
