module db_utils

pub struct Member {
	pub mut:
		user_id    		int

		roles      		[]int
}

pub struct Server
{
	pub mut:
		server_id	    	int
		server_owner_id 	int
		server_name	    	string

		members				[]User // We need to create a struct identifying the user info and their privilages in the server
		roles       		map[string]int // Role name, role id
		channels    		map[string]int // Channel name, channel id

		logs        		[]string // Temporary until I figure out which way to do this
}

/*
	
*/
pub fn read_server_info() Server
{
	return Server{}
}