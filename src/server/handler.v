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
	mut new_r := r.parse_cmd_data()

	match r.cmd_t 
	{
		.send_friend_request { }
		.cancel_friend_request { }
		.send_dm_msg {
			chk := m.send_msg_to_user(mut client, (json_data['to_username'] or { "" }).str(), (json_data['data'] or { "" }).str()) 
			client.socket.write_string("{\"status\": \"true\", \"resp_t\": \"push_event\", \"cmd_t\": \"send_dm_msg\", \"from_username\": \"Jeff\", \"to_username\": \"vibe\", \"data\": \"gg\"}\n") or { 0 }
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