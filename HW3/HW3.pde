import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;


void setup(){
   size(1000,600);
   renderer_size = new Vector4(20,50,520,550);
   cam_position = new Vector3(0,-5,-5);
   lookat = new Vector3(0,0,0);
   setDepthBuffer();   
   main_camera = new Camera();
   engine = new Engine(); 
     
}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw(){
    background(255);
    
    engine.run();
    
}

String selectFile(){
    JFileChooser fileChooser = new JFileChooser();      
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}


void cameraControl(){
    // To - Do 
    // You can write your own camera control function here.
    // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
    // Hint : Use keyboard event and mouse click event to change the position of the camera.
    
    //cam_position = new Vector3(0,-5,-5);
    //lookat = new Vector3(0,0,0);
    printVector3(cam_position);
    main_camera.setPositionOrientation(cam_position, lookat);
}


void mouseWheel(MouseEvent event) {
    Vector3 viewVector = Vector3.sub(lookat, cam_position);
    float e = event.getCount();
    if(e < 0){ 
        cam_position = cam_position.add(viewVector.mult(0.1));
    }
    else if(e > 0){ 
        cam_position = cam_position.sub(viewVector.mult(0.1));
    }
    //cam_position.z  = max(min(cam_position.z, 0), -30);
    main_camera.setPositionOrientation(cam_position, lookat);
}


void keyPressed(){
    Vector3 viewVector = lookat.sub(cam_position).unit_vector();
    Vector3 topVector = new Vector3(0, 1, 0);
    Vector3 sideVector = Vector3.cross(viewVector, topVector).unit_vector();
    Vector3 upVector = Vector3.cross(viewVector, sideVector).unit_vector();
    
    if (key == 'w' || key == 'W') {
        cam_position = cam_position.add(upVector.mult(0.1));
        lookat = lookat.add(upVector.mult(0.1));
    } 
    else if (key == 's' || key == 'S') {
        cam_position = cam_position.sub(upVector.mult(0.1));
        lookat = lookat.sub(upVector.mult(0.1));
    }
    else if (key == 'a' || key == 'A') {
        cam_position = cam_position.sub(sideVector.mult(0.1));
        lookat = lookat.sub(sideVector.mult(0.1));
    } 
    else if (key == 'd' || key == 'D') {
        cam_position = cam_position.add(sideVector.mult(0.1));
        lookat = lookat.add(sideVector.mult(0.1));
    }
    else if (key == 'q' || key == 'Q') {
        Matrix4 r = Matrix4.Identity();
        r = r.mult(Matrix4.RotY(radians(-1)));
        Vector4 cam = cam_position.getVector4();
        cam = cam.mult(r);
        cam_position = cam.xyz();
    }
    else if (key == 'e' || key == 'E') {
        Matrix4 r = Matrix4.Identity();
        r = r.mult(Matrix4.RotY(radians(1)));
        Vector4 cam = cam_position.getVector4();
        cam = cam.mult(r);
        cam_position = cam.xyz();
    }
    else if (key == 'r' || key == 'R') {
       cam_position = new Vector3(0,-5,-5);
       lookat = new Vector3(0,0,0);
    }
    //printVector3(cam_position);
    main_camera.setPositionOrientation(cam_position, lookat);
}
