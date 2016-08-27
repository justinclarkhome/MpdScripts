function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--### MPD servers to scan ###

mpd_local={}
mpd_local["host"]="localhost"
mpd_local["port"]="6600"

mpd_instances={mpd_bedroom, mpd_livingroom, mpd_local}

function RunProcess(run_string)
    local handle=io.popen(run_string)
    local result=handle:read("*a")
    return result
end

function GetDetailsOfActiveMpdServer(host_port_status)
    host_port_status=host_port_status or "status"
    active_servers=0
    for i,deets in ipairs(mpd_instances) do
        this_host=deets["host"]
        this_port=deets["port"]
    
        run_string="mpc current -h " .. this_host .. " -p " .. this_port
        the_answer=RunProcess(run_string)

        if string.len(the_answer) > 0 then
            active_servers=active_servers + 1
            if host_port_status=="host" then
                return this_host
            elseif host_port_status=="port" then
                return this_port
            elseif host_port_status=="status" then
                return "active"
            else
                return "Unknown argument: " .. host_port_status
            end

            break
        end
    end

    if active_servers==0 then
        return("inactive")
    elseif active_servers > 1 then
        return("multiple servers active")
    end
end

function GetInfo(mpd_host, mpd_port, artist_album_song)
    if artist_album_song=="artist" then
        flag="%artist%"
    elseif artist_album_song=="album" then
        flag="%album%"
    elseif artist_album_song=="song" then
        flag="%title%"
    end

    run_string="mpc current -h " .. mpd_host .. " -p " .. mpd_port .. " -f " .. flag
    the_answer=RunProcess(run_string)
    return trim(the_answer)
 end
    
active_port=GetDetailsOfActiveMpdServer("port")
active_host=GetDetailsOfActiveMpdServer("host")

-- here, "arg" is a vector containing arguments passed from the command line (if any)
-- we evaluate a few specific arguments here, and proceed accordingly
for i, myarg in ipairs(arg) do
    myarg = string.lower(myarg)
    if myarg == "artist" then
        print(GetInfo(active_host, active_port, "artist"))
    elseif myarg == "album" then
        print(GetInfo(active_host, active_port, "album"))
    elseif myarg == "song" then
        print(GetInfo(active_host, active_port, "song"))
    elseif myarg == "status" then
        print(GetDetailsOfActiveMpdServer(myarg))
    end
end
