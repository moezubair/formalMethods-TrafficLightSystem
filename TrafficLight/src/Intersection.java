package trafficLight;

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

	public Intersection() {
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

	public Color getNSPed() {
		return this.NSPed.getState();
	}

	public void setNSPed(Color c) {
		/*
		 * Safety Property, Both lights can't have the same state except for red
		 */
		if (c != NSPed.getState()) {

			this.EWPed.setState(c);
		}

	}

	public void setEW(Color c) {

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

	public void loopPed(PedestrianLight ped) {
		if (ped.getState() == Color.GREEN) {
			ped.setState(Color.YELLOW);
		} else if (ped.getState() == Color.YELLOW) {
			ped.setState(Color.RED);
		}
	}

	/*
	 * Compute method represents the Liveness property. It simulates the sensors
	 * picking up vehicles by using random number library. If a vehicle is
	 * detected on opposite side of the green light, it changes that side to
	 * yellow The lights cycle from RED->GREEN->YELLOW
	 */
	public int compute() {
		/* Pedestrian Lights must loop through if green */
		if (NSPed.getState() != Color.RED) {
			loopPed(NSPed);
			return 0;
		} else if (EWPed.getState() != Color.RED) {
			loopPed(EWPed);
			return 0;
		}
		/* Randomly generated sensors */
		if (!EWVeh) {
			setEWVeh(randomno.nextBoolean());
		}
		if (!NSVeh) {
			setNSVeh(randomno.nextBoolean() == true);
		}
		if (!EWPed.getButton()) {
			if (randomno.nextInt(2) == 1) {
				EWPed.setButton(randomno.nextBoolean());
			}
		}
		if (!NSPed.getButton()) {
			NSPed.setButton(randomno.nextBoolean());
		}
		if (NS.getState() == Color.YELLOW) { /* In TLA Yellow leads to Red */
			NS.setState(Color.RED);
			EW.setState(Color.GREEN);
			if (EWPed.getButton()) {
				EWPed.setState(Color.GREEN);
				EWPed.setButton(false);
			}
			System.out.println("Changing NS from Yellow to RED");
			System.out.println("Changing EW from Red to Green");
			return 1;

		} else if (EW
				.getState() == Color.YELLOW) { /* In TLA Yellow leads to Red */
			EW.setState(Color.RED);
			NS.setState(Color.GREEN);
			if (NSPed.getButton()) {
				NSPed.setState(Color.GREEN);
				NSPed.setButton(false);
			}
			System.out.println("Changing EW from Yellow to RED");
			System.out.println("Changing NS from Red to Green");
			return 1;
		}
		if (EWVeh && NS.getState() == Color.GREEN && EW.getState() == Color.RED) {//In TLA Green leads to Yellow
			System.out.println("Changing NS to Yellow");
			NSVeh = false;
			NS.setState(Color.YELLOW);

		} else if (NSVeh && EW.getState() == Color.GREEN && NS.getState() == Color.RED) {//In Green Read leads to Yellow
			System.out.println("Changing EW to Yellow");
			EWVeh = false;
			EW.setState(Color.YELLOW);

		}
		return 0;

	}

	public void draw(Graphics g) {
		// Background
		this.NS.draw(g, NSVeh);
		this.EW.draw(g, EWVeh);
		this.NSPed.draw(g);
		this.EWPed.draw(g);
	}

}
