module cp

import os

pub const (
	hostname = "[messagram@cp] # "
	banner = "Welcome to Messagram v1.0.0 | Written in V\n"
)

pub fn prompt()
{
	for 
	{
		data := os.input(hostname)

		if data.len < 2 { continue }

		args := data.split(" ")
		cmd := args[0]

		match cmd
		{
			"help" {
				println("WORKING")
			}
			"start" {

			} else {
				continue
			}
		}
	}
}