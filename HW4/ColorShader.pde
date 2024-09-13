public class PhongVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }
        
        Vector4[][] result = {gl_Position,w_position,w_normal};
        
        return result;
    }
}

public class PhongFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        Vector3 w_position = (Vector3)varying[1];
        Vector3 w_normal = (Vector3)varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;
        
        
        // To - Do (HW4)
        // In this section, we have passed in all the variables you need. 
        // Please use these variables to calculate the result of Phong shading 
        // for that point and return it to GameObject for rendering
        
        // I_ambient = KaIa * Od
        Vector3 ambient = new Vector3();
        ambient.x = AMBIENT_LIGHT.x * light.light_color.x * albedo.x;
        ambient.y = AMBIENT_LIGHT.y * light.light_color.y * albedo.y;
        ambient.z = AMBIENT_LIGHT.z * light.light_color.z * albedo.z;
        
        
        // I_diffuse = KdIp (N . L) * Od
        Vector3 L = Vector3.sub(light.transform.position, w_position);
        L.normalize();
        float dot_NL = Vector3.dot(w_normal, L);
        dot_NL = max(0, dot_NL);
        Vector3 diffuse = new Vector3();
        diffuse.x = kdksm.x * light.light_color.x * dot_NL * albedo.x;
        diffuse.y = kdksm.x * light.light_color.y * dot_NL * albedo.y;
        diffuse.z = kdksm.x * light.light_color.z * dot_NL * albedo.z;
        
        // I_specular = KsIp (R . V)^m
        Vector3 V = Vector3.sub(cam.transform.position, w_position);
        V.normalize();
        Vector3 H = Vector3.add(L, V).dive(Vector3.add(L, V).norm());    // H = (L + V) / (|L + V|)
        H.normalize();
        float dot_HNm = Vector3.dot(H, w_normal);
        dot_HNm = max(0, dot_HNm);
        dot_HNm = pow(dot_HNm, kdksm.z);
        Vector3 specular = (Vector3.mult(kdksm.y, light.light_color).mult(dot_HNm));
        specular.dive(specular.norm());
        
        Vector3 phong = Vector3.add(ambient, diffuse);
        phong = Vector3.add(phong, specular);
        
        return phong.getVector4();
        //return new Vector4(0.0,0.0,0.0,1.0);
    }
}



public class FlatVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Matrix4 MVP = (Matrix4)uniform[0];
        Vector4[] gl_Position = new Vector4[3];   
        
        // To - Do (HW4)
        // Here you must complete Flat shading. 
        // We have instantiated the relevant Material, and you may be missing some variables. 
        // Please refer to the templates of Phong Material and Phong Shader to complete this part.
        
        // Note: Here the first variable must return the position of the vertex. 
        // Subsequent variables will be interpolated and passed to the fragment shader. The return value must be a Vector4.
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] w_position = new Vector4[3];
        Vector3 position = new Vector3();
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
        }
        // pick a point on a polygon to illuminate
        position = w_position[0].xyz();
        
        // find the normal of the polygon
        Vector3 normal = Vector3.cross(Vector3.sub(w_position[1].xyz(), w_position[0].xyz()), 
                                        Vector3.sub(w_position[2].xyz(), w_position[0].xyz()));
        normal.normalize();                   
        
        // illuminate the point
        Vector3 albedo = (Vector3) uniform[2];
        Vector3 kdksm = (Vector3) uniform[3];
        Light light = basic_light;
        Camera cam = main_camera;
        
        // I_ambient = KaIa * Od
        Vector3 ambient = new Vector3();
        ambient.x = AMBIENT_LIGHT.x * light.light_color.x * albedo.x;
        ambient.y = AMBIENT_LIGHT.y * light.light_color.y * albedo.y;
        ambient.z = AMBIENT_LIGHT.z * light.light_color.z * albedo.z;
        
        
        // I_diffuse = KdIp (N . L) * Od
        Vector3 L = Vector3.sub(light.transform.position, position);
        L.normalize();
        float dot_NL = Vector3.dot(normal, L);
        dot_NL = max(0, dot_NL);
        Vector3 diffuse = new Vector3();
        diffuse.x = kdksm.x * light.light_color.x * dot_NL * albedo.x;
        diffuse.y = kdksm.x * light.light_color.y * dot_NL * albedo.y;
        diffuse.z = kdksm.x * light.light_color.z * dot_NL * albedo.z;
        
        // I_specular = KsIp (R . V)^m
        Vector3 V = Vector3.sub(cam.transform.position, position);
        V.normalize();
        Vector3 H = Vector3.add(L, V).dive(Vector3.add(L, V).norm());    // H = (L + V) / (|L + V|)
        H.normalize();
        float dot_HNm = Vector3.dot(H, normal);
        dot_HNm = max(0, dot_HNm);
        dot_HNm = pow(dot_HNm, kdksm.z);
        Vector3 specular = (Vector3.mult(kdksm.y, light.light_color).mult(dot_HNm));
        specular.dive(specular.norm());
        
        Vector3 phong = Vector3.add(ambient, diffuse);
        phong = Vector3.add(phong, specular);
        
        Vector4[] light_result = new Vector4[3];  
        for(int i=0;i<gl_Position.length;i++){
            light_result[i] = phong.getVector4(1.0);
        }
        
        
        Vector4[][] result = {gl_Position, light_result};
        
        return result;
    }
}

