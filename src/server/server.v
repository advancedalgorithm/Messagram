module server

import io
import net
import x.json2 as jsn
import src.db_utils as db

pub struct MessagramServer
{
	pub mut:
		host			string
		port 			int

		clients			[]Client
		main_socket 	net.TcpListener
}

pub fn start_messagram_server(mut m MessagramServer)
{
	m.main_socket = net.listen_tcp(.ip6, ":${m.port}") or {
		println("[ X ], Error, Unable to start server....!")
		return
	}

	m.client_listener()
}

pub fn (mut m MessagramServer) client_listener() 
{
	for {
		mut client := m.main_socket.accept() or { &net.TcpConn{} }
		m.client_authenticator(mut client)
	}
}

pub fn (mut m MessagramServer) client_authenticator(mut c net.TcpConn) 
{
	mut reader := io.new_buffered_reader(reader: c)
	login := reader.read_line() or { "" }

	if !login.starts_with("{") && !login.ends_with("}") {
		c.close() or { net.TcpConn{} }
		return 
	}

	/*	
		{

			"username": "",
			"password": "",
			"ip": "",
			"sid": ""
		}
	*/
	mut login_data := (jsn.raw_decode("${login}") or { jsn.Any{} }).as_map()

	if "username" in login_data || "password" in login_data || "ip" in login_data || "sid" in login_data {
		println("[ X ] Error, Invalid JSON Response")
		c.close() or { net.TcpConn{} }
		return
	}

	username 	:= login_data['username'] or { "" }
	password 	:= login_data['password'] or { "" }
	ip 			:= login_data['ip'] or { "" }
	sid 		:= login_data['sid'] or { "" }

	// Login Authenication
}
