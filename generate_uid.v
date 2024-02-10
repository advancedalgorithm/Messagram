import rand 

fn main() 
{
	blocked_chars := ['~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '=', '[', ']', '+', '_', '|', '\\', '/', '`', '\'', '\"', '<', '>', '/']
	mut key := ""
	for i in 0..32 {
		num := rand.int_in_range(0, 9) or { 0 }
		key += "${num}"
	}

	println("${key}")
}