package trafficLight.model;

import java.awt.Color;
import java.awt.Graphics;

public class TrafficLight {
	private Color state;
	private final String name;
	private int x;
	private int y;
	private int width;
	private int height;
	private int xinc;
	private int yinc;

	public TrafficLight(String name, Color state) {
		this.name = name;
		this.state = state;
		if (name.startsWith("North")) {
			x = 300;
			y = 30;
			width = 30;
			height = 80;
			xinc = 0;
			yinc = 25;
		} else {
			x = 50;
			y = 200;
			width = 80;
			height = 30;
			yinc = 0;
			xinc = 25;
		}
	}

	public String getName() {
		return this.name;

	}
	public Color getState() {
		return this.state;
	}

	public void setState(Color state) {
		this.state = state;
	}

	public void draw(Graphics g,Boolean sensor) {
		g.setColor(Color.GRAY);
		g.fill3DRect(x - 5, y - 5, width, height, true);
		if (sensor){
			g.drawRect(x-20, y, 10, 10);
		}
		g.setColor(state == Color.RED ? state : Color.BLACK);
		g.fillOval(x, y, 20, 20); // First Light
		g.setColor(state == Color.YELLOW ? state : Color.BLACK);
		g.fillOval(x + xinc, y + yinc, 20, 20); // Second Light
		g.setColor(state == Color.GREEN ? state : Color.BLACK);
		g.fillOval(x + 2 * xinc, y + 2 * yinc, 20, 20); // Third Light

	}
}
