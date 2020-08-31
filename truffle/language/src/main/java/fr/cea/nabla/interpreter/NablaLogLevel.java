package fr.cea.nabla.interpreter;

import java.util.logging.Level;

public class NablaLogLevel extends Level {

	private static final long serialVersionUID = -4543019147024333875L;

	public static final Level OFF = new fr.cea.nabla.ir.interpreter.Context.Level("OFF", Integer.MAX_VALUE);
	public static final Level SEVERE = new fr.cea.nabla.ir.interpreter.Context.Level("SEVERE", 1000);
	public static final Level WARNING = new fr.cea.nabla.ir.interpreter.Context.Level("WARNING", 900);
	public static final Level INFO = new NablaLogLevel("INFO", 800);
	public static final Level CONFIG = new fr.cea.nabla.ir.interpreter.Context.Level("CONFIG", 700);
	public static final Level FINE = new NablaLogLevel("FINE", 500);
	public static final Level FINER = new NablaLogLevel("FINER", 400);
	public static final Level FINEST = new NablaLogLevel("FINEST", 300);
	public static final Level ALL = new fr.cea.nabla.ir.interpreter.Context.Level("ALL", Integer.MIN_VALUE);

	private NablaLogLevel(String name, int value) {
		super(name, value);
	}

}
