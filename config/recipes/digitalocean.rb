namespace :digitalocean do
  desc "Initiates new digiocean droplet"
  cmd = "curl -H 'Accept: application/json' \
      -H 'Content-Type: application/http' \
      -X GET \
      https://api.digitalocean.com/droplets/new?client_id=[cYFB4odLWJAsNErFDvV8z]&api_key=[dfa3d99774430d0b34414c6d1e2dd6d4]&name=[#{application}]&size_id=[size_id]&image_id=[image_id]&region_id=[region_id]&ssh_key_ids=[ssh_key_id1],[ssh_key_id2]"
    system(cmd)
end
