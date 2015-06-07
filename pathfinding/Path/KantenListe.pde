// Diese Klasse ist richtig schön Copy and Paste aus dem Praktikum OOP2
import java.util.Iterator;

public class KantenListe {
  private Node first;
  
  /**
   * EIne Klasse zur Verwaltung einer Liste.
   */
  KantenListe() {
    this.first = null;    // erster Knoten
  }
  
  
  public boolean contains(int n){
    return this.first.contains(n);
  }
  
  public KantenIterator iterator() {
    KantenIterator newI = new KantenIterator(this.first);
    return(newI);
  }
  
  public void knotenEntfernen(Knoten _k) {
    if (!listeLeer()) {
      first.suchenUndEntfernen(_k);
    }
  }
  
  /**
   * Fügt einen Knoten am Anfang der Liste an.
   * @param _s Nutzlast-Text des neuen Knotens
   */
  public void anAnfangEinfuegen(Knoten _k) {
    Node second = this.first;          //Der zweite Knoten wird zwischengespreichert
    this.first = new Node(_k);          //Erzeugung eines Knoten und Festlegung als ersten Knoten der Liste
      
    if (second != null) {
      this.first.vorKnotenLegen(second);      //neuen ersten Knoten vor den zweiten Schieben
    }
  }
  
  /**
   * Fügt einen Knoten am Ende der Liste an.
   * @param _s Nutzlast-Text des neuen Knotens
   */
  public void anEndeEinfuegen(Knoten _k) {
    if (this.first == null) {
      anAnfangEinfuegen(_k);
    } else {
      Node newNode = new Node(_k);        //Erzeugung eines Knoten
      newNode.hinterKnotenLegen(letzterKnoten());  //neuen Knoten hinter den letzten der Liste legen
    }
  }
  
  /**
   * Gibt die Liste als String zurück.
   * @return Liste als String
   * @Override
   */
  public String toString() {
    String ausgabe;
    
    if (!listeLeer()) {
      return(this.first.toString());
    } else {
      ausgabe = "Die Liste ist leer.";
    }
    
    return(ausgabe);
  }
  
  /**
   * Prüft, ob die Liste leer ist.
   * @return Ist die Liste leer?
   */
  private boolean listeLeer() {
    if(this.first == null) {
      return(true);
    }
    return(false);
  }
  
  /**
   * Gibt den letzten Knoten der Liste zurück.
   * @return letzter Knoten der Liste
   */
  private Node letzterKnoten() {
    if (!listeLeer()) {
      return(first.letzterFolger());
    }
    
    return(null);
  }
  
  /**
   * Prüft, ob ein String mit der Nutzlast eines Knoten der Liste übereinstimmt.
   * @param _s Zu suchender String
   * @return Ist dieser String in der Liste einthalten?
   */
  public boolean inListeEnthalten(Knoten _k) {
    if (this.first != null) {
      return(this.first.abHierEnthalten(_k));
    }
    
    return(false);
  }
  
  /**
  * Zeichnet die Kanten von allen Knoten zu einem Knoten _k
  */
  public void zeichneAlle(Knoten _k, int _s, color _c) {
    if (!listeLeer()) {
      this.first.zeichneKantenAbHier(_k, _s, _c);
    }
  }
  
  
  private class KantenIterator implements Iterator {
    protected Node akt;
    
    KantenIterator(Node _n) {
      this.akt = _n;
    }
    
    public boolean hasNext() {
      if(akt == null) {
        return false;
      }
      return true;
    }
    
    public Knoten next() {
      Knoten temp = akt.nutzlast;
      
      if (hasNext()) {
        temp = akt.nutzlast;
        akt = akt.next;
      }
      
      return temp;
    }
    
    public void remove() {
      //nischt
    }
  }
  
  private class Node {
    private Node next;
    private Node previous;
    private Knoten nutzlast;
    
    /**
     * Erzeugt einen neuen Knoten. Dieser hat noch keinen Nachfolger in der Liste.
     * @param _s Nutzlast-Text
     */
    Node(Knoten _k) {
      next = null;
      previous = null;
      nutzlast = _k;
    }
    
    private boolean contains(int n){
      if(this.nutzlast.getNummer() == n){
        return true;
      } else {
        if(this.next == null){
          return false;
        } else {
          return this.next.contains(n);
        }
      }
    }
    
    /**
     * Gibt die Nutzlasten des Knotens und all seiner Folgeknoten als String zurück.
     * @return Knoten und alle Folgeknoten als String
     */
    public String toString() {
      String ausgabe = this.nutzlast.toString();
      
      if (this.next != null) {
        ausgabe += ", " + this.next.toString();
      }
      
      return(ausgabe);
    }
    
    /**
     * Prüft die Übereinstimmung eines Strings mit der Nutzlast dieses Knotens und all seiner Folgeknoten.
     * @param _s Zu prüfender String
     * @return Übereinstimmung?
     */
    public boolean abHierEnthalten(Knoten _k) {
      if (this.nutzlast.equals(_k)) {
        return(true);
      } else if (this.next != null) {
        return(this.next.abHierEnthalten(_k));
      }
      
      return(false);
    }
    
    /**
    * Geht ab diesem Knoten die gesamte weitere Liste ab und zeichnet für jeden Knoten die Kante zu dem Knoten, zu dem diese Liste gehört.
    */
    public void zeichneKantenAbHier(Knoten _k, int _s, color _c) {
      if (this.nutzlast != null) {
          this.nutzlast.zeichneKante(_k, _s, _c);
      }
      
      if (this.next != null) {
        next.zeichneKantenAbHier(_k, _s, _c);
      }
    }
    
    /**
     * Gibt den letzten Folgeknoten dieses Knotens zurück.
     * @return Letzter Folgeknoten
     */
    public Node letzterFolger() {
      if (this.next != null) {
        return(this.next.letzterFolger());
      }
      
      return(this);
    }
    
    /**
     * Fügt diesen Knoten vor einem anderen Knoten in die Liste ein.
     * @param _n Neuer Folgeknoten
     */
    public void vorKnotenLegen(Node _n) {
      this.next = _n;
      this.previous = _n.previous;
      
      if (_n.previous != null)
        _n.previous.next = this;
        
      _n.previous = this;
    }
    
    /**
     * Fügt diesen Knoten hinter einen anderen Knoten in die Liste ein.
     * @param _n neuer Vorgänger
     */
    public void hinterKnotenLegen(Node _n) {
      this.previous = _n;
      this.next = _n.next;
      
      if (_n.next != null) 
        _n.next.previous = this;
        
      _n.next = this;
    }
    
    public void suchenUndEntfernen(Knoten _k) {
      if (this.nutzlast == _k) {
        this.entfernen();
      } else {
        if (this.next != null) {
          this.next.suchenUndEntfernen(_k);
        }
      }
    }
    
    public void entfernen() {
      this.previous.next = this.next;
      this.next.previous = this.previous;
    }
  }
}

