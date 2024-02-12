module server

import net
import rand 

import src.db_utils as db

pub struct Client
{
	pub mut:
		info			db.User

		/*
			Server should never get a password from client 
			unless editing account settings to validate the owner
			due to protecting users from saving their passwords on 
			clients
		*/
		password		string
		sid				string
		sid_used		bool = false

		host			string
		port			int
		hwid			string

		using_app		bool
		app_name		string
		app_version		string
		socket			&net.TcpConn
}

pub fn new_client(mut u db.User, pword string, h string, args ...string) Client
{
	mut c := Client{socket: &net.TcpConn{}}
	if u.username == "" || h == "" {
		return c
	}

	c.sid = generate_key()
	c.password = pword
	c.info = u
	c.hwid = h

	/*
		0 = bool
		1 = string
	*/
	if args.len > 0 {
		if args[0].bool() in [false, true] {
			c.using_app = args[0].bool() }
	}

	if args.len == 1 {
		c.app_name = args[1]
	}

	// generate a SID for the client 

	return c
}

pub fn (mut c Client) is_user_valid() bool 
{
	if c.info.username != "" || c.password != "" {
		return true
	}

	return false
}

fn generate_key() string
{
	mut key := ""
	for i in 0..32 {
		num := rand.int_in_range(0, 9) or { 0 }
		key += "${num}"
	}

	return key
}