module src

import src.server
import src.db_utils

pub struct Messagram
{
	pub mut:
		server		&server.MessagramServer
}

pub fn build_messagram() Messagram
{
	mut m := Messagram{server: &server.MessagramServer{}}
	go server.start_messagram_server(mut m.server)

	// Read User DB

	return m
}