/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Array2D;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Array2 D</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.Array2DImpl#getNbRows <em>Nb Rows</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.Array2DImpl#getNbCols <em>Nb Cols</em>}</li>
 * </ul>
 *
 * @generated
 */
public class Array2DImpl extends BaseTypeImpl implements Array2D {
	/**
	 * The default value of the '{@link #getNbRows() <em>Nb Rows</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbRows()
	 * @generated
	 * @ordered
	 */
	protected static final int NB_ROWS_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getNbRows() <em>Nb Rows</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbRows()
	 * @generated
	 * @ordered
	 */
	protected int nbRows = NB_ROWS_EDEFAULT;

	/**
	 * The default value of the '{@link #getNbCols() <em>Nb Cols</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbCols()
	 * @generated
	 * @ordered
	 */
	protected static final int NB_COLS_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getNbCols() <em>Nb Cols</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbCols()
	 * @generated
	 * @ordered
	 */
	protected int nbCols = NB_COLS_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected Array2DImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ARRAY2_D;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getNbRows() {
		return nbRows;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setNbRows(int newNbRows) {
		int oldNbRows = nbRows;
		nbRows = newNbRows;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARRAY2_D__NB_ROWS, oldNbRows, nbRows));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getNbCols() {
		return nbCols;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setNbCols(int newNbCols) {
		int oldNbCols = nbCols;
		nbCols = newNbCols;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARRAY2_D__NB_COLS, oldNbCols, nbCols));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.ARRAY2_D__NB_ROWS:
				return getNbRows();
			case IrPackage.ARRAY2_D__NB_COLS:
				return getNbCols();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case IrPackage.ARRAY2_D__NB_ROWS:
				setNbRows((Integer)newValue);
				return;
			case IrPackage.ARRAY2_D__NB_COLS:
				setNbCols((Integer)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case IrPackage.ARRAY2_D__NB_ROWS:
				setNbRows(NB_ROWS_EDEFAULT);
				return;
			case IrPackage.ARRAY2_D__NB_COLS:
				setNbCols(NB_COLS_EDEFAULT);
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case IrPackage.ARRAY2_D__NB_ROWS:
				return nbRows != NB_ROWS_EDEFAULT;
			case IrPackage.ARRAY2_D__NB_COLS:
				return nbCols != NB_COLS_EDEFAULT;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuilder result = new StringBuilder(super.toString());
		result.append(" (nbRows: ");
		result.append(nbRows);
		result.append(", nbCols: ");
		result.append(nbCols);
		result.append(')');
		return result.toString();
	}

} //Array2DImpl
