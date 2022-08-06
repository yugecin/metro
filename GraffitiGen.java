package net.basdon.shaderthing2;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Point2D;
import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.JPanel;

import static java.lang.Math.*;

public class GraffitiGen extends JPanel implements KeyListener, MouseListener,
	MouseMotionListener
{
	public static void main(String[] args)
	{
		JFrame frame = new JFrame();

		GraffitiGen panel = new GraffitiGen();

		frame.getContentPane().setLayout(new BorderLayout());
		frame.getContentPane().add(panel, BorderLayout.NORTH);
		frame.pack();
		frame.setVisible(true);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	static class Bezi {
		public Point a = new Point();
		public Point p = new Point();
		public Point q = new Point();
		public Point b = new Point();
	}
	static class Bezf {
		public Point2D.Float a = new Point2D.Float();
		public Point2D.Float p = new Point2D.Float();
		public Point2D.Float q = new Point2D.Float();
		public Point2D.Float b = new Point2D.Float();
	}

	static final int NUB = 6, N = NUB + 1, M = NUB * 2 + 1;

	Bezi c = new Bezi();
	ArrayList<Bezf> lines = new ArrayList<>();
	Point2D.Float dragging;

	public GraffitiGen()
	{
		Dimension dim = new Dimension(1600, 900);
		this.setMinimumSize(dim);
		this.setPreferredSize(dim);
		this.setMaximumSize(dim);
		this.addKeyListener(this);
		this.addMouseListener(this);
		this.addMouseMotionListener(this);
		this.setFocusable(true);
	}

	@Override
	protected void paintComponent(Graphics g)
	{
		g.setColor(Color.black);
		g.fillRect(0, 0, 1600, 900);
		g.setColor(Color.yellow);
		g.drawRect(400, 225, 800, 450);
		for (Bezf bez : this.lines) {
			convert(bez, c);
			g.setColor(Color.white);
			for (float a = 0; a < 1; a += 0.02) {
				float b = 1f - a;
				float x = b*b*b*c.a.x+3f*b*b*a*c.p.x+3f*b*a*a*c.q.x+a*a*a*c.b.x;
				float y = b*b*b*c.a.y+3f*b*b*a*c.p.y+3f*b*a*a*c.q.y+a*a*a*c.b.y;
				g.fillOval((int) x - 10, (int) y - 10, 20, 20);
			}
			g.setColor(Color.magenta);
			g.fillRect(c.a.x - NUB, c.a.y - NUB, M, M);
			g.fillRect(c.b.x - NUB, c.b.y - NUB, M, M);
			g.setColor(Color.cyan);
			g.fillRect(c.p.x - NUB, c.p.y - NUB, M, M);
			g.fillRect(c.q.x - NUB, c.q.y - NUB, M, M);
			g.setColor(Color.gray);
			g.drawLine(c.a.x, c.a.y, c.p.x, c.p.y);
			g.drawLine(c.p.x, c.p.y, c.q.x, c.q.y);
			g.drawLine(c.q.x, c.q.y, c.b.x, c.b.y);
		}
	}

	@Override
	public void mouseDragged(MouseEvent e)
	{
		updateDrag(e.getX(), e.getY());
	}

	@Override
	public void mouseMoved(MouseEvent e)
	{
	}

	@Override
	public void mouseClicked(MouseEvent e)
	{
	}

	@Override
	public void mousePressed(MouseEvent e)
	{
		float x = e.getX(), y = e.getY();
		for (Bezf bez : this.lines) {
			convert(bez, c);
			if (abs(c.a.x - x) < N && abs(c.a.y - y) < N) {
				dragging = bez.a;
			} else if (abs(c.p.x - x) < N && abs(c.p.y - y) < N) {
				dragging = bez.p;
			} else if (abs(c.q.x - x) < N && abs(c.q.y - y) < N) {
				dragging = bez.q;
			} else if (abs(c.b.x - x) < N && abs(c.b.y - y) < N) {
				dragging = bez.b;
			} else {
				continue;
			}
			break;
		}
	}

	@Override
	public void mouseReleased(MouseEvent e)
	{
		dragging = null;
		updateDrag(e.getX(), e.getY());
	}

	@Override
	public void mouseEntered(MouseEvent e)
	{
	}

	@Override
	public void mouseExited(MouseEvent e)
	{
	}

	@Override
	public void keyTyped(KeyEvent e)
	{
		if (e.getKeyChar() == 'n') {
			Bezf b = new Bezf();
			b.a.x = 0f; b.a.y = 0f;
			b.p.x = .2f; b.p.y = 0f;
			b.q.x = .8f; b.q.y = 0f;
			b.b.x = 1f; b.b.y = 0f;
			lines.add(b);
			this.repaint();
		} else if (e.getKeyChar() == 'e') {
			export();
		}
	}

	@Override
	public void keyPressed(KeyEvent e)
	{
	}

	@Override
	public void keyReleased(KeyEvent e)
	{
	}

	void updateDrag(int x, int y)
	{
		if (dragging == null) {
			return;
		}
		dragging.x = (x - 400f) / 800f;
		dragging.y = (y - 225f) / 450f;
		this.repaint();
	}

	void convert(Bezf from, Bezi into)
	{
		into.a.x = (int) (from.a.x * 800f + 400f);
		into.a.y = (int) (from.a.y * 450f + 225f);
		into.p.x = (int) (from.p.x * 800f + 400f);
		into.p.y = (int) (from.p.y * 450f + 225f);
		into.q.x = (int) (from.q.x * 800f + 400f);
		into.q.y = (int) (from.q.y * 450f + 225f);
		into.b.x = (int) (from.b.x * 800f + 400f);
		into.b.y = (int) (from.b.y * 450f + 225f);
	}

	void export()
	{
		for (Bezf z : this.lines) {
			float length = 0f;
			float _x = z.a.x, _y = z.a.y;
			for (float a = .01f; a < .999; a += 0.01) {
				float b = 1f - a;
				float x = b*b*b*z.a.x+3f*b*b*a*z.p.x+3f*b*a*a*z.q.x+a*a*a*z.b.x;
				float y = b*b*b*z.a.y+3f*b*b*a*z.p.y+3f*b*a*a*z.q.y+a*a*a*z.b.y;
				float __x = _x - x, __y = _y - y;
				length += sqrt(__x * __x + __y * __y);
				_x = x;
				_y = y;
			}
			System.out.printf(
				"%.3f,%d.%02d,%d.%02d,%d.%02d,%d.%02d,\n",
				length,
				(int) (z.a.x * 100),
				(int) (z.a.y * 100),
				(int) (z.p.x * 100),
				(int) (z.p.y * 100),
				(int) (z.q.x * 100),
				(int) (z.q.y * 100),
				(int) (z.b.x * 100),
				(int) (z.b.y * 100)
			);
		}
	}
}
