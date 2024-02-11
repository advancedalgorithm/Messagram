module db_utils

pub struct Invite 
{
	pub mut:
		code		string
		time 		string
		max_users	string
		creator 	string
}

pub enum RolePerms
{
	_none = 0
	_admin = 99
	_view_channel = 1
	_send_message = 2
	_react_message = 3
	
	_delete_message = 4
	_delete_chat = 5
	_delete_role = 6
	_delete_server = 7
}

pub struct Role 
{
	pub mut:
		name 		string
		id 			i64
		perms 		[]RolePerms
		color 		string
}

pub struct Member
{
	pub mut:
		name		User
		roles 		[]Role
}

pub struct BannedUser
{
	pub mut:
		user 		User
		time 		string // perm is string is "perm"
}

pub struct Chat 
{
	/*
		Chat is viewable to roles under the ones in this struct
		when public_toggle is enabled or Private to the specific roles!
	*/
	pub mut:
		name 			string
		id 				string
		public_toggle 	bool 
		roles 			[]Role
}

pub struct Community
{
	pub mut:
		name 					string
		description				string
		accept_new_members		bool
		main_invite				string
		invites					[]Invite
		roles 					[]Role

		members 				[]Member
		chats 					[]Chat
}

pub fn community(content string) Community
{
	return Community{}
}