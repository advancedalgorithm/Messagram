module server

import net

pub struct Client
{
	pub mut:
		username 		string
		password		string
		
		host			string
		port			int
		
		using_app		bool
		app_t			string
		socket			&net.TcpConn
}

pub fn new_client(mut socket net.TcpConn, u string, p string, ip string, prt int, args ...string) Client
{
	mut c := Client{socket: socket}
	if u == "" || p == "" || ip == "" || prt < 1 {
		return c
	}

	c.username = u 
	c.password = p 
	c.host = ip 
	c.port = prt
	c.socket = socket

	/*
		0 = bool
		1 = string
	*/
	if args.len > 0 {
		if args[0].bool() in [false, true] {
			c.using_app = args[0].bool() }
	}

	if args.len == 1 {
		c.app_t = args[1]
	}

	return c
}

pub fn (mut c Client) is_user_valid() bool 
{
	if c.username != "" || c.password != "" {
		return true
	}

	return false
}