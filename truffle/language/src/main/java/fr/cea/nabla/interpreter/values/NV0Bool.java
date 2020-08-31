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

import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.runtime.NablaType;

@ExportLibrary(InteropLibrary.class)
public class NV0Bool implements NablaValue {
	private boolean data;

	public NV0Bool(final boolean data) {
		this.data = data;
	}

	@ExportMessage
	boolean isBoolean() {
		return true;
	}

	@ExportMessage
	final boolean asBoolean() throws UnsupportedMessageException {
		return data;
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
		Class<? extends NV0Bool> _class = this.getClass();
		Class<?> _class_1 = obj.getClass();
		boolean _tripleNotEquals = (_class != _class_1);
		if (_tripleNotEquals) {
			return false;
		}
		final NV0Bool other = ((NV0Bool) obj);
		if ((Boolean.valueOf(other.data) != Boolean.valueOf(this.data))) {
			return false;
		}
		return true;
	}

	public boolean isData() {
		return this.data;
	}

	public void setData(final boolean data) {
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
        return NablaType.BOOLEAN;
    }

    @ExportMessage
    @TruffleBoundary
    Object toDisplayString(@SuppressWarnings("unused") boolean allowSideEffects) {
        return data;
    }
}
