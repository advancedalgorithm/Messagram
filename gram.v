import os
import time
import vweb

import src
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
	time.sleep(2*time.millisecond)
	cp.prompt()
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

	mut user := db.User{}

	lock api.gram {
		user = api.gram.authorize_user(username, password);
	}
	if user.is_empty() {
		return api.text("")
	}

	session_uuid := db.generate_uuid()
	if session_uuid != "" {
		return api.text(session_uuid)
	}

	return api.text("[ X ] Error, Unable to account...!")
}
