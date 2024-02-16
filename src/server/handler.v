module server

import net
import x.json2 as jsn

/*
	Handle all commands here. 

	Argument: r has all the JSON data
*/
pub fn (mut m MessagramServer) handle_command(mut client Client, new_data string, json_data map[string]jsn.Any)
{
	mut r := response(mut client.info, new_data)
	r.parse_cmd_data()

	println("Sending socket data back: " + r.to_str())

	match cmd2type((r.jsn_received['cmd_t'] or { return }).str())
	{
		.request_user_search {
			// do action
			// check action success/fail and modify cmd_t to 'no_user_found if needed'
		}
		.send_friend_request { }
		.cancel_friend_request { }
		.send_dm_msg {
			
			println("\x1b[31m${r.jsn_received}\x1b[39m")
			println("\x1b[32m${r.data}\x1b[39m")
			println("\x1b[33m${r.to_str()}\x1b[39m")
			// m.send_msg_to_user(r.to_username, (r.jsn_received['data'] or { "" }).str())
			chk := m.send_msg_to_user((r.jsn_received['to_username'] or { "" }).str(), "${r.data}") 
			client.socket.write_string("${r.data}") or { 0 }
			if !chk { 
				println("ERROR: MESSAGE DIDNT SEND")
				// Send the socket another message using Cmd_T.invalid_operation && Resp_T.user_resp or Resp_T.push_event [OPTIONAL]
			}
			// Return success response to the client
		}
		.send_dm_msg_rm { }
		.send_dm_reaction { } 
		.send_dm_react_rm { }
		else {}
	}

	println("[ + ] New Command Inbound from ${client.info.username} on ${client.app_name}")
}