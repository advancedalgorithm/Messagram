module db_utils

import rand
import crypto.bcrypt

import src.utils

pub struct User
{
	pub mut:
		/* 
			Setting A Messagram Account Will Have 
			('14126082735350331571202525063203','Jeff','admin@messagram.io','testpw123','5.5.5.5','NO_PHONE','1973','99')
		*/
		user_idx			int
		user_id				string
		username			string
		email				string
		password			string
		ip_addr				string
		sms_number			string
		pin_code			string
		messa_rank			i64

		hash                string

		/*	
			2FA Using Email and//or Phone Number
		*/
		twofa_toggle			bool
		twofa 				TrustSystems_T

		// 2D Array [ PC_NAME: [] ]
		trusted_systems		map[string][]string
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
	pin_code		= 0x0000011
	email 		  	= 0x0000012
	phone 		  	= 0x0000013
	authenticator 		= 0x0000014
}

/*
	[@DOC]

	user(content string) User

	Used as a constructor
*/
pub fn user(content string, new bool) User
{
	mut u := User{}
	id := content.int()

	if new {
		return create(mut u, utils.rm_str(content, ['(', ')', '\'']).split(","))
	}

	return User{}
}

/*
	[@DOC]

	create(arr string) User

	Used to create a new User Struct with information
*/
pub fn create(mut u User, arr []string) User 
{
	// ('USER_ID','USERNAME','EMAIL','PASSWORD','IP_ADDR','NO_PHONE','ACCOUNT_PIN_CODE','MESSAGRAM_RANK_INT')
	if arr.len != 8 {
		println("[ X ] Error, Corrupted DB Line....!")
		return User{}
	}

	mut new_u := User{user_id: arr[0],
		    username: arr[1],
		    email: arr[2],
		    password: arr[3],
		    ip_addr: arr[4],
		    sms_number: arr[5],
		    pin_code: arr[6]}

	if arr[7].i64() > 0 {
		new_u.messa_rank = arr[7].i64()
	}

	//  PIN is not needed but that will be less account protection for users
	if arr[6] != "NO_PIN_CODE" {
		new_u.twofa_toggle = true
		new_u.twofa = TrustSystems_T.pin_code
	}

	// Use SMS Verification Instead
	if arr[5] != "NO_PHONE" {
		new_u.twofa_toggle = true
		new_u.twofa = TrustSystems_T.phone
		return new_u
	}

	return new_u
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

pub fn (mut u User) validate_login(uname string, pword string) bool
{
	if u.username == uname && u.password == pword { return true }
	return false
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

/*
	[@DOC]

	is_empty() bool

	return weather a user is empty or not
*/
pub fn (mut u User) is_empty() bool 
{
	if "${u.user_id}" != "" {
		return true
	}

	return false
}

pub fn generate_uuid() string 
{
	blocked_chars := ['~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '=', '[', ']', '+', '_', '|', '\\', '/', '`', '\'', '\"', '<', '>', '/']
	mut key := ""
	for i in 0..32 {
		num := rand.int_in_range(0, 9) or { 0 }
		key += "${num}"
	}

	return key
}
