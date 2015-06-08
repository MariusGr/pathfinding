//Knoten:
Knoten[] knoten;
int knotenRadius;      // Radius der Kreise, die die Knoten repräsentieren
int anzahlKnoten = 20;
int bufferI = -1;
int[][] kantengewicht;

KantenListe shortestWay;
Knoten highlighted = null;
Knoten start = null;
Knoten ziel = null;
Knoten lastPressed;


//Grafik:
color hintergrund = color(100, 100, 100);     // Hintergrundfarbe
color standartColor = color(0);   // Sonstige Färbung der Knoten
color hoverColor = color(0, 0, 200);      // Farbe der Knotenränder, wenn die Maus darüber ist
color highlightedColor = color(0, 200, 200);      // Farbe der Knotenränder, wenn die Maus darüber ist
int standartStrokeWeight = 1;  // Sonstige Strichdicke
int hoverStrokeWeight = 3; // Dicke der Ränder und Kanten, wenn sie markiert sind (durch Fall "Maus ist über noten");
int highlightedStrokeWeight = 3; // Dicke der Ränder und Kanten, wenn sie markiert sind (durch Fall "Maus ist über noten");


void setup() {
  size(700, 700);
  textSize(20);

  // Alle Knoten in einem Array
  knoten = new Knoten[anzahlKnoten];

  // Array mit Knoten füllen
  for (int i=0 ; i < knoten.length ; i++) {
    knoten[i] = new Knoten(i);
  }

  // Knoten zufällig miteinander verknüpfen
  for (int i = 0; i < knoten.length; i++) {
    int tEnde = knoten.length;
    for (int j = 0; j < tEnde; j ++) { // jeder Knoten hat zufällig viele Verknüpfungen (minimal 0, maximal so viele wie es Knoten gibt, sprich zu allen exkl. sich selbst (s. dazu "knotenVerknuepfenMit" in "class Knoten")
      int zufall = (int) random(3);
      if (zufall == 1)
        knoten[i].knotenVerknuepfenMit(knoten[j]); //
    }
  }


  // erstelle Kantengewichte
  kantengewicht = new int[anzahlKnoten][anzahlKnoten];
  
  for(int i=0 ; i<anzahlKnoten; i++){
    for(int j=i ; j<anzahlKnoten; j++){
      if(i == j){
        kantengewicht[i][j] = 0;
      } else {
        if(knoten[i].containsWayTo(j)){
          kantengewicht[i][j] = (int) random(10);
          kantengewicht[j][i] = kantengewicht[i][j];
        } else {
          kantengewicht[i][j] = -1; // oder 0 wobei 0 eher die strecken zu sich selbst sein sollte
          kantengewicht[j][i] = kantengewicht[i][j]; // das selbe wie drüber quasi        
        }
      }
    }
  }
  

  // So gross werden die Knoten dargestellt
  knotenRadius = 15;

  refresh(0);
}


void draw() {
  refresh(hoverKnoten());
}


/**
 * Überprüft, ob die Maus sich über einem Knoten befindet.
 * @return Index des Knotens, über dem die Maus ist. -1, wenn die Maus über keinem Knoten ist.
 */
int hoverKnoten() {
  for (int i = 0; i < knoten.length; i++) {             // Alle Knoten abgehen
    PVector temp = knoten[i].position();                // Die Position des aktuell betrachteten Knotens = Position seines Mittelpunktes
    PVector maus = new PVector(mouseX, mouseY);         // Position der Maus
    PVector abstandZuMausV = PVector.sub(temp, maus);   // Abstand zwischen Knoten und Maus als Vector
    float abstandZuMaus = abstandZuMausV.mag();         // und als Wert

    if (abstandZuMaus <= knotenRadius) {                // Wenn der Abstand innerhalb des Radius des Knotens liegt, ist die Maus innerhalb des Kreises, der den Knoten repräsentiert
      return(i);
    }
  } 

  return (-1);
}

/* methode zum hovern über knoten */
void drawHover() {}



/**
 * Stellt den Knoten mit dem Index _i und all seine Kanten als markiert dar
 */
void refresh(int _i) {
  background(hintergrund);



  for (int i = 0; i < knoten.length; i++) {
    if (i == _i) {
      if (mousePressed&&bufferI==-1) {
        /*Lösung mit Buffer, da bei zu
         * schneller Mausbewegung die Maus nicht
         * mehr auf dem Knoten ist und dieser sonst
         * nicht verschon würde.
         */
        bufferI = _i;//

        if (highlighted != null) {
          println("Suche den kürzesten Weg von \"" + highlighted + "\" zu \"" + knoten[i] + "\"");
          shortestPath(highlighted, knoten[_i], anzahlKnoten);
          //randomPath(highlighted, knoten[_i]);
          highlighted = null;
        } else {
          highlighted = knoten[_i];
        }
      }
      knoten[i].zeichneKanten(hoverStrokeWeight, hoverColor);
    } else {
      knoten[i].zeichneKanten(standartStrokeWeight, standartColor);
    }
  }

  for (int i = 0; i < knoten.length; i++) {
    if (knoten[i] == highlighted) {
      knoten[i].zeichnen(knotenRadius*2, highlightedStrokeWeight, highlightedColor);
    } else if (i == _i) {
      knoten[i].zeichnen(knotenRadius*2, hoverStrokeWeight, hoverColor);
    } else {
      knoten[i].zeichnen(knotenRadius*2, standartStrokeWeight, standartColor);
    }
  }

  if (mousePressed && bufferI != -1) {
    knoten[bufferI].setPos(mouseX, mouseY);//position wird solange verändert
  } else {
    bufferI=-1;//bis die Maus losgelassen wird.
  }
}


/**
 * Sucht irgendeinen Weg von einem Knoten _s zu einem Knoten _z.
 */
void randomPath(Knoten _s, Knoten _z) {
  KantenListe tempL = new KantenListe();    // Eine Liste, in den die Funktion searchAnyPathTo aus class Knoten den gefundenen Weg speichern wird

  // Testweise Ausgabe auf die Konsole, ob ein Weg gefunden wurde. Der Aufruf der Funktion ist allerdings an dieser Stelle zwingend erforderlich, die Auswertung der Rückgabe
  // allerdings nicht, da diese in erster Linie nur für die rekursiven Abläufe innerhalb der class Knoten benötigt wird
  println(_s.searchAnyPathTo(_z, tempL));    
  println(tempL);    // Testweise ausgabe der gefundenen Liste
}


/**
 *  Sucht den kürzesten Weg vom Startknoten aus.
 */
void shortestPath(Knoten start, Knoten ziel, int anzahlKnoten) {
  KantenListe tempListe = new KantenListe();

  start.searchShortestPath(ziel, anzahlKnoten);
  //println(tempListe);
}

/* Zeichne alle Wege */
void drawAllConnections(){
  for(int i = 0; i<knoten.length; i++){
    knoten[i].drawConnections();
  }
}

/*  */
void drawAllNodes(){
  for(int i=0; i<knoten.length; i++){
    // knoten[i].drawNode();
  }
}

/*
 * der Body von draw() sollte der besseren lesbarkeit wie folgt aussehen
 * 
 * ...
 * 
 * drawAllConnections();
 * drawShortestWay();
 * drawAllNodes();
 * drawHoverNode();
 * drawText(); bzw. drawNumber();
 * 
 * da diese in einer Schleife aufgerufen wird muss auch nicht refreshed werden
 */


