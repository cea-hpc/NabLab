The content of the folder src-gen must not be deleted.

The file fr.cea.nabla.ir.ir.impl.ArrayVariableImpl overrides the method getDimensions to bypass
an EMF bug that not allows duplicated elements even if the ecore unique attribute is set to false.

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated NOT FIXME workaround BUG 89325
	 */
	@SuppressWarnings("serial")
	public EList<Connectivity> getDimensions() {
		if (dimensions == null) {
			dimensions = new EObjectResolvingEList<Connectivity>(Connectivity.class, this, IrPackage.ARRAY_VARIABLE__DIMENSIONS) {
				@Override
	    		protected boolean isUnique() { return false; }
			};
		}
		return dimensions;
	}

