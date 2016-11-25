package tcs;

import java.awt.*;
import java.applet.*;
import java.awt.event.*;

/*<applet code=”Traffic” width=700 height=600>
</applet>*/

public class TrafficLights extends Applet implements Runnable

{
	
	Font myFont = new Font("TimesRoman", Font.BOLD, 24);
	
	Thread t;
	
	int i=0;
	
	int lightFlagNS = 0; //identifies light colour NS
	int lightFlagEW = 0; //identifies light colour EW
	
	int pedFlagNS = 1; //identifies pedestrian light colour NS
	int pedFlagEW = 1; //identifies pedestrian light colour EW
	boolean pedNS = false; //is there a pedestrian waiting in NS
	boolean pedEW = false; //is there a pedestrian waiting in EW
	double randPedNS;
	double randPedEW;
	
	boolean trafficNS = true; //is there traffic along NS
	boolean trafficEW = false; //is there traffic along EW
	double randTrafficNS;
	double randTrafficEW;
	
	public void start(){
		t = new Thread(this);
		t.start();
	}
	
	public void run(){
		
		//COUNTDOWN TIMER
		for(i=8;i>=0;i--){
			
			randPedNS = Math.random(); // Generating a random pedestrian NS
			randPedEW = Math.random(); // Generating a random pedestrian EW
			
			randTrafficNS = Math.random(); // Generating a random Traffic NS
			randTrafficEW = Math.random(); // Generating a random Traffic EW
			
			if(randTrafficNS < 0.3){
				
				trafficNS = true;				
			
			} 
			
			if(randTrafficEW < 0.1){
				
				trafficEW = true;				
			
			} 
			
			if(randPedNS < 0.05){
				
				pedNS = true;				
			}
			
			if(randPedEW < 0.05){
				
				pedEW = true;				
			}
			
			System.out.println(randPedNS+" "+randPedEW);
			try	{
				
				Thread.sleep(1000);
			}
			catch(Exception e){
				
				System.out.println(e);
			}
			
			if(i<=8 && i>4){//NS--red, EW--green or yellow
				
				if(pedEW == true && i>6){ //pedestrian EW green
					
					pedFlagEW = 3;
					
				} else if(pedEW==true && pedFlagEW==3 && i==6){ //pedestrian EW yellow
					
					pedFlagEW = 2;
					pedEW = false;
				
				} else{
					
					pedFlagEW = 1; //pedestrian EW red
				}
				
				if(i==6 && trafficNS==false && pedNS==false){//keep EW green if trafficNS is false
					
					i=7;
				}
				
				if(i<7){ //Green-Yellow EW
					
					lightFlagNS=1;	//traffic NS red
					lightFlagEW=2; //traffic EW yellow
					trafficEW=false;
					
				} else { //EW-Green NS-RED 					
					
					lightFlagNS=1;	//traffic NS red
					lightFlagEW=3;	//traffic EW green
				}
				
				repaint();
				
			} else if(i<=4 && i>0){//EW--red, NS--green or yellow
				
				if(pedNS == true && i>2){ //pedestrian NS green
					
					pedFlagNS = 3;
					
				} else if(pedNS==true && pedFlagNS==3 && i==2){ //pedestrian NS yellow
					
					pedFlagNS = 2;
					pedNS=false;
				
				} else{
					
					pedFlagNS = 1; //pedestrian NS red
				}
				
				if(i==2 && trafficEW==false && pedEW==false){ //keep NS green if trafficEW is false
					
					i=3;
				}
				
				if(i<3){ //Green-Yellow NS
					
					lightFlagEW=1;   //traffic EW red
					lightFlagNS=2; //traffic NS yellow
					trafficNS=false;
				
				} else{ //NS-Green EW-RED
					
					lightFlagEW=1;   //traffic EW red
					lightFlagNS=3;   //traffic NS green
				}
				
				repaint();				
			
			} else if(i==0){
				
				run();
				break;
				
			}			
		}
	
	}
	
