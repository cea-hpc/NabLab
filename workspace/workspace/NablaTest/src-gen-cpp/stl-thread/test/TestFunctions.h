namespace TestFunctions
{
	std::vector<double> waveSizes(std::vector<double> v)
	{
		size_t vSize = v.size();
		std::vector<double> waveSizes(vSize);
		for (size_t i=0 ; i<vSize ; ++i)
			waveSizes[i] = i * 1.0;
		return waveSizes;
	}
}

