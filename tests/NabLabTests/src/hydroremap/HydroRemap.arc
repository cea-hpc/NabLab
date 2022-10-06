<?xml version="1.0"?>
<case codename="HydroRemap" codeversion="1.0" xml:lang="en">
	<arcane>
		<title>HydroRemap test</title>
		<timeloop>HydroRemapLoop</timeloop>
	</arcane>
 
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
 
	<hydro>
		<max-time>0.1</max-time>
		<max-iter>500</max-iter>
		<delta-t>1.0</delta-t>
		<r1 name="R1"/>
		<r2 name="R2"/>
	</hydro>
</case>
