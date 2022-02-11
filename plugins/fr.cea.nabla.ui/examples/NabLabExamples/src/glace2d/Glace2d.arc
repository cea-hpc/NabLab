<?xml version="1.0"?>
<case codename="Glace2d" codeversion="1.0" xml:lang="en">
	<arcane>
		<title>Glace2d hydrodynamic scheme</title>
		<timeloop>Glace2dLoop</timeloop>
	</arcane>
 
	<arcane-post-processing>
 		<output-period>1</output-period>
		<output>
			<variable>rho</variable>
		</output>
	</arcane-post-processing>

 	<meshes>
		<mesh>
			<generator name="Cartesian2D">
				<nb-part-x>1</nb-part-x>
				<nb-part-y>1</nb-part-y>
				<face-numbering-version>4</face-numbering-version>
				<origin>0.0 0.0</origin>
				<x><n>100</n><length>1.0</length></x>
				<y><n>10</n><length>0.1</length></y>
			</generator>
		</mesh>
 	</meshes>
 
	<glace2d>
		<stop-time>0.2</stop-time>
		<max-iterations>20000</max-iterations>
	</glace2d>
</case>
