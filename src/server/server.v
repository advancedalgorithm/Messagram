module server

import os
import io
import net
import time
import x.json2 as jsn

import src.db_utils as db

pub struct MessagramServer
{
	pub mut:
		host			string
		port 			int = 666
		users			[]db.User
		clients			[]Client
		client_sockets  []net.TcpConn
		main_socket 	net.TcpListener
}

/* 
	[@DOC]
	pub fn start_messagram_server(mut m MessagramServer, mut users []db.User)

	Start the server and copy the users from database into the Server 
*/
pub fn start_messagram_server(mut m MessagramServer, mut users []db.User)
{
	m.main_socket = net.listen_tcp(.ip6, ":${m.port}") or {
		println("[ X ] Error, Unable to start server....!")
		return
	}

	m.users = users

	println("[ + ] Messagram server has been started....!")

	m.client_listener()
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) client_listener() 

	Accept && Listen to Messagram Client Sockets
*/
pub fn (mut m MessagramServer) client_listener() 
{
	for {
		mut client := m.main_socket.accept() or { 
			println("[ X ] Unable to accept connection")
			return
		}

		/*
		 	API LOGIN AUTHENICATION SHOULD ONLY COME FROM A SPECIFIC IP OR LOCALHOST
			IT WILL BE SENT TO PARSE AND AUTHORIZATION CHECKING 
		*/
		user_ip := client.peer_ip() or { "" }
		client.set_read_timeout(time.infinite)

		if user_ip == "BACKEND_IP_HERE" { // WEBSITE
			spawn m.authenticate_user(mut client)
		}
		spawn m.client_authenticator(mut client)
	}
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) authenticate_user(mut c net.TcpConn)
	
	USE FOR API AUTH ENDPOINT

	TO-DO #1: Authorize user then generate a sessionID for user on the API Endpoint

	Note: This function was gonna be used from an API Endpoint using 
 		   TCP Socket to connect and authorize but i dont know if i 
		   want to do it that way
*/
pub fn (mut m MessagramServer) authenticate_user(mut c net.TcpConn)
{
	mut reader := io.new_buffered_reader(reader: c)
	mut info := reader.read_line() or { "" }

	if !info.starts_with("{") && !info.ends_with("}") {
		// FORM A JSON RESPONSE
	}


	// Find user
	// mut user, chk := authorize_user(username, password)

	// mut socket_client := new_client(mut c, 
	// m.clients << socket_client
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) client_authenticator(mut c net.TcpConn) 

	Validating a connectin via Username, SessionID, & HWID!
	
	A sessionID must be generated by authenicating login via API Auth Endpoint
	before a client trys connecting.

	Keys that will always be in JSON data for authentication listed below
	{
			"cmd_t": ""
			"username": "",
			"sid": "",
			"hwid": "",
			"client_name": "",
			"client_version": ""
	}
*/
pub fn (mut m MessagramServer) client_authenticator(mut c net.TcpConn) 
{
	mut reader := io.new_buffered_reader(reader: c)

	// c.write_string("[ + ] Welcome to Messagram Server v0.0.1\n") or { 0 }
	login := reader.read_line() or { "" }

	println(login)
	if !login.starts_with("{") && !login.ends_with("}") {
		println("[ X ] Error, Invalid login data provided....!\r\n\t=> Disconnecting user " + c.peer_ip() or { "" } + "\r\n\t=>\r\n${login}")
		c.close() or { return }
		return 
	}

	mut login_data := (jsn.raw_decode("${login}") or { jsn.Any{} }).as_map()

	if "cmd_t" !in login_data || "username" !in login_data || "sid" !in login_data || "hwid" !in login_data {
		println("[ X ] Error, Invalid JSON Response")
		c.close() or { return }
		return
	}

	cmd 		:= (login_data['cmd_t'] 			or { "" }).str()
	username 	:= (login_data['username'] 			or { "" }).str()
	sid 		:= (login_data['sid'] 				or { "" }).str()
	hwid		:= (login_data['hwid'] 				or { "" }).str()
	client_name := (login_data['client_name']		or { "" }).str()
	client_v 	:= (login_data['client_version'] 	or { "" }).str()
	host_addr	:= c.peer_ip() or { "" }

	// Login Authenication
	mut user 				:= m.find_account(&username)
	mut client, chk, idx 	:= m.find_client_id(sid, hwid)

	if !chk {
		c.write_string("{\"status\": \"false\", \"resp_t\": \"user_resp\", \"cmd_t\": \"INVALID_LOGIN_INFO\"}") or { 0 }
		c.close() or { return }
		return
	}

	/* Updating the Client's Socket && Client Information */
	m.clients[idx].socket = c
	m.clients[idx].host = host_addr
	m.clients[idx].app_name = client_name
	m.clients[idx].app_version = client_v

	println("[ + ] Client's Socket Updated\r\n\t=> ${m.list_all_socket()}")

	mut r := response(mut client.info, login)
	r.parse_cmd_data()

	c.write_string("${r.data}") or { 0 }
	m.input_n_connection_handler(mut c, mut client)
}

