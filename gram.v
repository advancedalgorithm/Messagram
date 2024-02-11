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
		messagram Shared src.Messagram
}
fn main() 
{
	shared messagram := src.build_messagram()
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

	lock api.messagram {
		user := api.messagram.authorize_user(username, password);
		if user.is_empty() {
			return api.text("")
		}

		sessionUUID := db.generated_uuid()

		api.text(sessionUUID)
	}
}