	public void paint(Graphics g){
		
		g.setFont(myFont);
		//NORTH-SOUTH Traffic Lights
		g.setColor(Color.black);//pole top
		g.drawString("SUCH LIGHTS, MUCH TRAFFIC, WOW!",650,50);
		g.drawString("NORTH-SOUTH",650,125);
		g.fillRect(650,150,50,150);
		g.drawRect(650,150,50,150);
		g.setColor(Color.black);//POLE UP
		g.fillRect(650,150,50,150);
		g.drawRect(650,150,50,150);
		g.setColor(Color.black);//POLE DOWN
		g.fillRect(665,300,20,155);
		g.drawRect(665,300,20,155);
		g.drawOval(650,150,50,50);//RED
		g.drawOval(650,200,50,50);//YELLOW
		g.drawOval(650,250,50,50);//GREEN
		g.setColor(Color.red);//COUNTDOWN STOP
		g.drawString(""+i,300,300);
		
		//NORTH-SOUTH Pedestrian Lights
		g.setColor(Color.black);//pole top
		g.fillRect(750,150,30,150);
		g.drawRect(750,150,30,150);
		g.setColor(Color.black);//POLE UP
		g.fillRect(750,150,30,150);
		g.drawRect(750,150,30,150);
		g.setColor(Color.black);//POLE DOWN
		g.fillRect(765,300,15,155);
		g.drawRect(765,300,15,155);
		g.drawOval(750,150,30,30);//RED
		g.drawOval(750,200,30,30);//YELLOW
		g.drawOval(750,250,30,30);//GREEN
						
		
		//EAST-WEST Traffic Lights
		g.setColor(Color.black);//pole top
		g.drawString("EAST-WEST",2,675);
		g.fillRect(150,650,150,50);
		g.drawRect(150,650,150,50);
		g.setColor(Color.black);//POLE UP
		g.fillRect(150,650,150,50);
		g.drawRect(150,650,150,50);
		g.setColor(Color.black);//POLE DOWN
		g.fillRect(300,665,155,20);
		g.drawRect(300,665,155,20);
		g.drawOval(150,650,50,50);//RED
		g.drawOval(200,650,50,50);//YELLOW
		g.drawOval(250,650,50,50);//GREEN
		g.setColor(Color.red);//COUNTDOWN STOP
		
		
		//EAST-WEST Pedestrian Lights
		g.setColor(Color.black);//pole top
		g.fillRect(150,750,150,30);
		g.drawRect(150,750,150,30);
		g.setColor(Color.black);//POLE UP
		g.fillRect(150,750,150,30);
		g.drawRect(150,750,150,30);
		g.setColor(Color.black);//POLE DOWN
		g.fillRect(300,765,155,15);
		g.drawRect(300,765,155,15);
		g.drawOval(150,750,30,30);//RED
		g.drawOval(200,750,30,30);//YELLOW
		g.drawOval(250,750,30,30);//GREEN
		
		if(pedNS == true){			

			g.setColor(Color.black);
			g.drawOval(720,150,30,30);
			g.fillOval(720,150,30,30);
		}
		
		if(pedEW == true){
			
			g.setColor(Color.black);
			g.drawOval(150,720,30,30);
			g.fillOval(150,720,30,30);
		}
		
		if(trafficNS == true){ //IS THERE TRAFFIC IN NORTH-SOUTH DIRECTION			

			g.setColor(Color.black);
			g.drawRect(580,140,20,30);	
			g.fillRect(580,140,20,30);
			g.drawRect(600,120,20,70);	
			g.fillRect(600,120,20,70);
			g.drawRect(600,120,20,70);	
			g.fillRect(600,120,20,70);
			g.drawOval(620,160,20,20);
			g.fillOval(620,160,20,20);
			g.drawOval(620,130,20,20);
			g.fillOval(620,130,20,20);
		}
		
		if(trafficEW == true){ //IS THERE TRAFFIC IN EAST-WEST DIRECTION
			
			g.setColor(Color.black);
			g.drawRect(140,580,30,20);	
			g.fillRect(140,580,30,20);
			g.drawRect(120,600,70,20);	
			g.fillRect(120,600,70,20);
			g.drawRect(120,600,70,20);	
			g.fillRect(120,600,70,20);
			g.drawOval(160,620,20,20);
			g.fillOval(160,620,20,20);
			g.drawOval(130,620,20,20);
			g.fillOval(130,620,20,20);
		}
		
		if(lightFlagNS==1){//RED--NS		
			//NORTH-SOUTH
			g.setColor(Color.red);
			g.fillOval(650,150,50,50);
			g.drawOval(650,150,50,50);
			g.drawString("STOP",500,150);
		}
		
		if(lightFlagEW==1){//RED--EW
			//EAST-WEST
			g.setColor(Color.red);
			g.fillOval(150,650,50,50);
			g.drawOval(150,650,50,50);
			g.drawString("STOP",150,550);			
		}
		
		if(pedFlagNS==1){//RED--NS Pedestrian	
			//NORTH-SOUTH
			g.setColor(Color.red);
			g.fillOval(750,150,30,30);
			g.drawOval(750,150,30,30);
		}
		
		if(pedFlagEW==1){//RED--EW Pedestrian
			//EAST-WEST
			g.setColor(Color.red);
			g.fillOval(150,750,30,30);
			g.drawOval(150,750,30,30);			
		}
		
		if(lightFlagNS==3){//GREEN--NS		
			//NORTH-SOUTH
			g.setColor(Color.blue);
			g.drawString("GO",500,150);			
			g.setColor(Color.green);
			g.fillOval(650,250,50,50);
			g.drawOval(650,250,50,50);
		}
		
		if(lightFlagEW==3){ //GREEN--EW
			//EAST-WEST
			g.setColor(Color.blue);
			g.drawString("GO",150,550);
			g.setColor(Color.green);
			g.fillOval(250,650,50,50);
			g.drawOval(250,650,50,50);			
		}
		
		if(pedFlagNS==3){//GREEN--NS Pedestrian	
			//NORTH-SOUTH		
			g.setColor(Color.green);
			g.fillOval(750,250,30,30);
			g.drawOval(750,250,30,30);
		}
		
		if(pedFlagEW==3){ //GREEN--EW Pedestrian
			//EAST-WEST
			g.setColor(Color.green);
			g.fillOval(250,750,30,30);
			g.drawOval(250,750,30,30);			
		}
		
		if(lightFlagNS==2){//YELLOW-NS
			//NORTH-SOUTH
			g.setColor(Color.yellow);
			g.fillOval(650,200,50,50);
			g.drawOval(650,200,50,50);
		}
		
		if(lightFlagEW==2){//YELLOW-EW
			//EAST-WEST
			g.setColor(Color.yellow);
			g.fillOval(200,650,50,50);
			g.drawOval(200,650,50,50);	
		}	
		
		if(pedFlagNS==2){//YELLOW-NS Pedestrian
			//NORTH-SOUTH
			g.setColor(Color.yellow);
			g.fillOval(750,200,30,30);
			g.drawOval(750,200,30,30);
		}
		
		if(pedFlagEW==2){//YELLOW-EW Pedestrian
			//EAST-WEST
			g.setColor(Color.yellow);
			g.fillOval(200,750,30,30);
			g.drawOval(200,750,30,30);	
		}	
		
	}
}