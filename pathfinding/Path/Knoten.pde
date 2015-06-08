import java.util.Iterator;

class Knoten {
  private KantenListe kantenListe; // Die Liste aller Knoten, zu denen von diesem eine Verknüpfung ausgeht
  private int nummer;              // Index
  private int xPos;                // Position
  private int yPos;
  private int[][] dijkstraListe;
  private int count = 0;

  Knoten(int _n) {
    kantenListe = new KantenListe();
    nummer = _n;
    // Positionierung erfolgt zufällig
    xPos = (int) random(width);
    yPos = (int) random(height);
  }

/* temp.x und temp.y nicht erreichbar aber vom gedankengan sollte das so sein bzw. 2 vectoren übergeben
  public void drawConnections(){
    KantenListe temp = kantenListe;
    while(kantenListe.iterator().hasNext()){
      temp.iterator().next();
      strokeWeight(3); // temporär
      stroke(130);     // temporär
      line(this.xPos, this.yPos, temp.x, temp.y);
      noStroke();
    }
  }
*/

  public boolean containsWayTo(int n){
    return this.kantenListe.contains(n);
  }

  /**
   * Fügt einen Knoten in die Liste dieses Knotens ein und umgekehrt, und verknüpft diese so. Ein Knoten kann
   * nicht mit sich selbst verknüpft werden.
   */
  public void knotenVerknuepfenMit(Knoten _k) {
    if (this != _k && !this.kantenListe.inListeEnthalten(_k)) {
      this.kantenListe.anEndeEinfuegen(_k); // so rum
      _k.kantenListe.anEndeEinfuegen(this); // und andersrum
    }
  }

  /**
   * Mysteriöse Wunderklasse die irgendwie den Index als String zurückgibt
   */
  public String toString() {
    return String.valueOf(this.nummer);
  }

  /**
   *  Gibt die Indexnummer des aktuellen Knoten zurück
   */
  public int getNummer() {
    return this.nummer;
  }

  /**
   * Rückgabe der Liste als String zu Testzwecken
   */
  public String kantenToString() {
    return this.kantenListe.toString();
  }

  /**
   * Gibt die Position als Vektor zurück
   */
  public PVector position() {
    PVector temp = new PVector(xPos, yPos);
    return temp;
  }

  /**
   * Zeichnet den Knoten.
   * @param _d Durchmesser des Kreises
   * @param _s Dicke des Randes
   * @param _c Farbe der Füllung
   */
  public void zeichnen(int _d, int _s, color _c) {
    strokeWeight(_s);
    stroke(_c);

    fill(255);
    ellipse(this.xPos, this.yPos, _d, _d);

    fill(0);
    text(this.nummer, this.xPos-_d/4, this.yPos+_d/4);
    
    noStroke();
  }

  /**
   * Zeichnet alle Kanten des Knotens.
   * @param _s Dicke der Kantenlinie
   * @param _c Farbe der Kantenlinie
   */
  public void zeichneKanten(int _s, color _c) {
    this.kantenListe.zeichneAlle(this, _s, _c);
  }

  /**
   * Zeichnet eine Linie von diesem Knoten zu einem anderen Knoten _k
   * @param _s Dicke der Kantenlinie
   * @param _c Farbe der Kantenlinie
   */
  public void zeichneKante(Knoten _k, int _s, color _c) {
    PVector temp = _k.position();

    strokeWeight(_s);
    stroke(_c);
    line(temp.x, temp.y, this.xPos, this.yPos);
    noStroke();
  }

