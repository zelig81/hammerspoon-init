local socket = require("socket")

local function sleep(sec)
    socket.select(nil, nil, sec)
end

volume = hs.spotify.getVolume()
while( is_spotify_ads_muter_enabled )
do
  local title = hs.spotify.getCurrentTrack()
  if not volume == 0 then
    volume = hs.spotify.getVolume()
  end
  if title == nil then
    hs.alert.show('Spotify is not playing')
    break
  else
    if is_debug then
      print('Spotify is playing: ' .. title .. ' at volume ' .. volume)
    end
    if string.find(title, 'Advertisement') then
      hs.spotify.setVolume(0)
    else
      hs.spotify.setVolume(volume)
    end
  end
  sleep(spotify_ads_muter_interval)
end
