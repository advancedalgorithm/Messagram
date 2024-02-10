module db_utils

import rand
import crypto.bcrypt

pub struct User
{
	pub mut:
		username			string
		user_id				string
		email				string
		password			string

		hash                string

		twofa_toggle		bool
		twofa 				string

		trusted_systems		map[string]string
}

/*
	enum Settings_T{}

	Used for readability and bug tracking
*/
pub enum Settings_T 
{
	null 			= 0x0000000
	username		= 0x0000001
	email			= 0x0000002
	password		= 0x0000003

	add_trust_sys	= 0x0000007
	rm_trust_sys	= 0x0000008
}

pub enum TrustSystems_T
{
	null 		  	= 0x0000010
	email 		  	= 0x0000011
	phone 		  	= 0x0000012
	authenticator 	= 0x0000013
}

/*
	[@DOC]

	user(content string) User

	Used as a constructor
*/
pub fn user(content string, new bool) User
{
	id := content.int()

	if new {
		if id > 0 && content.len == 32 {
			
		}
	}
	return User{}
}

/*
	[@DOC]

	edit_settings(settin_t Settings_T, new_data string)

	modify's a user's setting
*/
pub fn (mut u User) edit_settings(sttin_t Settings_T, new_data string)
{
	match sttin_t
	{
		.username {

		}
		.password {

		}
		.email {

		}
		.add_trust_sys {

		}
		.rm_trust_sys {
			
		} else {}
	}
}

/*
	[@DOC]
		User.save_user_db()

		Save the current user
*/
pub fn (mut u User) save_user_db() 
{

}

/*
	[@DOC]

	is_2fa_on() bool

	return weather the 2fa option is on when an email, phone or authenicator is linked
*/
pub fn (mut u User) is_2fs_on() bool { return u.twofa_toggle }

/*
	[@DOC]

	add_trust_sys(trust_t TrustSystems_T, trust_data string)

	adds a source for protection such as 2fa
*/
pub fn (mut u User) add_trust_sys(trust_t TrustSystems_T, trust_data string)
{
	match trust_t
	{
		.email {

		}
		.phone {

		}
		.authenticator {

		} else {}
	}
}

/*
	[@DOC]

	generate_key() string
*/
fn generate_key() string 
{
	mut key := ""
	for i in 0..32 {
		num := rand.int_in_range(0, 9) or { 0 }
		key += "${num}"
	}

	return key
}

/*
	[@DOC]

	is_username_valid() bool

	return weather a username is valid or not
*/
fn is_username_valid(username string) bool 
{
	chars := "QWERTYUIOPASDFGHJKLZXCVBNM"

	char_list := chars.split("")

	for u in username
	{
		for ch in char_list
		{
			if ch != u.ascii_str() && ch.to_lower() != u.ascii_str() { return false }
		}
	}

	return true
}