  /**
   * Findet irgendeinen Pfad von diesem Knoten zu einem Zielknoten _z.
   * @param _z Zielknoten
   * @param _k Liste bisher abgegangener Knoten
   *
   * @return Wurde ein Weg von diesem Knoten aus gefunden?
   */
  public boolean searchAnyPathTo(Knoten _z, KantenListe _k) {

    // Da dieser Knoten soeben Teil des abgelaufenen Weges geworden ist, trägt er sich in die Liste ein
    _k.anEndeEinfuegen(this);

    if (_z == this) {    // Ist dieser Knoten der gesuchte?
      return true;    // Dies ist der Abbruch des rekursiven Aufrufs. Es wurde ein Weg gefunden
    } else {
      Iterator tempIt = this.kantenListe.iterator();    // Ein Iterator auf der Liste des bisherigen Weges
      boolean tempBoolean = false;                      // Hier wird gespeichert, ob der gesuchte Weg über einen der mit diesem Knoten verknüpften Knoten gefunden wurde

        while (tempIt.hasNext () && !tempBoolean) {        // Diese Schleife iteriert über alle anhängenden Knoten bis es keine mehr gibt und nur solange, wie noch kein Weg gefunden wurde (steht in temoBoolean

          // Der iterierte Kram...

        Knoten tempK = (Knoten) tempIt.next();       // 1) aktuellen Knoten festhalten, Cursor geht dann einen weiter

        if (!_k.inListeEnthalten(tempK)) {          // 2) Natürlich muss nur etwas mit dem aktuellen Knoten angestellt werden, wenn dieser nicht bereits im bisherigen Weg enthalten ist. Sonst käme es zu Endloschschleifen und Imkreisrennerei
          tempBoolean = tempK.searchAnyPathTo(_z, _k);    // 3) Hier geschieht der rekursive AUfruf. Er wird true zurückgeben, wenn von diesem aktuellen Knoten aus ein Weg zu finden ist und dieser steht dann auch in der Liste _k

            // Sollte über den aktuellen Knoten kein Weg gefunden worden sein, muss er aus der Liste des bisherigen Weges entfernt werden. So stehen am Ende nur die Knoten in der Liste, über die der Weg möglich war
          // Die Liste wird also leer sein, wenn es keinen Weg zu finden gab

          if (!tempBoolean) {                     
            _k.knotenEntfernen(tempK);
          }
        }
      }

      return tempBoolean;    // Was auch immer bei der Suche rauskam wird hier zurückgegeben.

      // Bevor man diese Funktion nutzt, muss ein Objekt der KantenListe erzeugt worden sein, auf das man auch nach AUsführen dieser Funktion noch zugreifen kann. 
      //Es wird dann dieser Funktion übergeben und nach Ausführen dieser kann die Liste ausgelesen werden, um den gefundenen Weg zu erhalten.
    }
  }

  /**
   *  Sucht den kürzesten Weg zu allen benachbarten Knoten mithilfe des Dijkstra-Wegfindungs-Algorithmus.
   */
  public void searchShortestPath(Knoten ziel, int anzahlKnoten) {
    if (dijkstraListe != null) {
      print(kuerzesterWegZu(ziel) + "\n\n"); //Weg ausgeben
    } else { //noch keine Liste vorhanden
      erstelledijkstraListe(anzahlKnoten);
      dijkstra(this.dijkstraListe);
      print(kuerzesterWegZu(ziel) + "\n\n"); //Weg ausgeben
    }
  }

  /**
   *  Algorithmus druchlaufen
   */
  public void dijkstra(int[][] dijkstraListe) {
    count ++;
    if (count > 20) {
      println("ERROR: ENDLOSSCHLEIFE!");
      return;
    }
    Knoten naechsterNachbar = null;
    dijkstraListe[this.getNummer()][0] = 1; //setze diesen Knoten in der Liste als besucht
    Iterator tempIt = this.kantenListe.iterator();
    while (tempIt.hasNext ()) { //geht alle nachbarn den Knoten durch
      Knoten temp = (Knoten) tempIt.next();

      if (dijkstraListe[temp.getNummer()][0] == -1) { //Knoten unbesucht
        if (dijkstraListe[temp.getNummer()][1] == -1) { //Noch keine Distanz eingetragen
          dijkstraListe[temp.getNummer()][1] = kantengewicht(this.getNummer(), temp.getNummer());
          dijkstraListe[temp.getNummer()][2] = this.getNummer();
        }
        if (dijkstraListe[temp.getNummer()][1] > (dijkstraListe[this.getNummer()][1] + kantengewicht(this.getNummer(), temp.getNummer()))) { //neue Distanz geringer, als bisher
          dijkstraListe[temp.getNummer()][1] = dijkstraListe[this.getNummer()][1] + kantengewicht(this.getNummer(), temp.getNummer()); //neue Distanz setzen
          dijkstraListe[temp.getNummer()][2] = this.getNummer();
        }

        if (naechsterNachbar == null) {
          naechsterNachbar = temp;
        } else if (kantengewicht(this.getNummer(), naechsterNachbar.getNummer()) > kantengewicht(this.getNummer(), temp.getNummer())) { //wenn noch kein nächster Nachbar eingetragen, oder der neue näher als der bisherige ist
          naechsterNachbar = temp;
        }
      }
    }
    if (naechsterNachbar != null) { //wenn ein nächster Nachbar eingetragen wurde (also wenn ein unbesuchter Nachbar vorhanden war)
      naechsterNachbar.dijkstra(dijkstraListe); //"folge" dem nächsten Nachbarn und führe von vorne aus.
    }
  }

