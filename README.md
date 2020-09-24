elRacoMobile
===============
> el Racó de la FIB per iOS

Aplicació per a accedir als recursos de la Facultat d'Informàtica de Barcelona des dels dispositius iOS.

Aquesta aplicació és va desenvolupar originalment com un projecte final de carrera pel [Marcel Arbó Lack](http://es.linkedin.com/in/marcelarbo) en col·laboració amb l'inLab FIB. La memòria està disponible al portal [Treballs acadèmics UPC](http://hdl.handle.net/2099.1/13957) (UPCCommons) de la biblioteca de la UPC.

L'alumne [Alvaro Ariño Cabau](http://es.linkedin.com/in/alvaroarino) l'ha redissenyat per complet per adaptar-la al llenguatge de programació Swift d'Apple i donar-li una nova estètica.

La nova app fa ús de l'última versió de l'API del Racó.

Actualment es troba disponible a l'[App Store](https://apps.apple.com/us/app/elracomobile/id1500949835)

Caracterísitiques
----------------
- Consulta d'horari
- Consulta d'últims avisos publicats
- Consulta de l'calendari d'exàmens i festius
- Consulta de les últimes notícies de la FIB
- Consulta de les dades de les assignatures matriculades: guia docent, requisits, crèdits ...
- Reserva de sales a la BRGF - UPC
- Consulta de l'ocupació dels laboratoris d'informàtica
- Rep notificacions de nous avisos i novetats

Requeriments
-------------
- Xcode 11
- iOS 12.2+
- Swift 5+

Llibreries open-source usades
------------------------------

### Obtenció y decodificació de les dades
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Alamofire-SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON)

### Obtenció y administració de les noticies
- [FeedKit](https://github.com/nmdias/FeedKit)
- [SwiftSoup](https://github.com/scinfu/SwiftSoup)

### Disseny
- [SWRevealViewController](https://github.com/John-Lluch/SWRevealViewController)

### Horari
- [SpreadsheetView](https://github.com/kishikawakatsumi/SpreadsheetView)

### Capaciatats de iOS
- [SwiftKeychainWrapper](https://github.com/jrendel/SwiftKeychainWrapper)
- [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift)

### [Firebase](https://firebase.google.com) (medició d'audiencia y rendimient de l'app)
- Analytics
- Crashlytics
- Performance
- Messaging

## Intruccions de compilació

Per poder fer ús de l'app és necessari inicialitzar les estructures de Cocoapods
1. Instal·la Cocoapods [si no el tens)
~~~
suo gem install cocoapods
~~~
2. Clona el repositori
~~~
git clone https://github.com/alvaroarino/RacoMobile-iOS.git
~~~
3. Instal·la les dependències de Cocopaods
~~~
pod install
~~~
3. Obre `RacoMobile.xcworkspace` i selecciona `RacoMobile` al navegador de projecte. En l'apartat `Signing & Capabilities`, canvia l'equip pel teu propi.
4. Firebase:
i. Per poder fer ús de les mètriques de Firebase cal registrar a la seva pàgina web, crear una aplicació i descarregar l'arxiu GoogleService-Info.plist.
ii. Si no vas a fer ús d'aquesta funció és necessari que esborris de l'AppDelegate.swift la següent línia:
~~~
FirebaseApp.configure ()
~~~

7. Build + run app! 🎉

Llicència de les depencies
--------------------------
Cada dependència usada en aquest projecte té la seva pròpia llicència d'ús. Per màs infomació veure les respectives pàgines.


Contribucions
-------------
Si vols contribuir a millorar el Racó Mobile de la FIB, fes un fork al repositori. Fes totes les modificacions i demana un 'pull request' explicant-nos les millores realitzades.

Afegeix la teva app al repositori de la FIB
-------------------------------------------

Aquest és el primer projecte OpenSource d'una App corporativa per a la Facultat d'Informàtica de Barcelona, que volem que us serveixi d'ajuda per al desenvolupament d'altres Apps. Si voleu afegir Apps, que puguin servir als vostres companysal repositori GitHub de la FIB, [contacteu amb nosaltres](http://suport.fib.upc.edu).


Llicència
---------
The content of this project itself is licensed under the [Creative Commons Attribution 3.0 license](http://creativecommons.org/licenses/by-nc-nd/2.0/deed.es_ES).
