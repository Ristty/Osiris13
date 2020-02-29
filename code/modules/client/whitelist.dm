#define FILEWHITELIST "config/whitelist.txt"
var/list/ckeywhitelist = list()

//Check player in whitelist
/hook/startup/proc/loadCkeyWhitelist()
	if(config.useckeywhitelist)
		load_ckeywhitelist()
	return 1

/proc/load_ckeywhitelist()
	ckeywhitelist = file2list(FILEWHITELIST)
	if(!ckeywhitelist.len)	ckeywhitelist = null

/proc/CheckWhitelist(key)
	if (!ckeywhitelist)
		return 0
	return (key in ckeywhitelist)


#undef FILEWHITELIST