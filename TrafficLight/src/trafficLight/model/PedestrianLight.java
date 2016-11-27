package trafficLight.model;

import java.awt.Color;

public class PedestrianLight {
	private Color state;
	private Boolean button_pressed;
	private final String name;

	public PedestrianLight(String name, Color state, Boolean button) {
		this.name = name;
		this.state = state;
		this.button_pressed = button;
	}

	public String getName() {
		return this.name;

	}

	public Boolean getButton() {
		return this.button_pressed;
	}

	public void setButton(Boolean button_state) {
		this.button_pressed = button_state;
	}

	public Color getState() {
		return this.state;
	}
}