import os
import time
import vweb

import src
import src.cp

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
	uname := api.query['username'] or { "" }
	pword := api.query['password'] or { "" }
	hwid  := api.query['hwid'] or { "" }

	lock api.messagram {
		
	}
}
