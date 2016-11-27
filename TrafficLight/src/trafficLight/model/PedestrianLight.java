package trafficLight.model;

import java.awt.Color;
import java.awt.Graphics;

public class PedestrianLight {
	private Color state;
	private Boolean button_pressed;
	private final String name;
	private int x;
	private int y;
	private int width;
	private int height;
	private int xinc;
	private int yinc;

	/**
	 * Constructor. Initializes the variables, and sets up the geometric
	 * parameters for NS and EW lights
	 * 
	 * @param name
	 *            East-West or North-South
	 * @param state
	 *            Current state of the light
	 * @param button
	 *            Current state of the button to cross
	 */
	public PedestrianLight(String name, Color state, Boolean button) {
		this.name = name;
		this.state = state;
		this.button_pressed = button;
		if (name.startsWith("North")) {
			x = 350;
			y = 40;
			width = 20;
			height = 50;
			xinc = 0;
			yinc = 15;
		} else {
			x = 50;
			y = 250;
			width = 60;
			height = 20;
			yinc = 0;
			xinc = 15;
		}
	}

	/**
	 * 
	 * @return Name of PedestrianLight
	 */
	public String getName() {
		return this.name;

	}

	/**
	 * 
	 * @return true if button is pressed, false otherwise
	 */
	public Boolean getButton() {
		return this.button_pressed;
	}

	/**
	 * 
	 * @param button_state
	 *            Set the button state
	 */
	public void setButton(Boolean button_state) {
		this.button_pressed = button_state;
	}

	/**
	 * 
	 * @return Return the light state
	 */
	public Color getState() {
		return this.state;
	}

	/**
	 * 
	 * @param c
	 *            Set the light state
	 */
	public void setState(Color c) {
		this.state = c;
	}

	/**
	 * 
	 * @param g
	 *            Draw the graphics
	 */
	public void draw(Graphics g) {
		g.setColor(Color.BLACK);
		g.draw3DRect(x - 5, y - 5, width, height, true);
		g.setColor(button_pressed ? Color.GRAY.darker() : Color.GRAY.brighter());

		g.fill3DRect(x + 3 * xinc, y + 3 * yinc, 20, 20, true);
		g.setColor(state == Color.RED ? state : Color.BLACK);
		g.fillOval(x, y, 10, 10); // First Light
		g.setColor(state == Color.YELLOW ? state : Color.BLACK);
		g.fillOval(x + xinc, y + yinc, 10, 10); // Second Light
		g.setColor(state == Color.GREEN ? state : Color.BLACK);
		g.fillOval(x + 2 * xinc, y + 2 * yinc, 10, 10); // Third Light

	}
}
