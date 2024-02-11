module server

import io
import net
import x.json2 as jsn

import src.db_utils as db

pub struct MessagramServer
{
	pub mut:
		host			string
		port 			int = 666

		users			[]db.User
		clients			[]Client
		main_socket 	net.TcpListener
}

pub fn start_messagram_server(mut m MessagramServer, mut users db.User)
{
	m.main_socket = net.listen_tcp(.ip6, ":${m.port}") or {
		println("[ X ], Error, Unable to start server....!")
		return
	}

	m.users = users

	println("[ + ] Messagram server has been started....!")

	m.client_listener()
}

pub fn (mut m MessagramServer) client_listener() 
{
	for {
		mut client := m.main_socket.accept() or { &net.TcpConn{} }

		/*
		 	API LOGIN AUTHENICATION SHOULD ONLY COME FROM A SPECIFIC IP OR LOCALHOST
			IT WILL BE SENT TO PARSE AND AUTHORIZATION CHECKING 
		*/
		user_ip := client.peer_ip() or { "" }
		if user_ip == "BACKEND_IP_HERE" {
			m.authenicate_user(mut client)
		}
		m.client_authenticator(mut client)
	}
}

pub fn (mut m MessagramServer) authenicate_user(mut c net.TcpConn)
{
	mut reader := io.new_buffered_reader(reader: c)
	mut info := reader.read_line() or { "" }

	if !info.starts_with("{") && !info.ends_with("}") {
		// FORM A JSON RESPONSE
	}


}

/*
	A sessionID must be generated by authenicating via API Auth Endpoint
*/
pub fn (mut m MessagramServer) client_authenticator(mut c net.TcpConn) 
{
	mut reader := io.new_buffered_reader(reader: c)

	c.write_string("[ + ] Welcome to Messagram Server v0.0.1\n") or { 0 }
	login := reader.read_line() or { "" }

	println(login)
	if !login.starts_with("{") && !login.ends_with("}") {
		println("[ X ] Error, Invalid login data provided....!\r\n\t=> Disconnecting user " + c.peer_ip() or { "" } + "\r\n\t=>\r\n${login}")
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

	if "cmd" !in login_data || "username" !in login_data || "sessionID" !in login_data || "hwid" !in login_data {
		println("[ X ] Error, Invalid JSON Response")
		c.close() or { net.TcpConn{} }
		return
	}

	username 	:= login_data['username'] or { "" }
	password 	:= login_data['password'] or { "" }
	ip 		:= login_data['ip'] or { "" }
	sid 		:= login_data['sid'] or { "" }

	println("${username} ${password} ${ip} ${sid}")

	// Login Authenication
	mut user, auth_chk := m.authorize_user(username, password)

	if !auth_chk {
		c.write_string("{\"status\": \"false\", \"resp_t\": \"user_resp\", \"cmd_t\": \"INVALID_INFO\"}") or { 0 }
		c.close() or { net.TcpConn{} }
		return
	}

	c.write_string("{\"status\": \"true\", \"resp_t\": \"user_resp\", \"cmd_t\": \"SUCCESSFUL_LOGIN\"}") or { 0 }
	command_handler(mut c)
}

pub fn (mut m MessagramServer) command_handler(login_data string)
{

}

pub fn (mut m MessagramServer) find_profile(username) db.User
{

}

pub fn (mut m MessagramServer) authorize_user(username string, password string) (db.User, bool)
{
	for mut user in m.users
	{
		if user.username == username && user.password == passwrd { return user, true }
	}

	return db.User, false
}
