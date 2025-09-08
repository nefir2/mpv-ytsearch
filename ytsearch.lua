mp.add_hook("on_load", 50, function() 
	local url = mp.get_property("stream-open-filename");
	local PATTERN = "^ytsearch:(.*)$";
	if (url:find(PATTERN) ~= 1) then return end
	
	local query = url:match(PATTERN);
	if (query == "" or query == nil) then 
		mp.osd_message("there's no query.");
		return 1;
	end

	mp.osd_message("searching: '" .. query .. "'...");
	local ytvid_id = mp.command_native(
	{ 
		name = "subprocess", 
		playback_only = false,
		capture_stdout = true,
		args = { "yt-dlp", url, "--get-id", "--quiet", "--no-warnings" }
	});

	--mp.log
	if (ytvid_id.status == 0 and ytvid_id.stdout ~= "") then
		mp.commandv(
			"loadfile", 
			string.format("https://youtu.be/%s", ytvid_id.stdout),
			"append"
		);
	else mp.osd_message("the video '" .. query .. "' isn't found.");
	end

	return;
end);
