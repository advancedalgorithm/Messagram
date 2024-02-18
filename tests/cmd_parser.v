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

	Keep in mind, This is not an open-source library for the public 
	to use by providing validations. It was created to do whats 
	need for the Messagram Server!
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

	args := os.args.clone()

	if args.len < 1 {
		println("[ X ] Error, No arguments provided\r\nUsage: ${args[0]} <cmd_t>")
		exit(0)
	}
	// Command coming into Messagram Server
	// Using this new information to match the current Client
	test := "	{
			\"cmd_t\": \"${args[1]}\",
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
	mut r := server.response(mut c.info, test) // this goes back to client

	// Generate a response with a signal for action validation procceding 
	r.parse_cmd_data() // generated response for the user or community request has been sent to

	if r.valid_action {
		// do action in thread
		println("${r.data}") // SEND TO OTHER USER
	}

	// modify r.cmd_t to 'Cmd_T.invalid_operation' if the action wasnt successfully done how the user requested!
	
	println("${r.to_str()}") // SENDING BACK TO CLIENT ON SOCKET
	// output: {"cmd_t":"send_friend_request","username":"Jeff","sid":"454353434353455","hwid":"GGG","client_name":"CLIENT_NAME","client_version":"1.0.0","from_username":"Jeff","to_username":"vibe"}
}