/*
	[DOC]
	pub fn (mut m MessagramServer) input_n_connection_handler(mut socket net.TcpConn, mut client Client)

	- Handling Inputs, The Response Parser/Generator does most of the key checking and 
	  sanitization. 
	- Validating connection request, input protection & each request has to match client struct informatoin
	- A SessionID created on a Client's Device must be the same on every request or drop the socket (sign user out)
	  The only thing that can change is the IP (ONLY)
*/
pub fn (mut m MessagramServer) input_n_connection_handler(mut socket net.TcpConn, mut client Client)
{
	mut reader := io.new_buffered_reader(reader: socket)
	for
	{
		new_data := reader.read_line() or {
			m.disconnect_user(mut client.socket)
			println("[ X ] ${m.clients.len} Error, Client disconnected from socket\r\n\t=>${client.info.username}.....!")
			return
		}

		println(new_data)
		if !new_data.starts_with("{") || !new_data.ends_with("}")
		{
			println("[ X ] Error, Invalid JSON Data Received!")
			m.disconnect_user(mut client.socket)
			return
		}

		json_data 	:= (jsn.raw_decode(new_data) 	or { jsn.Any{} }).as_map()
		_ 			:= (json_data['cmd_t'] 			or { "" }).str()
		_ 			:= (json_data['username'] 		or { "" }).str()
		_ 			:= (json_data['sessionID'] 		or { "" }).str()
		_ 			:= (json_data['hwid'] 			or { "" }).str() 
		_ 			:= (json_data['client_name']	or { "" }).str()
		_ 			:= (json_data['client_v']		or { "" }).str() 

		// Connection Validation Check
		
		/* UNCOMMENT THE FUNCTION BELOW ONCE ALL RESPONSES ARE FINISHED */
		m.handle_command(mut client, new_data, json_data)
	}
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) send_msg_to_user(to_username string, data string) bool

	Sending a DM Msg to another Messagram user in JSON syntax
*/
pub fn (mut m MessagramServer) send_msg_to_user(to_username string, data string) bool
{
	mut c := 0
	for mut client in m.clients 
	{
		if client.info.username == to_username {
			println("\x1b[34mMessage Sender\x1b[39m\n\t=> ${m.clients[c].info.username} ${data}")
			m.clients[c].socket.write_string("${data}\n") or { 0 }
			return true
		}
		c++
	}

	return false
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) list_all_socket() string

	List all sockets connected to the socket
*/
pub fn (mut m MessagramServer) list_all_socket() string
{
	mut socket_list := ""
	
	for mut client in m.clients
	{ socket_list += "${client.info.username} | ${client.socket}\n" }

	return socket_list
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) disconnect_user(mut socket net.TcpConn) bool

	Drops the socket then remove the client from the Client List
*/
pub fn (mut m MessagramServer) disconnect_user(mut socket net.TcpConn) bool
{
	socket.close() or { 0 }

	for i, client in m.clients 
	{ if client.socket == socket { m.clients.delete(i) } }

	return true
}

/*
	[@DOC]
	pub fn (mut m MessagramServer) find_client_id(sid string, h string) (Client, bool, int)

	Find a client using SessionID and HWID for arguments
*/
pub fn (mut m MessagramServer) find_client_id(sid string, h string) (Client, bool, int)
{
	mut new := Client{}
	mut c := 0
	for mut client in m.clients 
	{
		if client.sid == sid && client.hwid == h { return client, true, c }
		c++
	}

	println("[ X ] Didnt find client information")
	return new, false, 0
}

/* 
	[@DOC]
	pub fn (mut m MessagramServer) find_account(username string) db.User
	
	Find an account in Messagram DB
*/
pub fn (mut m MessagramServer) find_account(username string) db.User
{
	for mut user in m.users
	{ if "${user.username}" == "${username}".trim_space() { return user } }

	return db.User{}
}