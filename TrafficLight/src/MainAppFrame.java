import java.applet.Applet;
import java.awt.Color;
import java.awt.Graphics;

@SuppressWarnings("serial")
public class MainAppFrame extends Applet {

	private Intersection intersection;

	/**
	 * Launch the application.
	 */

	public void start() {
		intersection = new Intersection();
		intersection.start();
		System.out.println("Inside Start");
		new Thread(new Runnable() {
			public void run() {
				for (;;) {
					try {
							
							Thread.sleep(2000);
						
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					repaint();

				}
			}
		}).start();

	}

	public void paint(Graphics g) {
		this.setSize(500, 500);
		super.paint(g);
		intersection.draw(g);
		intersection.compute();

		// run();

	}

}
