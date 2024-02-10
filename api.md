<div align="center">
    <h1> Messagram API & Socket Documentation </h1>
    <p> The freedom of speech on the internet </p>
</div>

```
//
//
//	FOR MESSAGRAM DEVELOPERS WORKING ON THE BACKEND APPLICATION
//
//	QUICK RUN DOWN ON HOW MESSAGRAM WILL BE WORKING
//
//      Important Information:
//
//      List of keys that will always be in JSON data
//               [ Auth Validation ] // SOME COMMANDS WILL NEED HWID
//          - sessionID
//          - HWID
//          - addr_host
//          - addr_ip
//               [ Cmd Validation ]
//          - cmd
//          - from_userid
//          - to_userid
//
```

# How to login for client's SessionID

<p>Request API's Login Endpoint to receive a sessionID for socket</p>
<p>[POST-REQUEST]</p>
```
https://api.messagram.io/auth?username=USERNAME&password=PASSWORD&HWID=
```
<p>A sessionID will be the response if valid, None if invalid</p>
<p>all the next commands will be through client's socket server!</p>

# Client Socket Commands

### How to connect to Messagram Server

[CLIENT-TO-SERVER] Authenication JSON Request To Messagram Server From Client
{
     "cmd": "client_authenication",
     "username": "",
     "sessionID": "",
     "addr_host": "",
     "addr_port": "",
     "hwid": "",
     "client_name": "",
     "client_version": ""
}

[SERVER-RESPONSE] Server Response
{
    "status": "true", // return true on auth success, false on auth failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Successfully logged in" // data to output (OPTIONAL)
}

All other commands contain JSON data that will be used to validate how legitimate is the request (real user request etc)

### How to send a user a friend request

[CLIENT-TO-SERVER] Friend Request JSON Data to Messagram Server
{
     "sessionID": "",
     "hwid": "",
     "addr_host": "",
     "addr_ip": "",
     "cmd": "user_friend_req", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}

[SERVER-RESPONSE] Server Response
{
    "status": "true", // return true on request success and false on request failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Request Sent" // output to user (optional)
}

# How to send a DM message

[CLIENT-TO-SERVER] Send DM Message JSON Data to Messagram Server
{
     "sessionID": "",
     "hwid": "",
     "addr_host": "",
     "addr_ip": "",
     "cmd": "user_dm_msg", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}

[SERVER-RESPONSE] Server Response
{
    "status": "true", // return true on message success and false on message failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Message Sent" // output to user (optional)
}

# How to send a DM message removal

[CLIENT-TO-SERVER] Send DM Message JSON Data to Messagram Server
{
     "sessionID": "",
     "hwid": "",
     "addr_host": "",
     "addr_ip": "",
     "cmd": "user_dm_msg_rm", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}

[SERVER-RESPONSE] Server Response
{
    "status": "true", // return true on removal success and false on removal failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Message Removed" // output to user (optional)
}

# How to send a DM reaction

[CLIENT-TO-SERVER] Send DM Reaction JSON Data to Messagram Server
{
     "sessionID": "",
     "hwid": "",
     "addr_host": "",
     "addr_ip": "",
     "cmd": "user_dm_react", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}

[SERVER-RESPONSE] Server Response
{
    "status": "true", // return true on reaction success and false on reaction failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Reaction Sent" // output to user (optional)
}