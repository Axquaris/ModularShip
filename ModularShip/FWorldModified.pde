
//Modifies FWorld class
public class FWorldModified extends FWorld {
  public void mouseEvent(MouseEvent event){
    PVector mousePos = new PVector(event.getX()/zoom, event.getY()/zoom);
    mousePos.add(-width/2/zoom, -height/2/zoom);
    mousePos.rotate(player.getRotation()+PI);
    mousePos.add(player.getX(), player.getY());
    
  
    if (event.getAction() == event.PRESS
        && event.getButton() == m_mouseButton) {
      
      grabBody(mousePos.x, mousePos.y);
    }

    // mouseReleased
    if (event.getAction()  == event.RELEASE
        && event.getButton() == m_mouseButton) {
        
      releaseBody();
    }

    // mouseDragged
    if (event.getAction()  == event.DRAG) {
    
      dragBody(mousePos.x, mousePos.y);
    }
  }
}