
public interface Shape{
    public void drawShape();
}

public class Point implements Shape{
    ArrayList<Vector3> points = new ArrayList<Vector3>();
    public Point(ArrayList<Vector3> p, color input_color){
        points = p;
        c = input_color;
    }
    public color c = color(0, 0, 0);
  
    @Override
    public void drawShape(){
        if(points.size()<=1) return;  
        for(int i=0;i<points.size()-1;i++){
            Vector3 p1 = points.get(i);
            Vector3 p2 = points.get(i+1);
            CGLine(p1.x,p1.y,p2.x,p2.y, c);
        }
    }
}

public class Line implements Shape{
    Vector3 point1;
    Vector3 point2;
    public color c = color(0, 0, 0);
    
    public Line(){};
    public Line(Vector3 v1,Vector3 v2, color input_color){
        point1 = v1;
        point2 = v2;
        c = input_color;
    }
    
    @Override
    public void drawShape(){
        CGLine(point1.x,point1.y,point2.x,point2.y, c);
    }
    
   
}

public class Circle implements Shape{
    Vector3 center;
    float radius;
    public color c = color(0, 0, 0);
    
    public Circle(){}
    public Circle(Vector3 v1,float r, color input_color){
        center = v1;
        radius = r;
        c = input_color;
    }
    @Override
    public void drawShape(){
        CGCircle(center.x,center.y,radius, c);
    }   
}

public class Polygon implements Shape{
    ArrayList<Vector3> verties = new ArrayList<Vector3>();
    public color c = color(0, 0, 0);
    
     public Polygon(ArrayList<Vector3> v, color input_color){
        verties= v;
        c = input_color;
    }
    
    @Override
    public void drawShape(){
        if(verties.size()<=0) return;
        for(int i=0;i<=verties.size();i++){
              Vector3 p1 = verties.get(i%verties.size());
              Vector3 p2 = verties.get((i+1)%verties.size());
              CGLine(p1.x,p1.y,p2.x,p2.y, c);
         }
    } 
}

public class Ellipse implements Shape{
    Vector3 center;
    float radius1,radius2;
    public color c = color(0, 0, 0);
    
    public Ellipse(){}
    public Ellipse(Vector3 cen,float r1,float r2, color input_color){
        center = cen;
        radius1 = r1;
        radius2 = r2;
        c = input_color;
    }
    
    @Override
    public void drawShape(){
        CGEllipse(center.x,center.y,radius1,radius2, c);
    }
}

public class Curve implements Shape{
    Vector3 cpoint1,cpoint2,cpoint3,cpoint4;
    float radius1,radius2;
    public color c = color(0, 0, 0);
    
    public Curve(){}
    public Curve(Vector3 p1,Vector3 p2,Vector3 p3,Vector3 p4, color input_color){
       cpoint1 = p1; cpoint2 = p2; cpoint3 = p3; cpoint4 = p4;   
       c = input_color;
    }
    
    @Override
    public void drawShape(){
        CGCurve(cpoint1,cpoint2,cpoint3,cpoint4, c);
    }
}

public class EraseArea implements Shape{
    Vector3 point1,point2;
    public EraseArea(){}
    public EraseArea(Vector3 p1,Vector3 p2){
       point1 = p1; point2 = p2; 
    }
    @Override
    public void drawShape(){
        CGEraser(point1,point2);
    }
}

public class Triangle implements Shape{
    Vector3 point1, point2;
    public color c = color(0, 0, 0);
    
    public Triangle(){}
    public Triangle(Vector3 v1, Vector3 v2, color input_color){
       point1 = v1; point2 = v2;
       c = input_color;
    }
    
    @Override
    public void drawShape(){
        CGLine(point1.x, point2.y, (point1.x + point2.x)/2, point1.y, c);
        CGLine((point1.x + point2.x)/2, point1.y, point2.x, point2.y, c);
        CGLine(point1.x, point2.y, point2.x, point2.y, c);
    }
}


public class Star implements Shape{
    Vector3 point1, point2;
    float radius1,radius2;
    private ArrayList<Vector3> points = new ArrayList<Vector3>();
    public color c = color(0, 0, 0);
    
    public Star(){}
    public Star(Vector3 v1, Vector3 v2, color input_color){
       point1 = v1; point2 = v2;
       c = input_color;
    }
    
    @Override
    public void drawShape(){
        float r = distance(point1, point2);
          
        for (int i = 0; i < 5; i++) {
            float angle = (float) (Math.toRadians(72 * i));
            float outerX = point1.x + r * (float) Math.sin(angle);
            float outerY = point1.y - r * (float) Math.cos(angle);
    
            angle = (float) (Math.toRadians(72 * i + 36));
            float innerX = point1.x + r / 2 * (float) Math.sin(angle);
            float innerY = point1.y - r / 2 * (float) Math.cos(angle);
    
            points.add(new Vector3(outerX, outerY, 0));
            points.add(new Vector3(innerX, innerY, 0));
        }
        
        if(points.size()>0){
            for(int i=0;i<points.size()-1;i++){
                Vector3 p1 = points.get(i);
                Vector3 p2 = points.get(i+1);
                CGLine(p1.x, p1.y, p2.x, p2.y, c);
            }
            Vector3 p1 = points.get(points.size()-1);
            Vector3 p2 = points.get(0);
            CGLine(p1.x, p1.y, p2.x, p2.y, c);
        }     
        
        points = new ArrayList<Vector3>();

    }
}
