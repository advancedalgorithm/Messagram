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

<p>Request API's Login Endpoint to receive a sessionID for client's socket</p>
<p>[GET-REQUEST]</p>

```
https://api.messagram.io/auth?username=USERNAME&password=PASSWORD&HWID=
```

<p>A sessionID will be the response if valid, None if invalid</p>
<p>all the next commands will be through client's socket server!</p>

# Client Socket Commands

### How to connect to Messagram Server

<p>[CLIENT-TO-SERVER] Authenication JSON Request To Messagram Server From Client</p>

```
{
	"cmd_t": "client_authentication"
	"username": "",
	"sid": "",
	"hwid": "",
	"client_name": "",
	"client_version": ""
}
```

<p>[SERVER-RESPONSE] Server Response<p>

```
{
    "status": "true", // return true on auth success, false on auth failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "cmd_t": "invalid_login_info" // data to output (OPTIONAL)
}
```

<p>All other commands contain JSON data that will be used to validate how legitimate is the request (real user request etc)</p>

### How to send a user a friend request

<p>[CLIENT-TO-SERVER] Friend Request JSON Data to Messagram Server</p>

```
{
     "cmd": "user_friend_req", 
     "username": "",
     "sessionID": "",
     "hwid": "",
     "to_username": "",
     "client_name": "",
     "client_version": ""
}
```

<p>[SERVER-RESPONSE] Server Response</p>

```
{
    "status": "true", // return true on request success and false on request failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "cmd": "friend_request_sent" // output to user (optional)
}
```

# How to send a DM message

<p>[CLIENT-TO-SERVER] Send DM Message JSON Data to Messagram Server</p>

```
{
     "cmd": "user_dm_msg", 
     "username": "",
     "sessionID": "",
     "hwid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}
```

<p>[SERVER-RESPONSE] Server Response</p>

```
{
    "status": "true", // return true on message success and false on message failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Message Sent" // output to user (optional)
}
```

# How to send a DM message removal

<p>[CLIENT-TO-SERVER] Send DM Message JSON Data to Messagram Server</p>

```
{
     "sessionID": "",
     "hwid": "",
     "cmd": "user_dm_msg_rm", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}
```

<p>[SERVER-RESPONSE] Server Response</p>

```
{
    "status": "true", // return true on removal success and false on removal failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Message Removed" // output to user (optional)
}
```

# How to send a DM reaction

<p>[CLIENT-TO-SERVER] Send DM Reaction JSON Data to Messagram Server</p>

```
{
     "sessionID": "",
     "hwid": "",
     "cmd": "user_dm_react", 
     "from_userid": "",
     "to_userid": "",
     "data": "",
     "client_name": "",
     "client_version": ""
}
```

<p>[SERVER-RESPONSE] Server Response</p>

```
{
    "status": "true", // return true on reaction success and false on reaction failure
    "resp_t": "user_resp", // user response, signal to allow cmd data for client output
    "data": "Reaction Sent" // output to user (optional)
}
```