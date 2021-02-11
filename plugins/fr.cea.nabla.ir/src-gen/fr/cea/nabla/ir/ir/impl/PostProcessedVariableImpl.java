/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemType;
import fr.cea.nabla.ir.ir.PostProcessedVariable;
import fr.cea.nabla.ir.ir.Variable;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Post Processed Variable</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessedVariableImpl#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessedVariableImpl#getOutputName <em>Output Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessedVariableImpl#getSupport <em>Support</em>}</li>
 * </ul>
 *
 * @generated
 */
public class PostProcessedVariableImpl extends MinimalEObjectImpl.Container implements PostProcessedVariable {
	/**
	 * The cached value of the '{@link #getTarget() <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTarget()
	 * @generated
	 * @ordered
	 */
	protected Variable target;

	/**
	 * The default value of the '{@link #getOutputName() <em>Output Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOutputName()
	 * @generated
	 * @ordered
	 */
	protected static final String OUTPUT_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getOutputName() <em>Output Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOutputName()
	 * @generated
	 * @ordered
	 */
	protected String outputName = OUTPUT_NAME_EDEFAULT;

	/**
	 * The cached value of the '{@link #getSupport() <em>Support</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSupport()
	 * @generated
	 * @ordered
	 */
	protected ItemType support;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected PostProcessedVariableImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.POST_PROCESSED_VARIABLE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getTarget() {
		if (target != null && target.eIsProxy()) {
			InternalEObject oldTarget = (InternalEObject)target;
			target = (Variable)eResolveProxy(oldTarget);
			if (target != oldTarget) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSED_VARIABLE__TARGET, oldTarget, target));
			}
		}
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetTarget() {
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTarget(Variable newTarget) {
		Variable oldTarget = target;
		target = newTarget;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSED_VARIABLE__TARGET, oldTarget, target));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getOutputName() {
		return outputName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOutputName(String newOutputName) {
		String oldOutputName = outputName;
		outputName = newOutputName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSED_VARIABLE__OUTPUT_NAME, oldOutputName, outputName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ItemType getSupport() {
		if (support != null && support.eIsProxy()) {
			InternalEObject oldSupport = (InternalEObject)support;
			support = (ItemType)eResolveProxy(oldSupport);
			if (support != oldSupport) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSED_VARIABLE__SUPPORT, oldSupport, support));
			}
		}
		return support;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ItemType basicGetSupport() {
		return support;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setSupport(ItemType newSupport) {
		ItemType oldSupport = support;
		support = newSupport;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSED_VARIABLE__SUPPORT, oldSupport, support));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.POST_PROCESSED_VARIABLE__TARGET:
				if (resolve) return getTarget();
				return basicGetTarget();
			case IrPackage.POST_PROCESSED_VARIABLE__OUTPUT_NAME:
				return getOutputName();
			case IrPackage.POST_PROCESSED_VARIABLE__SUPPORT:
				if (resolve) return getSupport();
				return basicGetSupport();
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
			case IrPackage.POST_PROCESSED_VARIABLE__TARGET:
				setTarget((Variable)newValue);
				return;
			case IrPackage.POST_PROCESSED_VARIABLE__OUTPUT_NAME:
				setOutputName((String)newValue);
				return;
			case IrPackage.POST_PROCESSED_VARIABLE__SUPPORT:
				setSupport((ItemType)newValue);
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
			case IrPackage.POST_PROCESSED_VARIABLE__TARGET:
				setTarget((Variable)null);
				return;
			case IrPackage.POST_PROCESSED_VARIABLE__OUTPUT_NAME:
				setOutputName(OUTPUT_NAME_EDEFAULT);
				return;
			case IrPackage.POST_PROCESSED_VARIABLE__SUPPORT:
				setSupport((ItemType)null);
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
			case IrPackage.POST_PROCESSED_VARIABLE__TARGET:
				return target != null;
			case IrPackage.POST_PROCESSED_VARIABLE__OUTPUT_NAME:
				return OUTPUT_NAME_EDEFAULT == null ? outputName != null : !OUTPUT_NAME_EDEFAULT.equals(outputName);
			case IrPackage.POST_PROCESSED_VARIABLE__SUPPORT:
				return support != null;
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
		result.append(" (outputName: ");
		result.append(outputName);
		result.append(')');
		return result.toString();
	}

} //PostProcessedVariableImpl
