module utils 

pub fn rm_str(line string, arr []string) string 
{
	mut new := line
	for element in arr {
		new = new.replace(element, "")
	}

	return new
}