import os
import time

import src
import src.cp

fn main() 
{
	mut messagram := src.build_messagram()
	time.sleep(2*time.millisecond)
	cp.prompt()
}