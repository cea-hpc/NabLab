<?xml version="1.0"?>
<case codename="IterativeHeatEquation" codeversion="1.0" xml:lang="en">
	<arcane>
		<title>Iterative heat equation</title>
		<timeloop>IterativeHeatEquationLoop</timeloop>
	</arcane>
 
	<arcane-post-processing>
 		<output-period>1</output-period>
		<output>
			<variable>u_n</variable>
		</output>
	</arcane-post-processing>

 	<meshes>
		<mesh>
			<generator name="Cartesian2D">
				<nb-part-x>1</nb-part-x>
				<nb-part-y>1</nb-part-y>
				<face-numbering-version>4</face-numbering-version>
				<origin>0.0 0.0</origin>
				<x><n>40</n><length>2.0</length></x>
				<y><n>40</n><length>2.0</length></y>
			</generator>
		</mesh>
 	</meshes>
 
	<iterative-heat-equation>
		<stop-time>0.1</stop-time>
		<max-iterations>500000000</max-iterations>
	</iterative-heat-equation>
</case>
