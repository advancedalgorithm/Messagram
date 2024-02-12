module server

pub enum Resp_T
{
	_null  			        = 0x20000
	socket_connected		= 0x20001	      // SOCKET SUCCESSFULLY CONNECTED

	invalid_connection		= 0x20002	      // INVALID CONNECTION
	socket_rejected			= 0x20003	      // SOCKET NOT ACCEPTED
	device_banned			= 0x20004	      // DEVICE IS BANNED FROM MESSAGRAM

	user_resp			= 0x20005	      // USER RESPOND (MAINLY REPLYING TO NON-COMMUNITY CMDS)
	push_event			= 0x20006	      // PUSHING EVENT SUCH AS COMMUNITY MESSAGES
	mass_event			= 0x20007	      // SEND A MASS USER EVENT SUCH AS ANNOUNCEMENTS ETC
}

pub enum Cmd_T
{
	_null				= 0x10000
	/*
		Client sends Messagram Server a command with command information to use
		and MessagramServer responds with a success or error  command for developer to build 
		a better error/succes message for users. 
	*/

	// Operation Commands from CLIENTS

	/* Authentication Commands */
        add_sms_auth 			= 0x10002             // SEND NEW PHONE NUMBER FOR VERIFICATION
	add_new_email			= 0x10003             // CHANGE CURRENT EMAIL FOR VERIFICATION
        send_pin_verification_code	= 0x10004	      // SEND PIN VERIFICATION CODE
        send_sms_verification_code 	= 0x10005             // SEND SMS VERIFICATION CODE
        send_email_verification_code	= 0x10006  	      // SEND EMAIL VERIFICATION CODE

	/* Friend Request Commands */
        send_friend_request		= 0x10007             // SEND A FRIEND REQUEST
        cancel_friend_request		= 0x10008             // CANCEL A FRIEND REQUEST

	/* DM Commands */
        send_dm_msg			= 0x10009             // SEND DM MESSAGE
        send_dm_msg_rm			= 0x10010             // SEND DM MESSAGE REMOVAL
        send_dm_reaction		= 0x10011             // SEND DM REACTION
        send_dm_react_rm		= 0x10012             // SEND DM REACTION REMOVAL

	/* Community Commands */
	create_community		= 0x10013             // CREATE A COMMUNITY (LIKE A DISCORD SERVER)
	edit_community		 	= 0x10014	      // Edit Community Info/Settings (EDIT A COMMUNITY SETTINGS OR INFO)
	inv_toggle			= 0x10015             // Enable/Disable Community Invites (EDIT THE INVITE TOGGLE)
	kick_user			= 0x10016             // Kick a user from the community
	ban_user			= 0x10017             // Ban a user from the community
	del_msg				= 0x10018             // Delete a message from the community chat

	/* Roles */
	create_community_role		= 0x10019             // CREATE A ROLE
	edit_community_role		= 0x10020             // EDIT A ROLE (Perms, Color, Rank Level)
	del_community_role		= 0x10021             // DELETE A ROLE

	/* Chats */
	create_community_chat		= 0x10022             // CREATE A NEW CHAT
	edit_community_chat		= 0x10023             // EDIT THE CHAT SETTINGS (Perms, Name, Desc)
	del_community_chat		= 0x10024             // DELETE THE CHAT

	/*
	*	Commands to send to clients
	*
	*	The following commands below are for developers to build a better output message for users
	*	Developers must read the Object file in client libraries or documentations to know what each
	* 	commands means
	*/

	/* GENERAL REQUEST OPERATIONS */
	invalid_cmd			= 0x10026	      // INVALID COMMAND
	invalid_parameters		= 0x10027	      // INVALID PARAMETERS PROVIDED (JSON KEY/VALUES)
	invalid_perm			= 0x10028	      // INVALID PERMS

	invalid_login_info		= 0x10029
	account_perm_ban		= 0x10030
	account_temp_ban		= 0x10031
	force_confirm_email		= 0x10032
	force_device_trust		= 0x10033
	force_add_phone_number_request	= 0x10034
	verify_pin_code			= 0x10035
	verify_sms_code			= 0x10036

	/* FAILED FRIEND REQUEST OPERATIONS */
	failed_to_send_friend_request	= 0x10037
	blocked_by_user			= 0x10038

