ShapeButton lineButton;
ShapeButton circleButton;
ShapeButton polygonButton;
ShapeButton ellipseButton;
ShapeButton curveButton;
ShapeButton pencilButton;
ShapeButton eraserButton;
ShapeButton triangleButton;
ShapeButton starButton;

Button clearButton;
Button redButton;
Button orangeButton;
Button yellowButton;
Button greenButton;
Button cyanButton;
Button blueButton;
Button magentaButton;
Button blackButton;
Button grayButton;
Button whiteButton;

ShapeRenderer shapeRenderer;
ArrayList<ShapeButton> shapeButton;
float eraserSize = 20;
color current_color = color(0, 0, 0);

public void setup(){
    size(1000,800);
    background(255);
    shapeRenderer = new ShapeRenderer();
    initButton();
    
}

public void draw(){

    background(255);
    for(ShapeButton sb:shapeButton){
        sb.run( () -> {
            sb.beSelect();
            shapeRenderer.setRenderer(sb.getRendererType());
        });
    }  
    
    clearButton.run(()->{shapeRenderer.clear();});
    redButton.run(()->{changeCurrentColor(color(255, 0, 0));});
    orangeButton.run(()->{changeCurrentColor(color(255, 127, 0));});
    yellowButton.run(()->{changeCurrentColor(color(255, 255, 0));});
    greenButton.run(()->{changeCurrentColor(color(0, 255, 0));});
    cyanButton.run(()->{changeCurrentColor(color(0, 255, 255));});
    blueButton.run(()->{changeCurrentColor(color(0, 0, 255));});
    magentaButton.run(()->{changeCurrentColor(color(255, 0, 255));});
    blackButton.run(()->{changeCurrentColor(color(0, 0, 0));});
    grayButton.run(()->{changeCurrentColor(color(127, 127, 127));});
    whiteButton.run(()->{changeCurrentColor(color(255, 255, 255));});
    
    shapeRenderer.box.show();

    shapeRenderer.run();
   
    
}

void resetButton(){
  for(ShapeButton sb:shapeButton){
    sb.setSelected(false);
  }
}

public void initButton(){
  shapeButton = new ArrayList<ShapeButton>();
  lineButton = new ShapeButton(10,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          line(pos.x+2,pos.y+2,pos.x+size.x-2,pos.y+size.y-2);
      }      
      @Override
      public Renderer getRendererType(){
          return new LineRenderer();
      }
  };
  
  lineButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(lineButton);
  
  circleButton = new ShapeButton(45,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          circle(pos.x+size.x/2,pos.y+size.y/2,size.x-2);
      }
      @Override
      public Renderer getRendererType(){
          return new CircleRenderer();
      }
  };
  circleButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(circleButton);
  
  polygonButton = new ShapeButton(80,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          line(pos.x+2,pos.y+2,pos.x+size.x-2,pos.y+2);
          line(pos.x+2,pos.y+size.y-2,pos.x+size.x-2,pos.y+size.y-2);
          line(pos.x+size.x-2,pos.y+2,pos.x+size.x-2,pos.y+size.y-2);
          line(pos.x+2 ,pos.y+2,pos.x + 2,pos.y+size.y-2);          
      }
      @Override
      public Renderer getRendererType(){
          return new PolygonRenderer();
      }
      
  };
  
  polygonButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(polygonButton);
  
  
  ellipseButton = new ShapeButton(115,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          ellipse(pos.x+size.x/2,pos.y+size.y/2,size.x-2,size.y*2/3);      
      }
      @Override
      public Renderer getRendererType(){
          return new EllipseRenderer();
      }
      
  };
  
  ellipseButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(ellipseButton);
  
  curveButton = new ShapeButton(150,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          bezier(pos.x,pos.y,pos.x,pos.y+size.y,pos.x+size.x,pos.y,pos.x+size.x,pos.y+size.y);      
      }
      @Override
      public Renderer getRendererType(){
          return new CurveRenderer();
      }
      
  };
  
  curveButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(curveButton);
  
  clearButton = new Button(width-50,10,30,30);
  clearButton.setBoxAndClickColor(color(250),color(150));
  clearButton.setImage(loadImage("clear.png"));
  
  pencilButton = new ShapeButton(185,10,30,30){
      @Override
      public Renderer getRendererType(){
          return new PencilRenderer();
      }    
  };
  pencilButton.setImage(loadImage("pencil.png"));
  
  pencilButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(pencilButton);
  
  eraserButton = new ShapeButton(220,10,30,30){
      @Override
      public Renderer getRendererType(){
          return new EraserRenderer();
      }    
  };
  eraserButton.setImage(loadImage("eraser.png"));
  
  eraserButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(eraserButton);
  
  // new
  triangleButton = new ShapeButton(290,10,30,30){
      @Override
      public void show(){
          super.show();
          stroke(0);
          triangle(pos.x, pos.y+size.y, pos.x+(size.x/2), pos.y, pos.x+size.x, pos.y+size.y);      
      }
      @Override
      public Renderer getRendererType(){
          return new TriangleRenderer();
      }
      
  };
  
  triangleButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(triangleButton);


  starButton = new ShapeButton(325,10,30,30){
      @Override
      public Renderer getRendererType(){
          return new StarRenderer();
      }
  };
  starButton.setImage(loadImage("star.png"));
  
  starButton.setBoxAndClickColor(color(250),color(150));
  shapeButton.add(starButton);
  
  redButton = new Button(395,10,30,30);
  redButton.setBoxAndClickColor(color(250),color(150));
  redButton.setImage(loadImage("red.png"));
  
  orangeButton = new Button(430,10,30,30);
  orangeButton.setBoxAndClickColor(color(250),color(150));
  orangeButton.setImage(loadImage("orange.png"));
  
  yellowButton = new Button(465,10,30,30);
  yellowButton.setBoxAndClickColor(color(250),color(150));
  yellowButton.setImage(loadImage("yellow.png"));
  
  greenButton = new Button(500,10,30,30);
  greenButton.setBoxAndClickColor(color(250),color(150));
  greenButton.setImage(loadImage("green.png"));
  
  cyanButton = new Button(535,10,30,30);
  cyanButton.setBoxAndClickColor(color(250),color(150));
  cyanButton.setImage(loadImage("cyan.png"));
  
  
  blueButton = new Button(570,10,30,30);
  blueButton.setBoxAndClickColor(color(250),color(150));
  blueButton.setImage(loadImage("blue.png"));
  
  magentaButton = new Button(605,10,30,30);
  magentaButton.setBoxAndClickColor(color(250),color(150));
  magentaButton.setImage(loadImage("magenta.png"));
  
  blackButton = new Button(640,10,30,30);
  blackButton.setBoxAndClickColor(color(250),color(150));
  blackButton.setImage(loadImage("black.png"));
  
  grayButton = new Button(675,10,30,30);
  grayButton.setBoxAndClickColor(color(250),color(150));
  grayButton.setImage(loadImage("gray.png"));
  
  whiteButton = new Button(710,10,30,30);
  whiteButton.setBoxAndClickColor(color(250),color(150));
  whiteButton.setImage(loadImage("white.png"));
}




public void keyPressed(){
    if(key=='z'||key=='Z'){
        shapeRenderer.popShape();
    }

}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e < 0) eraserSize += 1;
  else if(e > 0) eraserSize -= 1;
  eraserSize  = max(min(eraserSize,30),4);
}

void changeCurrentColor(color c){
    current_color = c;
}