  /**
   *  Durchläuft den Dijkstra Algorithmus für den aktuellen Knoten und erstellt die Liste
   */
  public void erstelledijkstraListe(int anzahlKnoten) {
    dijkstraListe = new int[anzahlKnoten][3]; //[][i] i=0 "besucht (-1/+1)", i=1 "distanz zum Startpunkt (int)", i=2 "Vorgängerknoten (Knotenindex)"
    for (int i = 0; i < dijkstraListe.length; i++) { //"leeres" Array mit überall -1 erzeugen
      for (int j = 0; j < 3; j++) {
        if (i == this.getNummer()) { //wenn i = startknoten, dann setze Startwerte
          dijkstraListe[i][0] = 1; //Besucht
          dijkstraListe[i][1] = 0; //Distanz = 0
          dijkstraListe[i][2] = i; //Vorgänger = eigener Index
        } else {
          dijkstraListe[i][j] = -1; //für alle anderen Knoten -1
        }
      }
    }
  }

  /**
   *  Den Weg aus der Liste rückwärts zusammensetzen.
   */
  public String kuerzesterWegZu(Knoten ziel) {
    Knoten start = this;
    String weg = "";
    int kantenSumme=0;
    int gesuchterKnoten = ziel.getNummer();

    while (dijkstraListe[gesuchterKnoten][2] != gesuchterKnoten && dijkstraListe[gesuchterKnoten][2] != -1) { //solange der Vorgänger eines Knoten nicht er selbst ist (weil dann ist er der Startknoten)
      
      if (weg == "") {
        weg = "--" + dijkstraListe[gesuchterKnoten][1] + "--" + "( " + String.valueOf(gesuchterKnoten) + " )";
      } else {
        weg = "--" + dijkstraListe[gesuchterKnoten][1] + "--" + "( " + gesuchterKnoten + " )" + weg; //Vorgänger vorne an den Weg anfügen
      }
      kantenSumme += dijkstraListe[gesuchterKnoten][1]; //Kantensumme um Kantengewicht inkrementieren
      gesuchterKnoten = dijkstraListe[gesuchterKnoten][2];
    }
    if (dijkstraListe[gesuchterKnoten][2] == -1 || dijkstraListe[gesuchterKnoten][1] == -1) {
        return "Knoten nicht verbunden!";
    }
    return "Strecke: " + "( " + gesuchterKnoten + " )" + weg + ", Streckenkosten gesamt: " + kantenSumme;
  }

  /**
   *  Testmethode, um Kantengewichte zurückzugeben (für dijkstra()).
   */
  public int kantengewicht(int vonKnoten, int zuKnoten) {
    if ((vonKnoten == 0 && zuKnoten == 0) || (zuKnoten == 0 && vonKnoten == 0)) {
      return 0;
    }
    if ((vonKnoten == 0 && zuKnoten == 1) || (zuKnoten == 0 && vonKnoten == 1)) {
      return 4;
    }
    if ((vonKnoten == 0 && zuKnoten == 2) || (zuKnoten == 0  && vonKnoten == 2)) {
      return 1;
    }
    if ((vonKnoten == 0 && zuKnoten == 3) || (zuKnoten == 0 && vonKnoten == 3)) {
      return 3;
    }
    if ((vonKnoten == 0 && zuKnoten == 4) || (zuKnoten == 0 && vonKnoten == 4)) {
      return 4;
    }
    if ((vonKnoten == 1 && zuKnoten == 1) || (zuKnoten == 1 && vonKnoten == 1)) {
      return 0;
    }
    if ((vonKnoten == 1 && zuKnoten == 2) || (zuKnoten == 1 && vonKnoten == 2)) {
      return 2;
    }
    if ((vonKnoten == 1 && zuKnoten == 3) || (zuKnoten == 1 && vonKnoten == 3)) {
      return 5;
    }
    if ((vonKnoten == 1 && zuKnoten == 4) || (zuKnoten == 1 && vonKnoten == 4)) {
      return 3;
    }
    if ((vonKnoten == 2 && zuKnoten == 2) || (zuKnoten == 2 && vonKnoten == 2)) {
      return 0;
    }
    if ((vonKnoten == 2 && zuKnoten == 3) || (zuKnoten == 2 && vonKnoten == 3)) {
      return 3;
    }
    if ((vonKnoten == 2 && zuKnoten == 4) || (zuKnoten == 2 && vonKnoten == 4)) {
      return 6;
    }
    if ((vonKnoten == 3 && zuKnoten == 3) || (zuKnoten == 3 && vonKnoten == 3)) {
      return 0;
    }
    if ((vonKnoten == 3 && zuKnoten == 4) || (zuKnoten == 3 && vonKnoten == 4)) {
      return 1;
    }
    if ((vonKnoten == 4 && zuKnoten == 4) || (zuKnoten == 4 && vonKnoten == 4)) {
      return 0;
    }
    return -1;
  }

  /** EZ set Methode um den Dahm zu ärgern*/
  public void setPos(int xPos, int yPos) {
    this.xPos = xPos;
    this.yPos = yPos;
  }
}

