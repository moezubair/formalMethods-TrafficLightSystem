import java.awt.Color;
import java.awt.Graphics;
import java.util.Random;

import trafficLight.model.PedestrianLight;
import trafficLight.model.TrafficLight;

public class Intersection {
	private TrafficLight NS;
	private PedestrianLight NSPed;
	private TrafficLight EW;
	private PedestrianLight EWPed;
	private Boolean NSVeh;
	private Boolean EWVeh;
	private Random randomno;

	Intersection() {
		/*
		 * INIT State on TLA SPECS
		 */
		NS = (new TrafficLight("North-South", Color.RED));
		EW = new TrafficLight("East-West", Color.RED);
		NSPed = (new PedestrianLight("North-South", Color.RED, false));
		EWPed = new PedestrianLight("East-West", Color.RED, false);
		NSVeh = false;
		EWVeh = false;
		randomno = new Random();

	}

	public void setNS(Color c) {
		if (c == Color.RED) {
			this.NS.setState(c);
			this.EW.setState(Color.GREEN);
			return;
		}
		/*
		 * Safety Property, Both lights can't have the same state except for red
		 */
		if (c != EW.getState()) {

			this.NS.setState(c);
		}
	}

	public Color getNS() {
		return this.NS.getState();
	}

	public void setEW(Color c) {
		if (c == Color.RED) {
			this.EW.setState(c);
			this.NS.setState(Color.GREEN);
			return;
		}
		/*
		 * Safety Property, Both lights can't have the same state except for red
		 */
		if (c != NS.getState()) {

			this.EW.setState(c);
		}

	}

	public Color getEW() {
		return this.EW.getState();
	}

	public Boolean getNSVeh() {
		return NSVeh;
	}

	public void setNSVeh(Boolean nSVeh) {
		NSVeh = nSVeh;
	}

	public Boolean getEWVeh() {
		return EWVeh;
	}

	public void setEWVeh(Boolean eWVeh) {
		EWVeh = eWVeh;
	}

	public void start() {
		this.setNS(Color.GREEN);
	}

	public void compute() {
		if (NS.getState() == Color.YELLOW) {
			NS.setState(Color.RED);
		}
		if (EW.getState() == Color.YELLOW) {
			EW.setState(Color.RED);
		}
		if (NS.getState() == Color.RED && EWVeh) {
			EW.setState(Color.GREEN);
			setEWVeh(false);
		}
		if (EW.getState() == Color.RED && NSVeh) {
			NS.setState(Color.GREEN);
			setNSVeh(false);
		}
		if (!EWVeh) {
			setEWVeh(randomno.nextBoolean());
		} else {
			if (NS.getState() == Color.GREEN && EW.getState() == Color.RED) {
				NS.setState(Color.YELLOW);
				return;
			}
		}
		if (!NSVeh) {
			setNSVeh(randomno.nextBoolean());
		} else {
			if (EW.getState() == Color.GREEN && NS.getState() == Color.RED) {
				System.out.println("NS Vehical Detected. Changing EW from Green to Yellow");
				EW.setState(Color.YELLOW);
				return;
			}
		}
	}

	public void draw(Graphics g) {
		// Background
		this.NS.draw(g, NSVeh);
		this.EW.draw(g, EWVeh);
	}

}
