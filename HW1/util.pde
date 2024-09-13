public void CGLine(float x1,float y1,float x2,float y2, color c){

    float x = x1;
    float y = y1;
    float a = (y2 - y1);
    float b = -(x2 - x1);
    float m = -(a/b);
    
    if (x1 > x2){
        a = (y1 - y2);
        b = -(x1 - x2);
        
        x = x2;
        x2 = x1;
        x1 = x;
        
        y = y2;
        y2 = y1;
        y1 = y;
    }

    drawPoint(x, y, c);
    
    if (0 <= m && m <= 1) {
        float d = a + b/2;
        while (x < x2) {   
            // choose E
            if (d <= 0) {
                x++;
                d += a; 
            }
             
             // choose SE
             else { 
                 x++;
                 y++;
                 d += (a+b); 
             } 
             drawPoint(x, y, c);
        }
    }

    else if (-1 <= m && m <= 0) {
        float d = a - b/2;
        while (x < x2) {   
            // choose E
            if (d >= 0) {
                x++;
                d += a; 
            }
             
            // choose NE
            else { 
                x++;
                y--;
                d += a-b; 
            } 
            drawPoint(x, y, c);
        }
    }   
    
    else if (m > 1) {
        float d = a/2 + b;
        while (y < y2) {   
            // choose S
            if (d >= 0) {
                y++;
                d += b; 
            }
             
            // choose SE
            else { 
                x++;
                y++;
                d += a+b; 
            } 
            drawPoint(x, y, c);
        }
    }   
    
    else if (m < -1) {
        float d = a/2 - b;
        while (y > y2) {   
            // choose N
            if (d <= 0) {
                y--;
                d -= b; 
            }
             
            // choose NE
            else { 
                x++;
                y--;
                d += a-b; 
            } 
            drawPoint(x, y, c);
        }
    }   
}


public void CGCircle(float x,float y,float r, color c){
    float X = x;
    float Y = y;
    x = 0;
    y = round(r);
    float d = 1 - r;
    float incE = 3;
    float incSE = -2*r + 5;

    while (x <= y) {
        drawPoint(X+x, Y+y, c);
        drawPoint(X+x, Y-y, c);
        drawPoint(X-x, Y+y, c);
        drawPoint(X-x, Y-y, c);
        drawPoint(X+y, Y+x, c);
        drawPoint(X+y, Y-x, c);
        drawPoint(X-y, Y+x, c);
        drawPoint(X-y, Y-x, c);
        
        // choose E
        if (d < 0) {
            d += incE;
            incE += 2;
            incSE += 2;
            x++;
        }
       
        // choose SE
        else {
            d += incSE;
            incE += 2;
            incSE += 4;
            x++;
            y--;
        }
    }
}

public void CGEllipse(float x,float y,float r1,float r2, color c){

    float X = x;
    float Y = y;
    
    float dx, dy, d1, d2;
    x = 0;
    y = r2;
 
    // Initial decision parameter of region 1
    d1 = (r2 * r2) - (r1 * r1 * r2) + (0.25f * r1 * r1);
    dx = 2 * r2 * r2 * x;
    dy = 2 * r1 * r1 * y;
    
    // For region 1
    while (dx < dy)
    {
        // Print points based on 4-way symmetr2
        drawPoint(X+x, Y+y, c);
        drawPoint(X-x, Y+y, c);
        drawPoint(X+x, Y-y, c);
        drawPoint(X-x, Y-y, c);
 
        // Checking and updating value of
        // decision parameter based on algorithm
        if (d1 < 0) {
            x++;
            dx = dx + (2 * r2 * r2);
            d1 = d1 + dx + (r2 * r2);
        }
        else {
            x++;
            y--;
            dx = dx + (2 * r2 * r2);
            dy = dy - (2 * r1 * r1);
            d1 = d1 + dx - dy + (r2 * r2);
        }
    }
 
    // Decision parameter of region 2
    d2 = ((r2 * r2) * ((x + 0.5f) * (x + 0.5f)))
        + ((r1 * r1) * ((y - 1) * (y - 1)))
        - (r1 * r1 * r2 * r2);
 
    // Plotting points of region 2
    while (y >= 0) {
        // printing points based on 4-way symmetr2
        drawPoint(X+x, Y+y, c);
        drawPoint(X-x, Y+y, c);
        drawPoint(X+x, Y-y, c);
        drawPoint(X-x, Y-y, c);
 
        // Checking and updating parameter
        // value based on algorithm
        if (d2 > 0) {
            y--;
            dy = dy - (2 * r1 * r1);
            d2 = d2 + (r1 * r1) - dy;
        }
        else {
            y--;
            x++;
            dx = dx + (2 * r2 * r2);
            dy = dy - (2 * r1 * r1);
            d2 = d2 + dx - dy + (r1 * r1);
        }
    }
}

public void CGCurve(Vector3 p1,Vector3 p2,Vector3 p3,Vector3 p4, color c){

    Vector3 P = new Vector3();
    for (float t=0; t<=1; t=t+0.0001){
        float p1_coef = (float) Math.pow((1-t), 3);
        float p2_coef = (float) (3 * Math.pow((1-t), 2) * t);
        float p3_coef = (float) (3 * (1-t) * Math.pow(t, 2));
        float p4_coef = (float) Math.pow(t, 3);
        
        Vector3 p1_result = Vector3.mult(p1_coef, p1);
        Vector3 p2_result = Vector3.mult(p2_coef, p2);
        Vector3 p3_result = Vector3.mult(p3_coef, p3);
        Vector3 p4_result = Vector3.mult(p4_coef, p4);
        
        P = Vector3.add(p1_result, p2_result);
        P = Vector3.add(P, p3_result);
        P = Vector3.add(P, p4_result);
        
        drawPoint(P.x, P.y, c);
    }
}

public void CGEraser(Vector3 p1,Vector3 p2){

    for (float x = p1.x; x <= p2.x; x++) {
        for (float y = p1.y; y <= p2.y; y++) {
            drawPoint(x, y, color(250));
        }
    }
}

public void drawPoint(float x,float y,color c){
    stroke(c);
    point(x,y);
}

public float distance(Vector3 a,Vector3 b){
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c,c));
}


    
