import os
import net
import time
import vweb

import src
import src.server
import src.cp
import src.db_utils as db

pub struct MessagramAPI
{
	vweb.Context
	pub mut:
		gram shared src.Messagram
}
fn main() 
{
	shared messagram := src.build_messagram()
	spawn vweb.run(&MessagramAPI{gram: messagram}, 80)
	time.sleep(time.infinite)
	// cp.prompt()
}

@['/index']
fn (mut api MessagramAPI) index() vweb.Result
{
	return api.text("Welcome to Messagram API v0.0.1")
}

@['/auth']
fn (mut api MessagramAPI) auth() vweb.Result
{
	username := api.query['username'] or { "" }
	password := api.query['password'] or { "" }
	hwid     := api.query['hwid']     or { "" }

	mut client		:= server.Client{}
	mut user 		:= db.User{}

	lock api.gram {
		user = api.gram.find_profile(username)
	}

	if user.validate_login(username, password) {
		lock api.gram {
			client = server.new_client(mut user, password, hwid) 
			api.gram.server.clients << client
		}
		return api.text("${client.sid}")
	}

	return api.text("[ X ] Error, Unable to find account...!")
}
