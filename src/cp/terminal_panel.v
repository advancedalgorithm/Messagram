module cp

import os

pub const (
	hostname = "[messagram@cp] # "
	banner = "Welcome to Messagram v1.0.0 | Written in V\n"
	help = "List of help commands 

Name      Arguments      Description
_________________________________________________
web       -start         Start the API web server
          -off           Shut down the web server

server    -start         Start the Messagram server
          -off           Shut down the server

user      -create        Create a new user
          -delete        Delete a user

community -delete        Delete a community"
)

pub fn prompt()
{
	println(banner)
	for 
	{
		data := os.input(hostname)

		if data.len > 5 {
			
			args := data.split(" ")
			cmd := args[0]

			match cmd
			{
				"help" {
					println(help)
				}
				"start" {

				} else {
					continue
				}
			}
		}
	}
}
