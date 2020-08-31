/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.interpreter.values;

import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.runtime.NablaType;

@ExportLibrary(InteropLibrary.class)
public class NV0Real implements NablaValue {
	private double data;

	public NV0Real(final double data) {
		this.data = data;
	}
	
	@ExportMessage
	boolean isNumber() {
		return fitsInDouble();
	}

	@ExportMessage
	boolean fitsInByte() {
		return false;
	}

	@ExportMessage
	boolean fitsInShort() {
		return false;
	}

	@ExportMessage
	boolean fitsInFloat() {
		return false;
	}

	@ExportMessage
	boolean fitsInLong() {
		return false;
	}

	@ExportMessage
	boolean fitsInInt() {
		return false;
	}

	@ExportMessage
	boolean fitsInDouble() {
		return true;
	}

	@ExportMessage
	double asDouble() {
		return data;
	}

	@ExportMessage
	long asLong() throws UnsupportedMessageException {
		throw UnsupportedMessageException.create();
	}

	@ExportMessage
	byte asByte() throws UnsupportedMessageException {
		throw UnsupportedMessageException.create();
	}

	@ExportMessage
	int asInt() throws UnsupportedMessageException {
		throw UnsupportedMessageException.create();
	}

	@ExportMessage
	float asFloat() throws UnsupportedMessageException {
		throw UnsupportedMessageException.create();
	}

	@ExportMessage
	short asShort() throws UnsupportedMessageException {
		throw UnsupportedMessageException.create();
	}

	@Override
	@TruffleBoundary
	public boolean equals(final Object obj) {
		if ((this == obj)) {
			return true;
		}
		if ((obj == null)) {
			return false;
		}
		Class<? extends NV0Real> _class = this.getClass();
		Class<?> _class_1 = obj.getClass();
		boolean _tripleNotEquals = (_class != _class_1);
		if (_tripleNotEquals) {
			return false;
		}
		final NV0Real other = ((NV0Real) obj);
		if ((other.data != this.data)) {
			return false;
		}
		return true;
	}

	public double getData() {
		return this.data;
	}

	public void setData(final double data) {
		this.data = data;
	}
	
	@Override
	public int getDimension(int dimension) {
		throw new UnsupportedOperationException();
	}
	
	@ExportMessage
    boolean hasLanguage() {
        return true;
    }

    @ExportMessage
    Class<? extends TruffleLanguage<?>> getLanguage() {
        return NablaLanguage.class;
    }

    @ExportMessage
    boolean hasMetaObject() {
        return true;
    }

    @ExportMessage
    Object getMetaObject() {
        return NablaType.NUMBER;
    }

    @ExportMessage
    Object toDisplayString(@SuppressWarnings("unused") boolean allowSideEffects) {
        return data;
    }
}
