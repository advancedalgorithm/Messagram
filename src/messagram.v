module src

import os 

import src.utils
import src.server
import src.db_utils

pub struct Messagram
{
	pub mut:
		users		[]db_utils.User
		server		&server.MessagramServer
}

pub fn build_messagram() Messagram
{
	mut m := Messagram{server: &server.MessagramServer{}}

	m.load_user_db()
	m.load_all_communities()

	go server.start_messagram_server(mut m.server)

	return m
}

pub fn (mut m Messagram) load_user_db() 
{
	mut db := os.read_lines(db_utils.user_dbpath) or { 
		println("[ X ] Error, Unable to read Messagram User Database")
		return 
	}

	println("[ + ] Loading Messagram User Database.....")

	for user_line in db 
	{
		if user_line.len < 2 { continue }
		// ('USER_ID','USERNAME','EMAIL','PASSWORD','IP_ADDR','NO_PHONE','ACCOUNT_PIN_CODE','MESSAGRAM_RANK_INT')
		//      0          1        2        3          4         6              7                  8
		info := utils.rm_str(user_line, ['(', ')', '\'']).split(",")

		if info.len == 8 
		{ m.users << db_utils.user(user_line, true) }
		else { println("[ X ] Error, DB Line is corrupted....!\r\n\t=> ${user_line}")}
	}

	if m.users.len == 0 {
		println("[ - ] Warning, There is no users....!")
	}

	println("[ + ] Messagram Users loaded....!")
}

pub fn (mut m Messagram) load_all_communities()
{
	mut files := os.ls("assets/db/communities") or { 
		println("[ X ] Error, Unable to read Messagram community directory....!")
		return
	}

	for file in files 
	{
		if file == "example_c.mg" { continue }
		mut community_data := os.read_file("assets/db/communities/${file}") or { "" }

	}
}