public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}
public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int)y * width + (int)x;
    if (outOfBoundary(x, y)) return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}



boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // HW2
    // To-Do : You need to check the coordinate p(x,v) if inside the vertexes. If yes return true.

    boolean c = false;
    
    // Ray Casting Algorithm
    int j = vertexes.length - 1;
    for (int i = 0; i < vertexes.length; i++) {
      if (((vertexes[i].y > y) != (vertexes[j].y > y)) &&
          (x < (vertexes[j].x - vertexes[i].x) * (y - vertexes[i].y) / (vertexes[j].y - vertexes[i].y) + vertexes[i].x)) {
          c = !c;
        }
        j = i;
    }

    return c;
}

public Vector3[] findBoundBox(Vector3[] v) {
    Vector3 recordminV=new Vector3(1.0/0.0);
    Vector3 recordmaxV=new Vector3(-1.0/0.0);
    // HW2
    // To-Do : You need to find the bounding box of the vertexes v.

    //     r1 -------
    //       |   /\  |
    //       |  /  \ |
    //       | /____\|
    //        ------- r2
    // 之後再貼 不然會黑爆
    for (int i = 0; i < v.length; i++) {
        if (v[i].x < recordminV.x){
           recordminV.x = v[i].x;
        }
        if (v[i].y < recordminV.y){
           recordminV.y = v[i].y ;
        }
        if (v[i].x > recordmaxV.x){
           recordmaxV.x = v[i].x;
        }
        if (v[i].y > recordmaxV.y){
           recordmaxV.y = v[i].y;
        }
    }
    
    Vector3[] result={recordminV, recordmaxV};
    return result;
}


public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input=new ArrayList<Vector3>();
    ArrayList<Vector3> output=new ArrayList<Vector3>();
    for (int i=0; i<points.length; i+=1) {
        input.add(points[i]);
    }

    // HW2
    // To-Do
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.

    for (int i=0; i<boundary.length; i++){
        int i2 = (i+1) % boundary.length;
         output=new ArrayList<Vector3>();
         
        for(int j=0; j<input.size(); j++){
            int j2 = (j+1) % input.size();  
            
            float bx1 = boundary[i].x; float by1 = boundary[i].y;
            float bx2 = boundary[i2].x; float by2 = boundary[i2].y;
            float x1 = input.get(j).x; float y1 = input.get(j).y;
            float x2 = input.get(j2).x; float y2 = input.get(j2).y;
            
            float P1 = (bx2 - bx1) * (y1 - by1) - (by2 - by1) * (x1 - bx1);
            float P2 = (bx2 - bx1) * (y2 - by1) - (by2 - by1) * (x2 - bx1);
            
            // 點為順時針排列
            // P < 0，代表點在線的右側(內部)，P = 0 在線上， P > 0 在線外
            
            // 情況一：皆在內側，取 P2
            if (P1 < 0 && P2 < 0){
                output.add(input.get(j2));
            }
            
            // 情況二：內側到外側，取交點
            else if (P1 < 0 && P2 >= 0){
                Vector3 pi = findIntersectionPoint(boundary[i], boundary[i2], input.get(j), input.get(j2));
                output.add(pi);
            }
            
            // 情況三：皆在外側，不取
            else if (P1 >= 0 && P2 >= 0){
                // Do Nothing
            }
            
            // 情況四：外側到內側，取 i 和 P2
            else if(P1 >= 0 && P2 < 0){
                Vector3 pi = findIntersectionPoint(boundary[i], boundary[i2], input.get(j), input.get(j2));
                output.add(pi);
                output.add(input.get(j2));
            }
        }
        
        input=new ArrayList<Vector3>();
        for(int j=0; j<output.size(); j++){
            input.add(output.get(j));
        }
    }
    
    
    
     /*
     output = input;
     */



    Vector3[] result=new Vector3[output.size()];
    for (int i=0; i<result.length; i+=1) {
        result[i]=output.get(i);
    }
    return result;
}

public float getDepth(float x, float y, Vector3[] vertex ) {
    // To - Do
    // You need to calculate the depth (z) in the triangle (vertex) based on the positions x and y. and return the z value;
    Vector3 v1 = Vector3.sub(vertex[0], vertex[1]);
    Vector3 v2 = Vector3.sub(vertex[0], vertex[2]);
    Vector3 n = Vector3.cross(v1, v2).unit_vector();
    float D = -(n.x * vertex[0].x + n.y * vertex[0].y + n.z * vertex[0].z);
    float z = -(n.x * x + n.y * y + D)/n.z;
    
    return z;
    //return 0.0;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A=verts[0].homogenized();
    Vector3 B=verts[1].homogenized();
    Vector3 C=verts[2].homogenized();

    // To - Do (HW4)
    // Calculate the barycentric coordinates of point P in the triangle verts using the barycentric coordinate system.


    float[] result={0.0, 0.0, 0.0};

    return result;
}


// p1、p2 為邊界，p3、p4 為多邊形的邊
public Vector3 findIntersectionPoint (Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4){
    float x_numerator = (p1.x*p2.y - p1.y*p2.x) * (p3.x-p4.x) - (p1.x-p2.x) * (p3.x*p4.y - p3.y*p4.x);
    float y_numerator = (p1.x*p2.y - p1.y*p2.x) * (p3.y-p4.y) - (p1.y-p2.y) * (p3.x*p4.y - p3.y*p4.x);
    float denominator = (p1.x - p2.x) * (p3.y-p4.y) - (p1.y-p2.y) * (p3.x - p4.x);
    
    Vector3 result = new Vector3(x_numerator/denominator, y_numerator/denominator, 0);
    return result;
}
