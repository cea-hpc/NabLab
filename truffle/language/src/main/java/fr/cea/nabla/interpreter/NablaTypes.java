package fr.cea.nabla.interpreter;

import com.oracle.truffle.api.dsl.TypeSystem;

import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NV3Bool;
import fr.cea.nabla.interpreter.values.NV3Int;
import fr.cea.nabla.interpreter.values.NV3Real;
import fr.cea.nabla.interpreter.values.NV4Bool;
import fr.cea.nabla.interpreter.values.NV4Int;
import fr.cea.nabla.interpreter.values.NV4Real;


@TypeSystem({
		NV0Bool.class, NV0Int.class, NV0Real.class,
		NV1Bool.class, NV1Int.class, NV1Real.class,
		NV2Bool.class, NV2Int.class, NV2Real.class,
		NV3Bool.class, NV3Int.class, NV3Real.class,
		NV4Bool.class, NV4Int.class, NV4Real.class
	})
public abstract class NablaTypes {}