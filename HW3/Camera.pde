public class Camera {
    Matrix4 projection=new Matrix4();
    Matrix4 worldView=new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;
    Camera() {
        wid=256;
        hei=256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }


    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        // To - Do
        // This function takes four parameters, which are the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        
        projection = Matrix4.Identity();
        
        
        float AR = w/h;        // Aspect Ratio
        //float AR = 1;        // Aspect Ratio

        float y = far;
        float H = near;
        float theta = radians(GH_FOV);
        //float theta = GH_FOV;
        
        projection.m[5] = AR;
        projection.m[10] = (y/(y-H))*tan(theta);
        projection.m[11] = ((H*y)/(H-y))*tan(theta);
        projection.m[14] = tan(theta);
        projection.m[15] = 0;
        
        /*
        System.out.println("projection");
        printMatrix4(projection);
        System.out.println("");
        */
    }
    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
       
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // To - Do
        // This function takes two parameters, which are the position of the camera and the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.
        
        
        worldView = Matrix4.Identity();
        
        // pos = e_x, lookat = c_x
        
        Vector3 topVector = new Vector3(0,1,0);      // VT
        //topVector = Vector3.sub(topVector, pos);
        Vector3 viewVector = Vector3.sub(lookat, pos);      // VZ
        
        Vector3 V3 = Vector3.unit_vector(viewVector);                                // V3 = VZ
        Vector3 V1 = Vector3.unit_vector(Vector3.cross(topVector, viewVector));      // V1 = VT cross VZ
        Vector3 V2 = Vector3.unit_vector(Vector3.cross(V3, V1));                     // V2 = V3 cross V1
        
        Matrix4 GRM = Matrix4.Identity();
        GRM.m[0] = V1.x;   GRM.m[1] = V1.y;   GRM.m[2] = V1.z;  
        GRM.m[4] = V2.x;   GRM.m[5] = V2.y;   GRM.m[6] = V2.z;  
        GRM.m[8] = V3.x;   GRM.m[9] = V3.y;   GRM.m[10] = V3.z;  
        
        
        Matrix4 mirrorX = Matrix4.Identity();
        mirrorX.m[0] = -1;
        
        
        worldView =  worldView.mult(mirrorX);
        worldView =  worldView.mult(GRM);
        worldView =  worldView.mult(Matrix4.Trans(pos.mult(-1)));
        
        //worldView = worldView.mult(mirrorX).mult(GRM).mult(Matrix4.Trans(pos.mult(-1)));
        
        /*
        System.out.println("worldView");
        printMatrix4(worldView);
        System.out.println("");
        */
    }
}


// debug用
void printMatrix4(Matrix4 m){
    System.out.println(m.m[0] + " " + m.m[1] + " " + m.m[2] + " " + m.m[3]);
    System.out.println(m.m[4] + " " + m.m[5] + " " + m.m[6] + " " + m.m[7]);
    System.out.println(m.m[8] + " " + m.m[9] + " " + m.m[10] + " " + m.m[11]);
    System.out.println(m.m[12] + " " + m.m[13] + " " + m.m[14] + " " + m.m[15]);
}

void printVector3(Vector3 v){
    System.out.println(v.x + " " + v.y + " " + v.z );
}
