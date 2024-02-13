import os

import src.db_utils as db

pub struct UserProfile
{
	profile_img			string
	banner_img			string
	member_since		string
	badges				string

	// Connections
	discord				string
	x					string
	tiktok				string
	twitch				string
	youtube				string
	facebook			string
	instagram			string
	spotify				string
	reddit				string
	steam				string
	psn					string
	xbox				string
	paypal				string

	status				string
	bio					string

	communities			map[string][]string
}

fn main() 
{
	profile_data := os.read_lines("assets/db/profiles/jeff_p.mg") or { [] }

	if profile_data == [] {
		println("ERROR: UNABLE TO READ FILE")
		return
	}

	mut data := get_block_data(profile_data, "[@STATUS]")
	mut bio := get_block_data(profile_data, "[@BIO]")
	mut roles := get_block_data(profile_data, "[@COMMUNITIES]")
	println("${data}\n\n${bio}\n\n${roles}")
}

fn get_block_data(content []string, block string) string
{
	mut data := ""
	mut start := false
	for line in content
	{
		if line.trim_space() == block {
			start = true
			continue
		} else if line.trim_space() == "{" { continue }
		else if start && line.trim_space() == "}" { break }

		if start {
			data += "${line.trim_space()}"
		}
	}

	return data
}