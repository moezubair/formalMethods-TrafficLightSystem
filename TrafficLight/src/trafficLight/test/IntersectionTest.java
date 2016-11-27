package trafficLight.test;

import java.awt.Color;

import org.junit.Test;

import junit.framework.TestCase;
import trafficLight.Intersection;

public class IntersectionTest extends TestCase {
	private Intersection intersection;

	@Override
	public void setUp() throws Exception {
		intersection = new Intersection();
	}

	@Test
	public void testInitialState() {
		assertTrue(intersection.getEW() == Color.RED);
		assertTrue(intersection.getNS() == Color.RED);
	}

	@Test
	public void testSafety() {
		intersection.start();
		assertTrue(intersection.getEW() != intersection.getNS());
	}

	@Test
	public void testLiveness() {
		intersection.start();
		intersection.compute();

		assertFalse(intersection.getEW() == intersection.getNS());

		if (intersection.getEW() == Color.YELLOW) {
			intersection.compute();
			assertTrue(intersection.getEW() == Color.RED);
		} else if (intersection.getNS() == Color.YELLOW) {
			intersection.compute();
			assertTrue(intersection.getNS() == Color.RED);
		} else if (intersection.getEW() == Color.GREEN && intersection.getNSVeh()) {
			intersection.compute();
			assertTrue(intersection.getEW() == Color.YELLOW);
		} else if (intersection.getNS() == Color.GREEN && intersection.getEWVeh()) {
			intersection.compute();
			assertTrue(intersection.getNS() == Color.YELLOW);
		}
	}

	@Test
	public void testSensors() {
		intersection.start();
		intersection.compute();

		if (intersection.getEWVeh()) {
			while (intersection.compute() != 2) {
			}
			assertFalse(intersection.getEWVeh());
		}
		if (intersection.getNSVeh()) {
			while (intersection.compute() != 2) {
			}
			assertFalse(intersection.getNSVeh());
		}
	}

}