public class FlatFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        // To - Do (HW4)
        // Here you must complete Flat shading. 
        // We have instantiated the relevant Material, and you may be missing some variables. 
        // Please refer to the templates of Phong Material and Phong Shader to complete this part.
        
        // Note : In the fragment shader, the first 'varying' variable must be its screen position. 
        // Subsequent variables will be received in order from the vertex shader. 
        // Additional variables needed will be passed by the material later.
        
        Vector4 light_result = (Vector4)varying[1];
        
        
        return light_result;
        //return new Vector4(0.0,0.0,0.0,1.0);
    }
}



// test barycentric
//colorShader
/*
public class FlatVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Matrix4 MVP = (Matrix4)uniform[0];
        Vector4[] gl_Position = new Vector4[3];   
        
        // To - Do
        
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = aVertexPosition[i].getVector4(1.0);
        }
        
        Vector4[][] result = {gl_Position,new Vector4[]{new Vector4(1,0,0,0),new Vector4(0,1,0,0),new Vector4(0,0,1,0)}};
        
        return result;
    }
}

public class FlatFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        Vector3 col = (Vector3)varying[1];
        // To - Do

        
        return new Vector4(col.x,col.y,col.z,1.0);
    }
}
*/



public class GroundVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Matrix4 MVP = (Matrix4)uniform[0];
        
        Vector4[] gl_Position = new Vector4[3];   
        
        // To - Do(HW4)
        // Here you must complete Ground shading. 
        // We have instantiated the relevant Material, and you may be missing some variables. 
        // Please refer to the templates of Phong Material and Phong Shader to complete this part.
        
        // Note: Here the first variable must return the position of the vertex. 
        // Subsequent variables will be interpolated and passed to the fragment shader. The return value must be a Vector4.
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }    
        
        
        Vector3 albedo = (Vector3) uniform[2];
        Vector3 kdksm = (Vector3) uniform[3];
        Light light = basic_light;
        Camera cam = main_camera;
        Vector4[] light_result = new Vector4[3];  
        
        // make illumination of the vertex
        for(int i=0;i<w_position.length;i++){
            // I_ambient = KaIa * Od
            Vector3 ambient = new Vector3();
            ambient.x = AMBIENT_LIGHT.x * light.light_color.x * albedo.x;
            ambient.y = AMBIENT_LIGHT.y * light.light_color.y * albedo.y;
            ambient.z = AMBIENT_LIGHT.z * light.light_color.z * albedo.z;
            
            Vector3 position = w_position[i].xyz();
            Vector3 normal = w_normal[i].xyz();
            
            // I_diffuse = KdIp (N . L) * Od
            Vector3 L = Vector3.sub(light.transform.position, position);
            L.normalize();
            float dot_NL = Vector3.dot(normal, L);
            dot_NL = max(0, dot_NL);
            Vector3 diffuse = new Vector3();
            diffuse.x = kdksm.x * light.light_color.x * dot_NL * albedo.x;
            diffuse.y = kdksm.x * light.light_color.y * dot_NL * albedo.y;
            diffuse.z = kdksm.x * light.light_color.z * dot_NL * albedo.z;
            
            // I_specular = KsIp (R . V)^m
            Vector3 V = Vector3.sub(cam.transform.position, position);
            V.normalize();
            Vector3 H = Vector3.add(L, V).dive(Vector3.add(L, V).norm());    // H = (L + V) / (|L + V|)
            H.normalize();
            float dot_HNm = Vector3.dot(H, normal);
            dot_HNm = max(0, dot_HNm);
            dot_HNm = pow(dot_HNm, kdksm.z);
            Vector3 specular = (Vector3.mult(kdksm.y, light.light_color).mult(dot_HNm));
            specular.dive(specular.norm());
            
            Vector3 phong = Vector3.add(ambient, diffuse);
            phong = Vector3.add(phong, specular);
            light_result[i] = phong.getVector4(1.0);
          
        }    

        
        Vector4[][] result = {gl_Position, light_result};
        
        return result;
    }
}

public class GroundFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
                
        // To - Do (HW4)
        // Here you must complete Ground shading. 
        // We have instantiated the relevant Material, and you may be missing some variables. 
        // Please refer to the templates of Phong Material and Phong Shader to complete this part.
        
        // Note : In the fragment shader, the first 'varying' variable must be its screen position. 
        // Subsequent variables will be received in order from the vertex shader. 
        // Additional variables needed will be passed by the material later.
        
        Vector4 light_result = (Vector4)varying[1];
        
        return light_result;
        //return new Vector4(0.0,0.0,0.0,1.0);
    }
}