	/* FAILED DM OPERATIONS */
	dm_sent				= 0x10039
	dm_failed			= 0x10040

	/* FAILED COMMUNITY OPERATIONS */
	invalid_role_perm		= 0x10041
	account_ban			= 0x10042
	dm_msg_received			= 0x10043
	community_msg_received		= 0x10044
}

pub struct Response
{
	pub mut:
		status bool
		resp_t RespT
		cmd_t  Cmd_T
}

pub fn build_json_response(status bool, respt Resp_T, cmdt Cmd_T) Response
{
	return Response {
		status: status,
		resp_t: respt,
		cmd_t: cmdt
	}
}

pub fn resp2type(data string) Resp_T
{
	match data
	{
		"socket_connected" {
			return Resp_T.socket_connected
		}
		"invalid_connection" {
			return Resp_T.invalid_connection
		}
		"socket_rejected" {
			return Resp_T.socket_rejected
		}
		"device_banned" {
			return Resp_T.device_banned
		}
		"user_resp" {
			return Resp_T.user_resp
		}
		"push_event" {
			return Resp_T.push_event
		}
		"mass_event" {
			return Resp_T.mass_event
		}
	}

	return Resp_T._null
}

pub fn cmd2type(data string) Cmd_T {
	match data {
		"add_sms_auth" { return Cmd_T.add_sms_auth }
		"add_new_email" { return Cmd_T.add_new_email }
		"send_pin_verification_code" { return Cmd_T.send_pin_verification_code }
		"send_sms_verification_code" { return Cmd_T.send_sms_verification_code }
		"send_email_verification_code" { return Cmd_T.send_email_verification_code }
		"send_friend_request" { return Cmd_T.send_friend_request }
		"cancel_friend_request" { return Cmd_T.cancel_friend_request }
		"send_dm_msg" { return Cmd_T.send_dm_msg }
		"send_dm_msg_rm" { return Cmd_T.send_dm_msg_rm }
		"send_dm_reaction" { return Cmd_T.send_dm_reaction }
		"send_dm_react_rm" { return Cmd_T.send_dm_react_rm }
		"create_community" { return Cmd_T.create_community }
		"edit_community" { return Cmd_T.edit_community }
		"inv_toggle" { return Cmd_T.inv_toggle }
		"kick_user" { return Cmd_T.kick_user }
		"ban_user" { return Cmd_T.ban_user }
		"del_msg" { return Cmd_T.del_msg }
		"create_community_role" { return Cmd_T.create_community_role }
		"edit_community_role" { return Cmd_T.edit_community_role }
		"del_community_role" { return Cmd_T.del_community_role }
		"create_community_chat" { return Cmd_T.create_community_chat }
		"edit_community_chat" { return Cmd_T.edit_community_chat }
		"del_community_chat" { return Cmd_T.del_community_chat }
		"invalid_cmd" { return Cmd_T.invalid_cmd }
		"invalid_parameters" { return Cmd_T.invalid_parameters }
		"invalid_perm" { return Cmd_T.invalid_perm }
		"invalid_login_info" { return Cmd_T.invalid_login_info }
		"account_perm_ban" { return Cmd_T.account_perm_ban }
		"account_temp_ban" { return Cmd_T.account_temp_ban }
		"force_confirm_email" { return Cmd_T.force_confirm_email }
		"force_device_trust" { return Cmd_T.force_device_trust }
		"force_add_phone_number_request" { return Cmd_T.force_add_phone_number_request }
		"verify_pin_code" { return Cmd_T.verify_pin_code }
		"verify_sms_code" { return Cmd_T.verify_sms_code }
		"failed_to_send_friend_request" { return Cmd_T.failed_to_send_friend_request }
		"blocked_by_user" { return Cmd_T.blocked_by_user }
		"dm_sent" { return Cmd_T.dm_sent }
		"dm_failed" { return Cmd_T.dm_failed }
		"invalid_role_perm" { return Cmd_T.invalid_role_perm }
		"account_ban" { return Cmd_T.account_ban }
		"dm_msg_received" { return Cmd_T.dm_msg_received }
		"community_msg_received" { return Cmd_T.community_msg_received }
	}

	return Cmd_T._null
}

pub fn (mut r Response) get_map_info() map[string]string
{
	return {
		"status": r.status,
		"resp_t": r.resp_t,
		"cmd_t": r.cmd_t
	}
}