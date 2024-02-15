import os
import net

import src
import src.server
import src.db_utils as db

/*
	Test & Example Of How to use the Response{} parser/generator

	The parser relys on the current Client Information and new 
	information via JSON data. Client's Account && Connection
	information must be the same every request.
*/

/*
		Command Handler Comparisons

			REGULAR COMMAND HANDLER

		data = socket.input()
		// CHECKING ARGUMENT COUNT OR KEYS IN JSON 
		// VALIDATION TO CHECK EACH ARGUMENT IS RIGHT (PROB 2-3 MORE IF STATEMENTS)
		// MORE IFS STATEMENTS FOR SECURITY PROTECTION (RCE/XSS etc)
		// DO THE ACTIONS REQUESTED
		// YOUR ACTION FUNCTION MOST LIKELY RETURNS A SIGNAL TO CHECK IF ACTION SUCCESSFULLY FINISH OR FAILED
		// LOG ACTION

			MESSAGRAM COMMAND HANDLER

		data = socket.input()
		// CALL PARSER FUNCTION CALL
		// PARSE NEW CMD FUNCTION CALL with a singal to trigger action function call
		// check if action went through
		// send new cmd response
		// LOG ACTION
*/

fn main() 
{
	// Command coming into Messagram Server
	// Using this new information to match the current Client
	test := "	{
			\"cmd_t\": \"send_friend_request\",
			\"username\": \"Jeff\",
			\"sid\": \"454353434353455\",
			\"hwid\": \"GGG\",
			\"client_name\": \"CLIENT_NAME\",
			\"client_version\": \"1.0.0\",
			\"from_username\": \"Jeff\",
			\"to_username\": \"vibe\"
	}"

	// Current Client Information
	mut user_info := db.User{
		user_idx: 0
		user_id: "543545353453",
		username: "Jeff",
		email: "admin@messagram.io",
		password: "testetst342",
		ip_addr: "5.5.5.5", 
		sms_number: "332-454-2432",
		pin_code: "4542",
		messa_rank: 4
	}

	mut c := server.Client{
		info: user_info,
		password: "testetst342",
		sid: "454353434353455"
		host: "5.5.5.5",
		port: 24,
		hwid: "GGG",
		app_name: "CLIENT_NAME",
		app_version: "1.0.0",
		socket: net.TcpConn{}
	}

	// Take the command, Break it down to set objects
	mut r := server.response(mut c.info, test)

	println("${r}")

	// Generate a response with a signal for action validation procceding 
	mut n := r.parse_cmd_data()

	println("${n.jsn_received}")
	// output: {"cmd_t":"send_friend_request","username":"Jeff","sid":"454353434353455","hwid":"GGG","client_name":"CLIENT_NAME","client_version":"1.0.0","from_username":"Jeff","to_username":"vibe"}
}